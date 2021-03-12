clear all,
close all,


load data_subject7;

load esn_subject;

trainedEsn = esn_subject;

nForgetPoints = 100;

inputSequence = data_cell;
% inputSequence = data_pca;
outputSequence = output_cell;




score_test = [];
score_train = [];


 predictedOutput = [];
for i=1:length(outputSequence)
   predictedOutput{i} = zeros(length(inputSequence{i})-nForgetPoints, size(outputSequence{1},2));  
   predictedOutput{i} = test_esn(inputSequence{i},  trainedEsn, nForgetPoints) ; 
end


[av_predicteTestdOutput, success_rate_test] = S_classify(predictedOutput, outputSequence, 3);


