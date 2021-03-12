function [scores,results_per_grasp,LDAmodels,maxValue]=LDA_MV(trSet,trSetLabels,div,historyTW,DiscrimType)

lastTW=1;

if strcmp(historyTW,'all')
    lastTW=1;
else
    lastTW=abs(str2double(historyTW));
end


LDAmodels=struct([]);
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
scores.stdSuccessRate=[];
% scores.testTWConfAv=[];
% scores.testTWConfStd=[];
% scores.TestMVresults=[];
% scores.TestMVconfAv=[];
% scores.TestMVconfStd=[];
% scores.addTestMVresults=[];
% scores.addTestMVconfAv=[];
% scores.addTestMVconfStd=[];

resultsTrain=zeros(length(trSet{1}),div);
% resultsValid=zeros(size(validSet{1},1),div);

% mv_results=zeros(size(validSet{1},1),div);

trainingDataSet=[];
trainlabels=[];

for j=1:div
        
    trainingDataSet=[trainingDataSet;trSet{j}];
    trainlabels=[trainlabels;trSetLabels];
        
end   

maxValue=max(trainingDataSet);

predictlabels=zeros(size(trSet{1},1),div);


for i=1:div
    
    for j=1:size(trSet{i},2)
        
        trSet{i}(:,j)=trSet{i}(:,j)/maxValue(j);
%         validSet{i}(:,j)=validSet{i}(:,j)/maxValue(j);
    end
        
    LDAmodels{i}=fitcdiscr(trSet{i},trSetLabels,'DiscrimType',DiscrimType);
            
    [predictlabels(:,i),scoreLDA,costLDA]=predict(LDAmodels{i},trSet{i});
    
    ss=100*sum(predictlabels(:,i)==trSetLabels)/size(trSet{1},1);
    
    qerror=resubLoss(LDAmodels{i});
    
    cvmodel = crossval(LDAmodels{i},'kfold',4);
    
%     cverror1= kfoldLoss(cvmodel);
    
    cvIndividualSuccessRate = 100-100*kfoldLoss(cvmodel,'mode','individual');
    
    scores.trainSuccessRate=[scores.trainSuccessRate;ss];
    scores.testSuccessRate=[scores.testSuccessRate;mean(cvIndividualSuccessRate)];
    scores.stdSuccessRate=[scores.stdSuccessRate;std(cvIndividualSuccessRate)];
    
    
    
    
    winners=zeros(length(trSetLabels),1);
    conf=zeros(length(trSetLabels),1);
    
    winners2=zeros(length(trSetLabels),1);
    conf2=zeros(length(trSetLabels),1);
    
    for j=1:length(trSetLabels)
        
        [winners(j),conf(j)]=majorityVote(predictlabels(j,1:i));
        
        if i<=lastTW
            [winners2(j),conf2(j)]=majorityVote(predictlabels(j,1:i));
        else
            [winners2(j),conf2(j)]=majorityVote(predictlabels(j,i-lastTW:i));
        end
        
    end
    
    
    MVsuccessRateTrain=100*sum(winners==trSetLabels)/length(trSetLabels);
    
    scores.TrainMVresults=[scores.TrainMVresults;MVsuccessRateTrain];
    
    scores.TrainMVconfAv=[scores.TrainMVconfAv;mean(conf)];
    
    scores.TrainMVconfStd=[scores.TrainMVconfStd;std(conf)];
    
    MVsuccessRateTrain2=100*sum(winners2==trSetLabels)/length(trSetLabels);
    
    scores.addTrainMVresults=[scores.addTrainMVresults;MVsuccessRateTrain2];
    
    scores.addTrainMVconfAv=[scores.addTrainMVconfAv;mean(conf2)];
    
    scores.addTrainMVconfStd=[scores.addTrainMVconfStd;std(conf2)];
    
    
    disp([num2str(i) '-> per: ' num2str(ss) ' || MV: '  num2str(MVsuccessRateTrain) ' || MV2: ' num2str(MVsuccessRateTrain2) ' || CV: ' num2str(mean(cvIndividualSuccessRate)) ' +- ' num2str(std(cvIndividualSuccessRate))])
    
    
end   



    
    
    
end

