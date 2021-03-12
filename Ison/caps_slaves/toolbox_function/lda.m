%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LDA	Perform a linear discriminant analysis
%
%	Inputs: TrainData,TestData 			- Train,test data arranged in columns
%			TrainClass,TestClass 		- vectors of class membership
%	Outputs:PeTrain,PeTest 				- probability of error
%			TrainPredict,TestPredict 	- predicted values
%			Wg,Cg 						- LDA weights
% (c) Kevin Englehart,1997
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [PeTrain,PeTest,TrainPredict,TestPredict,Wg,Cg, WW, Eig] = lda(TrainData,TestData,TrainClass,TestClass)
N = size(TrainData,1);
Ptrain = size(TrainData,2);
Ptest = size(TestData,2);

% sc = std(TrainData,[],2);
% TrainData =  TrainData + bsxfun(@times,sc./10000,randn(size(TrainData)));

% sc = std(TrainData(:));
% TrainData =  TrainData + sc./10000.*randn(size(TrainData));

K = max(TrainClass);

%%-- Compute the means and the pooled covariance matrix --%%
C = zeros(N,N);
totMean = mean(TrainData')';
temp = zeros(length(totMean),length(totMean));
for l = 1:K;
	idx = find(TrainClass==l);
	Mi(:,l) = mean(TrainData(:,idx)')';
    temp = temp+(Mi(:,l)-totMean)*(Mi(:,l)-totMean)';   % Between-class scatter matrix Sb
	 C = C + cov((TrainData(:,idx)-Mi(:,l)*ones(1,length(idx)))'); %within-class Scatter Matrix Sw
end





C = C./K;
Pphi = 1/K;
Cinv = inv(C);


[V,D] = eig(Cinv*temp);

WW=V(:,1:K-1);
Eig=abs(diag(D));
%%-- Compute the LDA weights --%%
for i = 1:K
	Wg(:,i) = Cinv*Mi(:,i);
	Cg(:,i) = -1/2*Mi(:,i)'*Cinv*Mi(:,i) + log(Pphi)';
end


%%-- Compute the decision functions --%%
Atr = TrainData'*Wg + ones(Ptrain,1)*Cg;
Ate = TestData'*Wg + ones(Ptest,1)*Cg;

errtr = 0;
AAtr = compet(Atr');
% errtr = errtr + sum(sum(abs(AAtr-ind2vec(TrainClass))))/2;
% netr = errtr/Ptrain;
% PeTrain = 1-netr;

TrainPredict = vec2ind(AAtr);

% PeTrain = 1-length(find(TrainPredict - TrainClass))/length(TrainClass);
PeTrain = 100*sum(TrainClass'==TrainPredict)/length(TrainClass);


errte = 0;
AAte = compet(Ate');
% errte = errte + sum(sum(abs(AAte-ind2vec(TestClass))))/2;
% nete = errte/Ptest;
% PeTest = 1-nete;

TestPredict = vec2ind(AAte);

% PeTest = 1-length(find(TestPredict'- TestClass))/length(TestClass);
PeTest=100*sum(TestClass'==TestPredict)/length(TestPredict);

% 
%  for targetclass = 1:11
%     idx = find(TestClass==targetclass);
%     ndecision(targetclass) = length(idx);
%     for predictedClass = 1:11
%         nMatch(targetclass,predictedClass) = sum(TestPredict(idx)==predictedClass);
%         percent(targetclass,predictedClass) = nMatch(targetclass,predictedClass)./ndecision(targetclass);
%     end
%   end
% 
percent=[];

return;
