function [scores,results_per_grasp,SVMmodels]=SVM_MV(trSet,trSetLabels,validSet,validSetLabels,div,historyTW,gh,ch,kernelType)


lastTW=1;

if strcmp(historyTW,'all')
    lastTW=1;
else
    lastTW=abs(str2double(historyTW));
end


SVMmodels=struct([]);
scores=struct();
results_per_grasp=struct();

results_per_grasp.ESNtw=struct([]);
results_per_grasp.MVtw=struct([]);
results_per_grasp.conf=[];


scores.trainSuccessRate=[];
scores.trainTWConfAv=[];
scores.trainTWConfStd=[];
scores.TrainMVresults=[];
scores.TrainMVconfAv=[];    
scores.TrainMVconfStd=[];
scores.addTrainMVresults=[];
scores.addTrainMVconfAv=[];
scores.addTrainMVconfStd=[];


scores.testSuccessRate=[];
scores.testTWConfAv=[];
scores.testTWConfStd=[];
scores.TestMVresults=[];
scores.TestMVconfAv=[];
scores.TestMVconfStd=[];
scores.addTestMVresults=[];
scores.addTestMVconfAv=[];
scores.addTestMVconfStd=[];

resultsTrain=zeros(length(trSet{1}),div);
resultsValid=zeros(size(validSet{1},1),div);

mv_results=zeros(size(validSet{1},1),div);

trainingDataSet=[];
trainlabels=[];

for j=1:div
        
    trainingDataSet=[trainingDataSet;trSet{j}];
    trainlabels=[trainlabels;trSetLabels];
        
end   

maxValue=max(trainingDataSet);

for i=1:div
    
    for j=1:size(trSet{i},2)
        
        trSet{i}(:,j)=trSet{i}(:,j)/maxValue(j);
        validSet{i}(:,j)=validSet{i}(:,j)/maxValue(j);
    end
    
    %# train one-against-all models
    SVMmodels{i} = svmtrain(trSetLabels, trSet{i}, [' -s 0 -t ' num2str(kernelType) ' -g ' num2str(gh) ' -c ' num2str(ch)]);
    
    
    %# get probability estimates of test instances using each model
    [resultsTrain(:,i), TrainAccuracy, TrianDecision] = svmpredict(trSetLabels, trSet{i}, SVMmodels{i});

    
    [resultsValid(:,i), ValidationAccuracy, ValidationDecision] = svmpredict(validSetLabels, validSet{i}, SVMmodels{i});
    
    scores.trainSuccessRate=[scores.trainSuccessRate;TrainAccuracy(1)];
    scores.testSuccessRate=[scores.testSuccessRate;ValidationAccuracy(1)];
    
    
    winners=zeros(length(trSetLabels),1);
    conf=zeros(length(trSetLabels),1);
    
    winners2=zeros(length(trSetLabels),1);
    conf2=zeros(length(trSetLabels),1);
    
    for j=1:length(trSetLabels)
        
        [winners(j),conf(j)]=majorityVote(resultsTrain(j,1:i));
        
        if i<=lastTW
            [winners2(j),conf2(j)]=majorityVote(resultsTrain(j,1:i));
        else
            [winners2(j),conf2(j)]=majorityVote(resultsTrain(j,i-lastTW:i));
        end
        
    end
    
    
    MVsuccessRateTrain=100*sum(winners==trSetLabels)/length(trSetLabels);
    
    scores.TrainMVresults=[scores.TrainMVresults;MVsuccessRateTrain];
    
    scores.TrainMVconfAv=[scores.TrainMVconfAv;mean(conf)];
    
    scores.TrainMVconfStd=[scores.TrainMVconfStd;std(conf)];
    
    MVsuccessRateTrain2=sum(winners2==trSetLabels)/length(trSetLabels);
    
    scores.addTrainMVresults=[scores.addTrainMVresults;MVsuccessRateTrain2];
    
    scores.addTrainMVconfAv=[scores.addTrainMVconfAv;mean(conf2)];
    
    scores.addTrainMVconfStd=[scores.addTrainMVconfStd;std(conf2)];
    
    
    winners=zeros(length(validSetLabels),1);
    conf=zeros(length(validSetLabels),1);
    
    winners2=zeros(length(validSetLabels),1);
    conf2=zeros(length(validSetLabels),1);
    
    for j=1:length(validSetLabels)
        
        [winners(j),conf(j)]=majorityVote(resultsValid(j,1:i));
        
        if i<=lastTW
            [winners2(j),conf2(j)]=majorityVote(resultsValid(j,1:i));
        else
            [winners2(j),conf2(j)]=majorityVote(resultsValid(j,i-lastTW:i));
        end
        
    end
    
    mv_results(:,i)=winners2;
    MVsuccessRateTest=100*sum(winners==validSetLabels)/size(validSet{1},1);
    
    results_per_grasp.MVtw{i}=predictionPerGrasp(winners2,validSetLabels);
    
    cc=confPerGrasp(winners2,validSetLabels,conf2);
    
    results_per_grasp.conf=[results_per_grasp.conf;cc];
    
    scores.TestMVresults=[scores.TestMVresults;MVsuccessRateTest];
    
    scores.TestMVconfAv=[scores.TestMVconfAv;mean(conf)];
    
    scores.TestMVconfStd=[scores.TestMVconfStd;std(conf)];
    
    MVsuccessRateTest2=100*sum(winners2==validSetLabels)/size(validSet{1},1);
    
    scores.addTestMVresults=[scores.addTestMVresults;MVsuccessRateTest2];
    
    scores.addTestMVconfAv=[scores.addTestMVconfAv;mean(conf2)];
    
    scores.addTestMVconfStd=[scores.addTestMVconfStd;std(conf2)];
    
end


results_per_grasp.mv_r=mv_results;



end