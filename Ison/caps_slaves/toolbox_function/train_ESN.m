function [esNet,bestPerf,ValidationSuccessRates,results_per_grasp]=train_ESN(trainesn,l_tresn,testesn,l_teesn,nUnits,spectralRadius,historyTW)
% 
% results_per_grasp=struct([]);
% 
% scores=struct();
% scores.train.twESN=struct();
% scores.train.twMV=struct();
% scores.test.twESN=struct();
% scores.test.twMV=struct();
% 
% scores.train.twMV=struct();
% scores.train.twMV.successRate=[];
% scores.train.twMV.confAv=[];
% scores.train.twMV.confStd=[];
% 
% 
% scores.train.twESN=struct();
% scores.train.twESN.successRate=[];
% scores.train.twESN.confAv=[];
% scores.train.twESN.confStd=[];
% 
% 
% scores.test.twESN=struct();
% scores.test.twESN.successRate=[];
% scores.test.twESN.confAv=[];
% scores.test.twESN.confStd=[];
% 
% scores.test.twMV=struct();
% scores.test.twMV.successRate=[];
% scores.test.twMV.confAv=[];
% scores.test.twMV.confStd=[];




lastTW=1;

if strcmp(historyTW,'all')
    lastTW=1;
else
    lastTW=abs(str2double(historyTW));
end


trainingDataSet=struct([]);
trainlabels=struct([]);


trueOutputTrain2=[];
for i=1:length(trainesn)
    for j=1:length(trainesn{i})
        [~,tmptrueOutputTrain]=max(l_tresn{i}{j}(1,:));
        trueOutputTrain2=[trueOutputTrain2;tmptrueOutputTrain];
    end
end


trueOutputTest2=[];
for i=1:length(testesn)
    for j=1:length(testesn{i})
        [~,tmptrueOutputTest]=max(l_teesn{i}{j}(1,:));
        trueOutputTest2=[trueOutputTest2;tmptrueOutputTest];
        
    end
end

trueOutputTrain=zeros(length(trainesn),1);
for i=1:length(trainesn)
    [~,trueOutputTrain(i)]=max(l_tresn{i}{1}(1,:));
end

trueOutputTest=zeros(length(testesn),1);
for i=1:length(testesn)
    [~,trueOutputTest(i)]=max(l_teesn{i}{1}(1,:));
end

count=1;
for i=1:length(trainesn)
    for j=1:length(trainesn{i})
        
        trainingDataSet{count}=trainesn{i}{j};
        trainlabels{count}=l_tresn{i}{j};
        count=count+1;
        
    end   
end

rand( 'seed', 100 );

randomRounds=struct([]);
successRateTest=[];
successRateTrain=[];

for rround=1:10

    disp(['round: ' num2str(rround)])
    

 % generate an esn 
    myflage=true;
    while myflage
        try
            disp('Generating ESN ............');
            nInternalUnits = nUnits;
            nInputUnits =  size(trainingDataSet{1},2);   
            nOutputUnits =  size(trainlabels{1},2); 

            esn = generate_esn(nInputUnits, nInternalUnits, nOutputUnits, 'spectralRadius',spectralRadius,'learningMode', 'offline_multipleTimeSeries', 'reservoirActivationFunction', 'tanh','outputActivationFunction', 'identity','inverseOutputActivationFunction','identity', 'type','plain_esn'); 
            esn.internalWeights = esn.spectralRadius * esn.internalWeights_UnitSR;
            myflage=false;
        catch
            disp('failed to generate an ESN \n start again \n')
        end
    end

    % train ESN

    disp('Training ESN ............');

    nForgetPoints = 1 ; % discard the first 100 points
    [trainedEsn stateMatrix] = train_esn(trainingDataSet', trainlabels', esn, nForgetPoints) ; 
    
    
    
    % validate ESN on training set
    disp('Predicting output of the training data ............');
    
    
    timeWindowOutputTrain=[];

    for j=1:length(trainingDataSet)
        predictedTrainOutput=test_esn(trainingDataSet{j}, trainedEsn, nForgetPoints);
        [val,predictedOutput]=max(sum(predictedTrainOutput));
       
        timeWindowOutputTrain=[timeWindowOutputTrain;predictedOutput];
        
        sorted=sort(sum(predictedTrainOutput));
        
        TWconfs(j)=(sorted(end)-sorted(end-1))/sorted(end);
        
    end

    tmpsuccessRateTrain=(sum(timeWindowOutputTrain==trueOutputTrain2)/length(trainingDataSet))*100;
    
    successRateTrain=[successRateTrain;tmpsuccessRateTrain];
    
    % validate ESN on validation set
    
    disp([])
    disp('Predicting output of the validation data ............');
    disp([]')

    timeWindowOutputTest=[];

    for j=1:length(testesn)
        for i=1:length(testesn{j})
        
            predictedOutput=test_esn(testesn{j}{i}, trainedEsn, nForgetPoints);
            [val,predictedClass]=max(sum(predictedOutput));

            timeWindowOutputTest=[timeWindowOutputTest;predictedClass];
            
            sorted=sort(sum(predictedOutput));

            TWconfs(j)=(sorted(end)-sorted(end-1))/sorted(end);

        end
    end
    
    tmpsuccessRateTest=(sum(timeWindowOutputTest==trueOutputTest2)/length(trueOutputTest2))*100;

    successRateTest=[successRateTest;tmpsuccessRateTest];
    
    
    models{rround}=trainedEsn;
    
    
    
end


[bestPerf,bestModel]=max(successRateTest);
    

esNet=models(bestModel);

ValidationSuccessRates=zeros(6,1);

for j=1:3
    
    timeWindowOutputTest=[];
    
    for i=1:length(testesn)
        
        predictedOutput=test_esn(testesn{i}{j}, trainedEsn, nForgetPoints);
        [val,predictedClass]=max(sum(predictedOutput));

        timeWindowOutputTest=[timeWindowOutputTest;predictedClass];
            
%         sorted=sort(sum(predictedOutput));

%         TWconfs(j)=(sorted(end)-sorted(end-1))/sorted(end);

    end
    ValidationSuccessRates(j)=(sum(timeWindowOutputTest==trueOutputTest)/length(testesn))*100;
    results_per_grasp{j}=predictionPerGrasp(timeWindowOutputTest,trueOutputTest);
    
end

disp(['number of units: ' num2str(nUnits) ', spectral radius: ' num2str(spectralRadius) ', best performance: ' num2str(bestPerf)])
disp(ValidationSuccessRates')







end