function [trainedEsn,successRateTest,successRates,results_per_grasp]=train_ESN2(trainesn,l_tresn,testesn,l_teesn,nUnits,spectralRadius)





trainingDataSet=struct([]);
trainlabels=struct([]);


trueOutputTrain2=[];
for i=1:length(trainesn)
    for j=1:length(trainesn{i})
        [~,tmptrueOutputTrain]=max(l_tresn{i}{j}(1,:));
        trueOutputTrain2=[trueOutputTrain2;tmptrueOutputTrain];
    end
end



trueOutputTrain=zeros(length(trainesn),1);
for i=1:length(trainesn)
    [~,trueOutputTrain(i)]=max(l_tresn{i}{1}(1,:));
end



count=1;
for i=1:length(trainesn)
    for j=1:length(trainesn{i})
        
        trainingDataSet{count}=trainesn{i}{j};
        trainlabels{count}=l_tresn{i}{j};
        count=count+1;
        
    end   
end



randomRounds=struct([]);
successRateTest=[];
successRateTrain=[];

    

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

successRates=zeros(1,size(testesn,1));

results_per_grasp=zeros(size(testesn,1),length(l_teesn{1,1}{1}(1,:)));

predictedOutputs=struct([]);

predOuts=[];
trueOuts=[];

for i=1:size(testesn,1)
        
    conPredOut=[];
    conTrueOut=[];
    
    for j=1:size(testesn,2)
        for k=1:length(testesn{i,j})
            
            predictedOutput=test_esn(testesn{i,j}{k}, trainedEsn, nForgetPoints);
            [~,predictedClass]=max(sum(predictedOutput));
            predictedOutputs{i,j}{k}=predictedClass;
            predOuts=[predOuts;predictedClass];  
            conPredOut=[conPredOut;predictedClass];            
            
            [~,tmp]=max(l_teesn{i,j}{k}(1,:));
            trueOuts=[trueOuts;tmp];
            conTrueOut=[conTrueOut;tmp];
        end
    end
    
    successRates(i)=(sum(conPredOut==conTrueOut)/length(conTrueOut))*100;
    
    for c=1:length(l_teesn{1,1}{1}(1,:))
        truO=conTrueOut(conTrueOut==c);
        proO=conPredOut(conTrueOut==c);
        results_per_grasp(i,c)=(sum(proO==truO)/length(truO))*100;
    end
        
    
    
end
    

successRateTest=(sum(predOuts==trueOuts)/length(trueOuts))*100;



end