function [model, trainError, trainErrorVar, estimationOut, stateMatrix ] = TrainFunctionEchoStateNetwork( trainCell, nOutputUnits, nInternalUnits, nForgetPoints, spectralRadius)
%M011_TRAINECHOSTATENETWORK Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 3,      
        nInternalUnits = 500;
    elseif nargin < 4,
        nForgetPoints = 10;
    elseif nargin < 5,
        spectralRadius = 0.1;
    end;

    nInputUnits = length(trainCell{1}(1,:)) - nOutputUnits;
    
%      esn = generate_esn(nInputUnits, nInternalUnits, nOutputUnits, ...
%          'spectralRadius',1.0,'inputScaling',ones(nInputUnits,1)*0.1,'inputShift',zeros(nInputUnits,1), ...
%          'teacherScaling',ones(nOutputUnits,1)*0.3,'teacherShift',ones(nOutputUnits,1)*(-0.2),'feedbackScaling', 0, ...
%          'type', 'plain_esn'); 
     esn = generate_esn(nInputUnits, nInternalUnits, nOutputUnits, ...
         'spectralRadius',spectralRadius,'inputScaling',ones(nInputUnits,1)*1.0,'inputShift',zeros(nInputUnits,1), ...
         'teacherScaling',ones(nOutputUnits,1)*1.0,'teacherShift',ones(nOutputUnits,1)*(0.0),'feedbackScaling', 0.0, ...
         'type', 'plain_esn', 'noiseLevel', 0.001); 

     
    esn.internalWeights = esn.spectralRadius * esn.internalWeights_UnitSR;
    
    
    for nd=1:length(trainCell),
        Train_in{nd,1}  = trainCell{nd}(:,1:nInputUnits);
        Train_out{nd,1} = trainCell{nd}(:,nInputUnits+1:end);
    end;    
    
    %%%% train the ESN
    [model.esn stateMatrix] = train_esn(Train_in, Train_out, esn, nForgetPoints) ; 
    
    %%%% predict
    trainErrorAll = [];
    for nd=1:length(trainCell),
        estimationOut = EstimateESN( model, Train_in{nd,1}, Train_out{nd,1}, nForgetPoints);
        trainErrorAll = [trainErrorAll; mean(abs(Train_out{nd,1}(nForgetPoints+1:end,:) - estimationOut))];
    end;            
    trainError = mean( trainErrorAll );
    trainErrorVar = var( trainErrorAll );
    estimationOut = estimationOut;
    
    
%     %%%% Predict
%     stateIndex = 1;
%     for nd=1:length(trainCell),
%         inAll = [];
%         outAll = [];
% 
%         inAll  = [inAll; Train_in{nd}];
%         outAll  = [outAll; Train_out{nd}];
%         
%         totalstate = [stateMatrix(stateIndex,:) Train_out{nd}(1,:)]';
%         
%         estimationOut = test_esn(inAll, model.esn, nForgetPoints, 'startingState', totalstate);
%         trainError = mean(abs(outAll - estimationOut));
%         trainErrorVar = var(abs(outAll - estimationOut));        
%         
%         stateIndex = stateIndex+length(trainCell{nd});
%     end;   
end

