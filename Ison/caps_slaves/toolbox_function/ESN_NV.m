function [scores,results_per_grasp,esNets]=ESN_NV(trainesn,l_tresn,testesn,l_teesn,div,nUnits,historyTW,spectralRadius)

lastTW=1;

if strcmp(historyTW,'all')
    lastTW=1;
else
    lastTW=abs(str2double(historyTW));
end

results_per_grasp=struct();

results_per_grasp.ESNtw=struct([]);
results_per_grasp.MVtw=struct([]);
results_per_grasp.conf=[];

scores=struct();

scores.trainSuccessRate=[];
scores.trainTWConfAv=[];
scores.trainTWConfStd=[];
scores.TrainMVresults=[];
scores.TrainMVconfAv=[];    
scores.TrainMVconfStd=[];
scores.addTrainMVresults=[];
scores.addTrainMVconfAv=[];
scores.addTrainMVconfStd=[];


scores.testSuccessRate=[];
scores.testTWConfAv=[];
scores.testTWConfStd=[];
scores.TestMVresults=[];
scores.TestMVconfAv=[];
scores.TestMVconfStd=[];
scores.addTestMVresults=[];
scores.addTestMVconfAv=[];
scores.addTestMVconfStd=[];


trueOutputTrain=zeros(length(trainesn),1);
for i=1:length(trainesn)
    [~,trueOutputTrain(i)]=max(l_tresn{i}{1}(1,:));
end

trueOutputTest=zeros(length(testesn),1);
for i=1:length(testesn)
    [~,trueOutputTest(i)]=max(l_teesn{i}{1}(1,:));
end

allTWOutputsTrain=zeros(length(trainesn),div);
allTWOutputsTest=zeros(length(testesn),div);

mv_results=zeros(length(testesn),div);

esNets=struct([]);

for i=1:div
    
    timeWindowOutputTrain=zeros(length(trainesn),1);
    timeWindowOutputTest=zeros(length(testesn),1);
    
    trainInputSequence=struct([]);
    trainOutputSequence=struct([]);
    testInputSequence=struct([]);
    testOutputSequence=struct([]);
    
    for j=1:length(trainesn)
        trainInputSequence{j}=trainesn{j}{i};
        trainOutputSequence{j}=l_tresn{j}{i};
    end
    
    for j=1:length(testesn)
        testInputSequence{j}=testesn{j}{i};
        testOutputSequence{j}=l_teesn{j}{i};
    end
        
    
    % generate an esn 
    myflage=true;
    while myflage
        try
            disp('Generating ESN ............');
            nInternalUnits = nUnits;
            nInputUnits =  size(trainInputSequence{1},2);   
            nOutputUnits =  size(trainOutputSequence{1},2); 
    
            esn = generate_esn(nInputUnits, nUnits, nOutputUnits, 'spectralRadius',spectralRadius,'learningMode', 'offline_multipleTimeSeries', 'reservoirActivationFunction', 'tanh','outputActivationFunction', 'identity','inverseOutputActivationFunction','identity', 'type','plain_esn'); 
            esn.internalWeights = esn.spectralRadius * esn.internalWeights_UnitSR;
            myflage=false;
        catch
            disp('failed to generate an ESN \n start again \n')
        end
    end
    
    % train ESN
    
    disp('Training ESN ............');

    nForgetPoints = 10 ; % discard the first 10 points
    [trainedEsn stateMatrix] = train_esn(trainInputSequence', trainOutputSequence', esn, nForgetPoints) ; 
    
    
    disp('Predict output of the training data ............');
    
    TWconfs=zeros(length(trainesn),1);
    
    predictedTrainOutput = [];
    for j=1:length(trainInputSequence)
        predictedTrainOutput{j} = zeros(length(trainInputSequence{j})-nForgetPoints, size(trainOutputSequence{1},2));
        predictedTrainOutput{j} = test_esn(trainInputSequence{j}, trainedEsn, nForgetPoints);
        [val,timeWindowOutputTrain(j)]=max(sum(predictedTrainOutput{j}));
        
        sorted=sort(sum(predictedTrainOutput{j}));
        
        TWconfs(j)=(sorted(end)-sorted(end-1))/sorted(end);
        
    end
    
    successRateTrain=100*sum(timeWindowOutputTrain==trueOutputTrain)/length(trainesn);

    scores.trainSuccessRate=[scores.trainSuccessRate;successRateTrain];
    
    allTWOutputsTrain(:,i)=timeWindowOutputTrain;
    
    scores.trainTWConfAv=[scores.trainTWConfAv;mean(TWconfs)];
    scores.trainTWConfStd=[scores.trainTWConfStd;std(TWconfs)];
    
    winners=zeros(length(trainInputSequence),1);
    conf=zeros(length(trainInputSequence),1);
    winners2=zeros(length(trainInputSequence),1);
    conf2=zeros(length(trainInputSequence),1);
    
    for j=1:length(trainInputSequence)
        
        [winners(j),conf(j)]=majorityVote(allTWOutputsTrain(j,1:i));
        
        if i<=lastTW
            [winners2(j),conf2(j)]=majorityVote(allTWOutputsTrain(j,1:i));
        else
            [winners2(j),conf2(j)]=majorityVote(allTWOutputsTrain(j,i-lastTW:i));
        end
        
    end
    
    MVsuccessRateTrain=100*sum(winners==trueOutputTrain)/length(trainesn);
    
    scores.TrainMVresults=[scores.TrainMVresults;MVsuccessRateTrain];
    
    scores.TrainMVconfAv=[scores.TrainMVconfAv;mean(conf)];
    
    scores.TrainMVconfStd=[scores.TrainMVconfStd;std(conf)];
    
    MVsuccessRateTrain2=sum(winners2==trueOutputTrain)/length(trainesn);
    
    scores.addTrainMVresults=[scores.addTrainMVresults;MVsuccessRateTrain2];
    
    scores.addTrainMVconfAv=[scores.addTrainMVconfAv;mean(conf2)];
    
    scores.addTrainMVconfStd=[scores.addTrainMVconfStd;std(conf2)];
    
    
    
    disp('Predict output of the validation data ............');

    TWconfs=zeros(length(testesn),1);
    
    predictedTestOutput = [];
    for j=1:length(testOutputSequence)
        
        predictedTestOutput{j} = zeros(length(testInputSequence{j})-nForgetPoints, size(trainOutputSequence{1},2));

        predictedTestOutput{j} = test_esn(testInputSequence{j},  trainedEsn, nForgetPoints) ; 

        [val,timeWindowOutputTest(j)]=max(sum(predictedTestOutput{j}));
        
        sorted=sort(sum(predictedTestOutput{j}));
        
        TWconfs(j)=(sorted(end)-sorted(end-1))/sorted(end);
        
    end
    
    successRateTest=100*sum(timeWindowOutputTest==trueOutputTest)/length(testesn);
    
    results_per_grasp.ESNtw{i}=predictionPerGrasp(timeWindowOutputTest,trueOutputTest);
    
    scores.testSuccessRate=[scores.testSuccessRate;successRateTest];
    
    allTWOutputsTest(:,i)=timeWindowOutputTest;
    
    scores.testTWConfAv=[scores.testTWConfAv;mean(TWconfs)];
    scores.testTWConfStd=[scores.testTWConfStd;std(TWconfs)];
    
    winners=zeros(length(testOutputSequence),1);
    conf=zeros(length(testOutputSequence),1);
    
    winners2=zeros(length(testOutputSequence),1);
    conf2=zeros(length(testOutputSequence),1);
    
    for j=1:length(testOutputSequence)
        
        [winners(j),conf(j)]=majorityVote(allTWOutputsTest(j,1:i));
        
        if i<=lastTW
            [winners2(j),conf2(j)]=majorityVote(allTWOutputsTest(j,1:i));
        else
            [winners2(j),conf2(j)]=majorityVote(allTWOutputsTest(j,i-lastTW:i));
        end
        
    end
    
    mv_results(:,i)=winners2;
    
    %plotconfusion(winners2,trueOutputTest)
    
    MVsuccessRateTest=100*sum(winners==trueOutputTest)/length(testesn);
    
    results_per_grasp.MVtw{i}=predictionPerGrasp(winners2,trueOutputTest);
    
    cc=confPerGrasp(winners2,trueOutputTest,conf2);
    
    results_per_grasp.conf=[results_per_grasp.conf;cc];
    
    scores.TestMVresults=[scores.TestMVresults;MVsuccessRateTest];
    
    scores.TestMVconfAv=[scores.TestMVconfAv;mean(conf)];
    
    scores.TestMVconfStd=[scores.TestMVconfStd;std(conf)];
    
    MVsuccessRateTest2=sum(winners2==trueOutputTest)/length(testesn);
    
    scores.addTestMVresults=[scores.addTestMVresults;MVsuccessRateTest2];
    
    scores.addTestMVconfAv=[scores.addTestMVconfAv;mean(conf2)];
    
    scores.addTestMVconfStd=[scores.addTestMVconfStd;std(conf2)];
    
    esNets{i}=trainedEsn;
    
%     disp(['time window:  ' num2str(i)])
%     disp([''])
    disp('Train:')
    [i scores.trainSuccessRate(end) scores.trainTWConfAv(end) scores.trainTWConfStd(end) scores.TrainMVresults(end) scores.TrainMVconfAv(end) scores.TrainMVconfStd(end)]
    disp('Validation:')
    [i scores.testSuccessRate(end) scores.testTWConfAv(end) scores.testTWConfStd(end) scores.TestMVresults(end) scores.TestMVconfAv(end) scores.TestMVconfStd(end)]
end



results_per_grasp.mv_r=mv_results;




end