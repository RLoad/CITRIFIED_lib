function outputWeights = pseudoinverse(stateCollectMat, teachCollectMat)

% PSEUDOINVERSE computes the outputWeights using the standard pseudoinverse
% operation
%
% inputs:
% stateCollectMat = matrix of size (nTrainingPoints-nForgetPoints) x
% nInputUnits + nInternalUnits 
% stateCollectMat(i,j) = internal activation of unit j after the 
% (i + nForgetPoints)th training point has been presented to the network
% teacherCollectMat is a nSamplePoints * nOuputUnits matrix that keeps
% the expected output of the ESN
% teacherCollectMat is the transformed(scaled, shifted etc) output see
% compute_teacher for more documentation
%
% output:
% outputWeights = vector of size (nInputUnits + nInternalUnits) x 1
% containing the learnt weights
%


% Created April 30, 2006, D. Popovici
% Copyright: Fraunhofer IAIS 2006 / Patent pending

  
% outW1=inv(stateCollectMat'*stateCollectMat);
% 
% outW2=outW1*stateCollectMat';
% 
% outW3=outW2*teachCollectMat;

% Tikhonov regularization:

lamda=0.5;

outputWeights=((inv(lamda*eye(size(stateCollectMat,2))+stateCollectMat'*stateCollectMat)*stateCollectMat')*teachCollectMat)';


% outputWeights = (pinv(stateCollectMat)*teachCollectMat)' ; 

% [Q,R]=qr(stateCollectMat,0);
% 
% outputWeights=(R\(Q'*teachCollectMat))';
