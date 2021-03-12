% This function applies an Echo- State- Network to the data



function [trainedEsn,Scores,errortest,errortrain,test_time,testtimestd,Con_Matrix_test,Con_Matrix_train]=doESN_Linear_set(trainesn,numInternalUnits,spectralRadius_0_1,l_tresn,testesn,l_teesn,div)


score_test = [];
score_train = [];
score_validation = [];


disp('Generating data ............');

performances=struct([]);

errortrain=struct([]);
errortest=struct([]);
test_time=struct([]);
testtimestd=struct([]);
Con_Matrix_test=struct([]);

Con_Matrix_train=struct([]);

    
% seperate the data

%[trainInputSequence trainOutputSequence testInputSequence testOutputSequence]=sepdata(data,div,ml,stdl,i);

trainInputSequence=struct([]);
trainOutputSequence=struct([]);
testInputSequence=struct([]);
testOutputSequence=struct([]);

%     for j=1:length(trainesn)
%         trainInputSequence{j}=trainesn{j}{i};
%         trainOutputSequence{j}=l_tresn{j}{i};
%     end
%     
%     for j=1:length(testesn)
%         testInputSequence{j}=testesn{j}{i};
%         testOutputSequence{j}=l_teesn{j}{i};
%     end

trainInputSequence=trainesn;
trainOutputSequence=l_tresn;
testInputSequence=testesn;
testOutputSequence=l_teesn;

% generate an esn 

disp('Generating ESN ............');
nInternalUnits = numInternalUnits;
nInputUnits =  size(trainInputSequence{1},2);   
nOutputUnits =  size(trainOutputSequence{1},2); 

esn = generate_esn(nInputUnits, nInternalUnits, nOutputUnits, 'spectralRadius',spectralRadius_0_1,'learningMode', 'offline_multipleTimeSeries', 'reservoirActivationFunction', 'tanh','outputActivationFunction', 'identity','inverseOutputActivationFunction','identity', 'type','plain_esn'); 
esn.internalWeights = esn.spectralRadius * esn.internalWeights_UnitSR;


% train ESN

disp('Training ESN ............');

nForgetPoints = 0;%20 ; % discard the first 100 points
[trainedEsn stateMatrix] = train_esn(trainInputSequence', trainOutputSequence', esn, nForgetPoints) ; 


% save the trained ESN
%     save_esn(trainedEsn, 'esn_subject'); 

% plot the internal states of 4 units
nPoints = 100;%2000 ; 
plot_states(stateMatrix,[1 2 3 4], nPoints, 1, 'traces of first 4 reservoir units') ; 

disp('Testing ESN ............');

predictedTrainOutput = [];
for j=1:length(trainInputSequence)
    predictedTrainOutput{j} = zeros(length(trainInputSequence{j})-nForgetPoints, size(trainOutputSequence{1},2));
    predictedTrainOutput{j} = test_esn(trainInputSequence{j}, trainedEsn, nForgetPoints);
end

calc_time=zeros(length(testOutputSequence),1);

predictedTestOutput = [];
for j=1:length(testOutputSequence)
    predictedTestOutput{j} = zeros(length(testInputSequence{j})-nForgetPoints, size(trainOutputSequence{1},2));
    tic
    predictedTestOutput{j} = test_esn(testInputSequence{j},  trainedEsn, nForgetPoints) ; 
    calc_time(j)=toc;
end

i=1;

test_time{i}=sum(calc_time)/length(testOutputSequence);
testtimestd{i}=std(calc_time);

[all_output_test, av_predicteTestdOutput, success_rate_test, av_confidence_all_test, std_confidence_all_test, av_max_conf_test, std_max_conf_test, errortest{i},Con_Matrix_test{i}] = S_classify2_WR(predictedTestOutput, testOutputSequence, 3, i, 'test',nOutputUnits);
[all_output_train, av_predictedTrainOutput, success_rate_train, av_confidence_all_train, std_confidence_all_train, av_max_conf_train, std_max_conf_train, errortrain{i},Con_Matrix_train{i}] = S_classify2_WR(predictedTrainOutput, trainOutputSequence, 3, i, 'train',nOutputUnits);
%     [all_output_test, av_predicteTestdOutput, success_rate_test, av_confidence_all_test, std_confidence_all_test, av_max_conf_test, std_max_conf_test] = S_classify(predictedTestOutput, testOutputSequence, 3);
%     [all_output_train, av_predictedTrainOutput, success_rate_train, av_confidence_all_train, std_confidence_all_train, av_max_conf_train, std_max_conf_train] = S_classify(predictedTrainOutput, trainOutputSequence, 3);

score_train = [score_train; i success_rate_train av_confidence_all_train std_confidence_all_train av_max_conf_train std_max_conf_train]
score_validation = [score_validation; i success_rate_test av_confidence_all_test std_confidence_all_test av_max_conf_test std_max_conf_test]

performances{i}.score_train=score_train;
performances{i}.score_validation=score_validation;


Scores=performances;

end