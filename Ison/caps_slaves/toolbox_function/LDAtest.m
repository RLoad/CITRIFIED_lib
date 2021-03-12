function [scores,results_per_grasp]=LDAtest(LDAModel,DataSet,LabelSet,maxValue,div,historyTW)

lastTW=1;

if strcmp(historyTW,'all')
    lastTW=1;
else
    lastTW=abs(str2double(historyTW));
end


scores=struct();
results_per_grasp=struct();

results_per_grasp.ESNtw=struct([]);
results_per_grasp.MVtw=struct([]);
results_per_grasp.conf=[];

scores.testSuccessRate=[];
scores.TestMVresults=[];
scores.testTWConfAv=[];
scores.testTWConfStd=[];
scores.TestMVresults=[];
scores.TestMVconfAv=[];
scores.TestMVconfStd=[];
scores.addTestMVresults=[];
scores.addTestMVconfAv=[];
scores.addTestMVconfStd=[];

predictlabels=zeros(size(DataSet{1},1),div);

% resultsValid=zeros(size(DataSet{1},1),div);

mv_results=zeros(size(DataSet{1},1),div);

for i=1:div
    
    for j=1:size(DataSet{i},2)
        
        DataSet{i}(:,j)=DataSet{i}(:,j)/maxValue(j);

    end
    
    if length(LDAModel)==1
        [predictlabels(:,i),scoreLDA,costLDA]=predict(LDAModel,DataSet{i});
    else
        [predictlabels(:,i),scoreLDA,costLDA]=predict(LDAModel{i},DataSet{i});
    end
    
    ss=100*sum(predictlabels(:,i)==LabelSet)/length(LabelSet);

    scores.testSuccessRate=[scores.testSuccessRate;ss];
%     scores.testSuccessRate=[scores.testSuccessRate;mean(cvIndividualSuccessRate)];
%     scores.stdSuccessRate=[scores.stdSuccessRate;std(cvIndividualSuccessRate)];
    
    
    
    
    winners=zeros(length(LabelSet),1);
    conf=zeros(length(LabelSet),1);
    
    winners2=zeros(length(LabelSet),1);
    conf2=zeros(length(LabelSet),1);
    
    for j=1:length(LabelSet)
        
        [winners(j),conf(j)]=majorityVote(predictlabels(j,1:i));
        
        if i<=lastTW
            [winners2(j),conf2(j)]=majorityVote(predictlabels(j,1:i));
        else
            [winners2(j),conf2(j)]=majorityVote(predictlabels(j,i-lastTW:i));
        end
        
    end
    
    
    MVsuccessRateTrain=100*sum(winners==LabelSet)/length(LabelSet);
    
    scores.TestMVresults=[scores.TestMVresults;MVsuccessRateTrain];
    
    scores.TestMVconfAv=[scores.TestMVconfAv;mean(conf)];
    
    scores.TestMVconfStd=[scores.TestMVconfStd;std(conf)];
    
    MVsuccessRateTrain2=100*sum(winners2==LabelSet)/length(LabelSet);
    
    scores.addTestMVresults=[scores.addTestMVresults;MVsuccessRateTrain2];
    
    scores.addTestMVconfAv=[scores.addTestMVconfAv;mean(conf2)];
    
    scores.addTestMVconfStd=[scores.addTestMVconfStd;std(conf2)];
    
    results_per_grasp.MVtw{i}=predictionPerGrasp(winners2,LabelSet);

    cc=confPerGrasp(winners2,LabelSet,conf2);
    
    results_per_grasp.conf=[results_per_grasp.conf;cc];
    
    
    
    disp([num2str(i) '-> per: ' num2str(ss) ' || MV: '  num2str(MVsuccessRateTrain) ' || MV2: ' num2str(MVsuccessRateTrain2) ])
    
    
end 




results_per_grasp.mv_r=mv_results;


end