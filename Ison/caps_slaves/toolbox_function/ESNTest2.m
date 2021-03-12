function [scores,results_per_grasp]=ESNTest2(esnModel,dataSet,labelsSet,div,historyTW)


lastTW=1;

if strcmp(historyTW,'all')
    lastTW=1;
else
    lastTW=abs(str2double(historyTW));
end

trueOutputTest=zeros(length(dataSet),1);
for i=1:length(dataSet)
    [~,trueOutputTest(i)]=max(labelsSet{i}{1}(1,:));
end


results_per_grasp=struct();

results_per_grasp.ESNtw=struct([]);
results_per_grasp.MVtw=struct([]);
results_per_grasp.conf=[];

scores=struct();


scores.testSuccessRate=[];
scores.testTWConfAv=[];
scores.testTWConfStd=[];
scores.TestMVresults=[];
scores.TestMVconfAv=[];
scores.TestMVconfStd=[];
scores.addTestMVresults=[];
scores.addTestMVconfAv=[];
scores.addTestMVconfStd=[];

allTWOutputsTest=zeros(length(dataSet),div);
mv_results=zeros(length(dataSet),div);

for i=1:div
    
    testInputSequence=struct([]);
    testOutputSequence=struct([]);
    
    timeWindowOutputTest=zeros(length(dataSet),1);
    
    for j=1:length(dataSet)
        testInputSequence{j}=dataSet{j}{i};
        testOutputSequence{j}=labelsSet{j}{i};
    end
    
    predictedTestOutput = [];
    nForgetPoints=10;
    for j=1:length(testOutputSequence)
        
        predictedTestOutput{j} = zeros(length(testInputSequence{j})-nForgetPoints, size(testOutputSequence{1},2));

        predictedTestOutput{j} = test_esn(testInputSequence{j},  esnModel, nForgetPoints) ; 

        [val,timeWindowOutputTest(j)]=max(sum(predictedTestOutput{j}));
        
        sorted=sort(sum(predictedTestOutput{j}));
        
        TWconfs(j)=(sorted(end)-sorted(end-1))/sorted(end);
        
    end
    
    
    
    successRateTest=100*sum(timeWindowOutputTest==trueOutputTest)/length(dataSet);
    
    results_per_grasp.ESNtw{i}=predictionPerGrasp(timeWindowOutputTest,trueOutputTest);
    
    scores.testSuccessRate=[scores.testSuccessRate;successRateTest];
    
    allTWOutputsTest(:,i)=timeWindowOutputTest;
    
    scores.testTWConfAv=[scores.testTWConfAv;mean(TWconfs)];
    scores.testTWConfStd=[scores.testTWConfStd;std(TWconfs)];
    
    winners=zeros(length(testOutputSequence),1);
    conf=zeros(length(testOutputSequence),1);
    
    winners2=zeros(length(testOutputSequence),1);
    conf2=zeros(length(testOutputSequence),1);
    
    for j=1:length(testOutputSequence)
        
        [winners(j),conf(j)]=majorityVote(allTWOutputsTest(j,1:i));
        
        if i<=lastTW
            [winners2(j),conf2(j)]=majorityVote(allTWOutputsTest(j,1:i));
        else
            [winners2(j),conf2(j)]=majorityVote(allTWOutputsTest(j,i-lastTW:i));
        end
        
    end
    
    mv_results(:,i)=winners2;
    
    %plotconfusion(winners2,trueOutputTest)
    
    MVsuccessRateTest=100*sum(winners==trueOutputTest)/length(dataSet);
    
    results_per_grasp.MVtw{i}=predictionPerGrasp(winners2,trueOutputTest);
    
    cc=confPerGrasp(winners2,trueOutputTest,conf2);
    
    results_per_grasp.conf=[results_per_grasp.conf;cc];
    
    scores.TestMVresults=[scores.TestMVresults;MVsuccessRateTest];
    
    scores.TestMVconfAv=[scores.TestMVconfAv;mean(conf)];
    
    scores.TestMVconfStd=[scores.TestMVconfStd;std(conf)];
    
    MVsuccessRateTest2=100*sum(winners2==trueOutputTest)/length(dataSet);
    
    scores.addTestMVresults=[scores.addTestMVresults;MVsuccessRateTest2];
    
    scores.addTestMVconfAv=[scores.addTestMVconfAv;mean(conf2)];
    
    scores.addTestMVconfStd=[scores.addTestMVconfStd;std(conf2)];
    
    
end


results_per_grasp.mv_r=mv_results;

% figure(5)
% plot(-0.150:0.050:2.50,scores.TestMVresults)
% hold on
% plot(-0.150:0.050:2.50,scores.addTestMVresults)
% grid on





end