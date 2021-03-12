function [scores,esNets]=trainESNClassifier(trainesn,l_tresn,testesn,l_teesn,div,nUnits,spectralRadius)

scores=struct();

scores.trainSuccessRate=[];

scores.valSuccessRate=[];

esNets=struct([]);

trueOutputTrain=zeros(length(trainesn),1);
for i=1:length(trainesn)
    [~,trueOutputTrain(i)]=max(l_tresn{i}{1}(1,:));
end

trueOutputTest=zeros(length(testesn),1);
for i=1:length(testesn)
    [~,trueOutputTest(i)]=max(l_teesn{i}{1}(1,:));
end


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
            disp('failed to generate an ESN starting again ')
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
    
    scores.valSuccessRate=[scores.valSuccessRate;successRateTest];
    
   
    
    esNets{i}=trainedEsn;

    disp(['nTW: ' num2str(i) 'Training score: ' num2str(scores.trainSuccessRate(end)) 'Validation score: ' scores.testSuccessRate(end)])

end




end