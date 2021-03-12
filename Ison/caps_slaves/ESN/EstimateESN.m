function [ estimationOut totalstate] = EstimateESN( model, dataIn, dataOut, nForgetPoints)
%ESTIMATEESN Summary of this function goes here
%   Detailed explanation goes here
    
    esn = model.esn;
    nbSamples = length(dataIn(:,1));
    
    % Initialize
    totalstate    = zeros(esn.nInputUnits + esn.nInternalUnits + esn.nOutputUnits, 1);
    internalState = zeros(esn.nInternalUnits, 1);    
    
%     for ns = 1:nForgetPoints,     
%         in = esn.inputScaling .* dataIn(ns,:)' + esn.inputShift;   % in is column vector
%         totalstate(esn.nInternalUnits+1:esn.nInternalUnits + esn.nInputUnits) = in;
%         internalState = plain_esn(totalstate, esn);
%         %internalState = feval(esn.type, totalstate, esn, []) ; 
%         %netOut = feval(esn.outputActivationFunction, esn.outputWeights * [internalState; in]);
%         netOut = dataOut(ns,:)';
%         totalstate = [internalState; in; netOut];
%     end;
% 
% 
%     % estimation
%     estimationOut = [];    
%     for ns = nForgetPoints+1:nbSamples,
%         in = esn.inputScaling .* dataIn(ns,:)' + esn.inputShift;   % in is column vector
%         totalstate(esn.nInternalUnits+1:esn.nInternalUnits + esn.nInputUnits) = in;
%         
%         internalState = plain_esn(totalstate, esn);
%         %internalState = feval(esn.type, totalstate, esn, []) ; 
%         netOut = feval(esn.outputActivationFunction, esn.outputWeights * [internalState; in]);
%         
%         totalstate = [internalState; in; netOut];
%         
%         estimationOut = [estimationOut; netOut'];
%     end;    
    
    
    for ns = 1:nForgetPoints,     
        [ netOut, totalstate ] = EstimateESN_each( esn, dataIn(ns,:)', dataOut(ns,:)', totalstate, 1);
    end;
    
    estimationOut = [];    
    for ns = nForgetPoints+1:nbSamples,
        [ netOut, totalstate ] = EstimateESN_each( esn, dataIn(ns,:)', dataOut(ns,:)', totalstate, 0);
        estimationOut = [estimationOut; netOut];
    end;
end

        