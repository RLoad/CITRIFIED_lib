function [scores,results_per_grasp,esNet]=oneESN_NV(trainesn,l_tresn,testesn,l_teesn,div,nUnits,historyTW,spectralRadius,startTW)

results_per_grasp=struct([]);

scores=struct();
scores.train.twESN=struct();
scores.train.twMV=struct();
scores.test.twESN=struct();
scores.test.twMV=struct();

scores.train.twMV=struct();
scores.train.twMV.successRate=[];
scores.train.twMV.confAv=[];
scores.train.twMV.confStd=[];


scores.train.twESN=struct();
scores.train.twESN.successRate=[];
scores.train.twESN.confAv=[];
scores.train.twESN.confStd=[];


scores.test.twESN=struct();
scores.test.twESN.successRate=[];
scores.test.twESN.confAv=[];
scores.test.twESN.confStd=[];

scores.test.twMV=struct();
scores.test.twMV.successRate=[];
scores.test.twMV.confAv=[];
scores.test.twMV.confStd=[];




lastTW=1;

if strcmp(historyTW,'all')
    lastTW=1;
else
    lastTW=abs(str2double(historyTW));
end


trainingDataSet=struct([]);
trainlabels=struct([]);




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
    for j=startTW:div
        
        trainingDataSet{count}=trainesn{i}{j};
        trainlabels{count}=l_tresn{i}{j};
        count=count+1;
        
    end   
end


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

nForgetPoints = 10 ; % discard the first 100 points
[trainedEsn stateMatrix] = train_esn(trainingDataSet', trainlabels', esn, nForgetPoints) ; 
    
    
disp('Predict output of the training data ............');
    

timeWindowOutputTrain=zeros(length(trainesn),1);
allTWOutputsTrain=zeros(length(trainesn),div);

for i=1:div
    TWconfs=zeros(length(trainesn),1);
    for j=1:length(trainesn)
        predictedTrainOutput=test_esn(trainesn{j}{i}, trainedEsn, nForgetPoints);
        [val,timeWindowOutputTrain(j)]=max(sum(predictedTrainOutput));
       
        sorted=sort(sum(predictedTrainOutput));
        
        TWconfs(j)=(sorted(end)-sorted(end-1))/sorted(end);
        
    end
    
    successRateTrain=(sum(timeWindowOutputTrain==trueOutputTrain)/length(trainesn))*100;
    
    %scores.train.twESN{i}=struct();
    scores.train.twESN.successRate=[scores.train.twESN.successRate;successRateTrain];
    scores.train.twESN.confAv=[scores.train.twESN.confAv;mean(TWconfs)];
    scores.train.twESN.confStd=[scores.train.twESN.confStd;std(TWconfs)];
    
    allTWOutputsTrain(:,i)=timeWindowOutputTrain;
    
    winners2=zeros(length(trainesn),1);
    conf2=zeros(length(trainesn),1);
    
    for j=1:length(trainesn)
        
        if i<=lastTW
            [winners2(j),conf2(j)]=majorityVote(allTWOutputsTrain(j,1:i));
        else
            [winners2(j),conf2(j)]=majorityVote(allTWOutputsTrain(j,i-lastTW:i));
        end
        
    end
    
    MVsuccessRateTrain=(sum(winners2==trueOutputTrain)/length(trainesn))*100;
    
    %scores.train.twMV{i}=struct();
    scores.train.twMV.successRate=[scores.train.twMV.successRate;MVsuccessRateTrain];
    scores.train.twMV.confAv=[scores.train.twMV.confAv;mean(conf2)];
    scores.train.twMV.confStd=[scores.train.twMV.confStd;std(conf2)];
    
    disp([num2str(i) '   |  ' num2str(scores.train.twESN.successRate(i)) '  |  ' num2str(scores.train.twESN.confAv(i)) '+-' num2str(scores.train.twESN.confStd(i)) '   ||   ' num2str(scores.train.twMV.successRate(i)) '   ' num2str(scores.train.twMV.confAv(i)) '+-' num2str(scores.train.twMV.confStd(i))])
    
end

disp([])
disp('Predict output of the validation data ............');
disp([]')

timeWindowOutputTest=zeros(length(testesn),1);
allTWOutputsTest=zeros(length(testesn),div);

for i=1:div
    TWconfs=zeros(length(testesn),1);
    for j=1:length(testesn)
        predictedOutput=test_esn(testesn{j}{i}, trainedEsn, nForgetPoints);
        [val,timeWindowOutputTest(j)]=max(sum(predictedOutput));
       
        sorted=sort(sum(predictedOutput));
        
        TWconfs(j)=(sorted(end)-sorted(end-1))/sorted(end);
        
    end
    
    successRateTest=(sum(timeWindowOutputTest==trueOutputTest)/length(testesn))*100;
    
    %scores.test.twESN{i}=struct();
    scores.test.twESN.successRate=[scores.test.twESN.successRate;successRateTest];
    scores.test.twESN.confAv=[scores.test.twESN.confAv;mean(TWconfs)];
    scores.test.twESN.confStd=[scores.test.twESN.confStd;std(TWconfs)];
    
    allTWOutputsTest(:,i)=timeWindowOutputTest;
    
    winners2=zeros(length(testesn),1);
    conf2=zeros(length(testesn),1);
    
    for j=1:length(testesn)
        
        if i<=lastTW
            [winners2(j),conf2(j)]=majorityVote(allTWOutputsTest(j,1:i));
        else
            [winners2(j),conf2(j)]=majorityVote(allTWOutputsTest(j,i-lastTW:i));
        end
        
    end
    
    MVsuccessRateTest=(sum(winners2==trueOutputTest)/length(testesn))*100;
    
    results_per_grasp{i}=predictionPerGrasp(timeWindowOutputTest,trueOutputTest);
    
    %scores.test.twMV{i}=struct();
    scores.test.twMV.successRate=[scores.test.twMV.successRate;MVsuccessRateTest];
    scores.test.twMV.confAv=[scores.test.twMV.confAv;mean(conf2)];
    scores.test.twMV.confStd=[scores.test.twMV.confStd;std(conf2)];
    
    disp([num2str(i) '   |  ' num2str(scores.test.twESN.successRate(i)) '  |  ' num2str(scores.test.twESN.confAv(i)) '+-' num2str(scores.test.twESN.confStd(i)) '   ||   ' num2str(scores.test.twMV.successRate(i)) '  |  ' num2str(scores.test.twMV.confAv(i)) '+-' num2str(scores.test.twMV.confStd(i))])
    
end




esNet=trainedEsn





end