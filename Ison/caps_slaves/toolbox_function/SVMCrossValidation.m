function [AA,BB,SaMid,SaEnd,SbMid,SbEnd]=SVMCrossValidation(Fold1,div,historyTW,classesSet,LabelSet,sbjID,clr,tLast,nbmuscles,nbClasses)


disp('-----------------------------------------------------------')
disp('                Classification with SVM')
disp('-----------------------------------------------------------')

disp('Cross-validation between the training set and the validation set.....')



%% classification and cross-validation

% creating the testing set and the training set

%trainingSet=[Fold1{1}.data(:);Fold1{2}.data(:)];
trainingSet=[Fold1{1}.data(1:10),Fold1{2}.data(1:10),Fold1{1}.data(11:20),Fold1{2}.data(11:20),Fold1{1}.data(21:30),Fold1{2}.data(21:30),Fold1{1}.data(31:40),Fold1{2}.data(31:40),Fold1{1}.data(41:end),Fold1{2}.data(41:end)];
%trainingLabels=[Fold1{1}.labels(:);Fold1{2}.labels(:)];
trainingLabels=[Fold1{1}.labels(1:10),Fold1{2}.labels(1:10),Fold1{1}.labels(11:20),Fold1{2}.labels(11:20),Fold1{1}.labels(21:30),Fold1{2}.labels(21:30),Fold1{1}.labels(31:40),Fold1{2}.labels(31:40),Fold1{1}.labels(41:end),Fold1{2}.labels(41:end)];

testingSet=Fold1{3}.data(:);
testingLabels=Fold1{3}.labels(:);

ranT1=random_numbers(20,5,1);
ranT2=random_numbers(15,5,1);
ranT3=random_numbers(10,5,1);
% ranT4=1:5;

crossValidationFolders=struct([]);



crossValidationFolders{1}.data=trainingSet([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1]);
crossValidationFolders{1}.labels=trainingLabels([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1]);

trainingSet([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1])=[];
trainingLabels([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1])=[];



crossValidationFolders{2}.data=trainingSet([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2]);
crossValidationFolders{2}.labels=trainingLabels([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2]);


trainingSet([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2])=[];
trainingLabels([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2])=[];



crossValidationFolders{3}.data=trainingSet([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3]);
crossValidationFolders{3}.labels=trainingLabels([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3]);

trainingSet([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3])=[];
trainingLabels([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3])=[];



crossValidationFolders{4}.data=trainingSet;
crossValidationFolders{4}.labels=trainingLabels;


esnResults=struct([]);
oneesnResults=struct([]);
RBFesnResults=struct([]);
RBFoneesnResults=struct([]);

repCounter=1;

acc_class=struct([]);
g_min_val=0.1;
g_max_val=1;
c_min_val=10;
c_max_val=1000;
step=100;


for gg=g_min_val:0.1:g_max_val
    for cc=c_min_val:step:c_max_val

        scores=struct([]);
        rPG=struct([]);
        esns=struct([]);
        onescores=struct([]);
        onerPG=struct([]);
        oneesns=struct([]);
        
        RBFscores=struct([]);
        RBFrPG=struct([]);
        RBFesns=struct([]);
        RBFonescores=struct([]);
        RBFonerPG=struct([]);
        RBFoneesns=struct([]);
        
        
        for i=1:4

            disp(['repetition: ' num2str(i)])

            validSet=crossValidationFolders{i}.data;
            validSetLabels=crossValidationFolders{i}.labels;

            trSet=[];
            trSetLabels=[];

            for j=1:4
                if j~=i
                    trSet=[trSet;crossValidationFolders{j}.data(:)];
                    trSetLabels=[trSetLabels;crossValidationFolders{j}.labels(:)];
                end
            end

            [SVMtrSet,SVMtrSetLabels]=SVMorganiseData(trSet,trSetLabels,div);
            [SVMvalidSet,SVMvalidSetLabels]=SVMorganiseData(validSet,validSetLabels,div);
            
            % optimization of the SVM
            
            % linear kernel
            
            kernelType=0;

            [scores_rep1,results_per_grasp_rep1,SVMs]=SVM_MV(SVMtrSet,SVMtrSetLabels,SVMvalidSet,SVMvalidSetLabels,div,historyTW,gg,cc,kernelType);
            scores{i}=scores_rep1;
            rPG{i}=results_per_grasp_rep1;
            esns{i}=SVMs;
            
            [scores2_rep1,results_per_grasp2_rep1,oneSVM]=oneSVM_MV(SVMtrSet,SVMtrSetLabels,SVMvalidSet,SVMvalidSetLabels,div,historyTW,gg,cc,8,kernelType);
            onescores{i}=scores2_rep1;
            onerPG{i}=results_per_grasp2_rep1;
            oneesns{i}=oneSVM;
            
            % rbf kernel
            
            kernelType=2;

            [scores_rep1,results_per_grasp_rep1,SVMs]=SVM_MV(SVMtrSet,SVMtrSetLabels,SVMvalidSet,SVMvalidSetLabels,div,historyTW,gg,cc,kernelType);
            RBFscores{i}=scores_rep1;
            RBFrPG{i}=results_per_grasp_rep1;
            RBFesns{i}=SVMs;
            
            [scores2_rep1,results_per_grasp2_rep1,oneSVM]=oneSVM_MV(SVMtrSet,SVMtrSetLabels,SVMvalidSet,SVMvalidSetLabels,div,historyTW,gg,cc,8,kernelType);
            RBFonescores{i}=scores2_rep1;
            RBFonerPG{i}=results_per_grasp2_rep1;
            RBFoneesns{i}=oneSVM;
            
            
        end
        esnResults{repCounter}.scores=scores;
        esnResults{repCounter}.resultsPerGrasp=rPG;
        esnResults{repCounter}.esNet=esns;
        esnResults{repCounter}.gamma=gg;
        esnResults{repCounter}.c=cc;
        
        
        oneesnResults{repCounter}.scores=onescores;
        oneesnResults{repCounter}.resultsPerGrasp=onerPG;
        oneesnResults{repCounter}.esNet=oneesns;
        oneesnResults{repCounter}.gamma=gg;
        oneesnResults{repCounter}.c=cc;
        
        
        RBFesnResults{repCounter}.scores=RBFscores;
        RBFesnResults{repCounter}.resultsPerGrasp=RBFrPG;
        RBFesnResults{repCounter}.esNet=RBFesns;
        RBFesnResults{repCounter}.gamma=gg;
        RBFesnResults{repCounter}.c=cc;
        
        
        RBFoneesnResults{repCounter}.scores=RBFonescores;
        RBFoneesnResults{repCounter}.resultsPerGrasp=RBFonerPG;
        RBFoneesnResults{repCounter}.esNet=RBFoneesns;
        RBFoneesnResults{repCounter}.gamma=gg;
        RBFoneesnResults{repCounter}.c=cc;
        
        repCounter=repCounter+1;
        
        
    end
end


% save(['plots\new_results\sbj' num2str(sbjID) '\CVResults.mat','esnResults','oneesnResults'])



save(['plots\new_results\sbj' num2str(sbjID) '\CVResults' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classesSVM.mat'],'esnResults','oneesnResults','RBFesnResults','RBFoneesnResults','trainingSet','trainingLabels','testingSet','testingLabels')






%% plot results

% tt=-0.150:0.050:tLast;
% 
% AA=[scores_rep1.TestMVresults';scores_rep2.TestMVresults';scores_rep3.TestMVresults'];
% BB=[scores2_rep1.test.twMV.successRate';scores2_rep2.test.twMV.successRate';scores2_rep3.test.twMV.successRate'];
% 
% figure(11)
% hold on
% plot(tt,mean(AA),'Color',clr,'LineWidth',3)
% plot(tt,mean(BB),'Color',clr,'LineStyle','--','LineWidth',3)
% legend('dif ESN','one ESN')
% xlabel('time [sec]')
% ylabel('success rate [%]')
% title([num2str(length(classesSet)) ' classes only forearm'])
% grid on
% errorbar(tt,mean(AA),std(AA),clr)
% errorbar(tt,mean(BB),std(BB),'Color',clr,'LineStyle','--')
% grid on
% 
% 
% SaMid=(results_per_grasp_rep1.MVtw{15}+results_per_grasp_rep2.MVtw{15}+results_per_grasp_rep3.MVtw{15})/3;
% SaEnd=(results_per_grasp_rep1.MVtw{end}+results_per_grasp_rep2.MVtw{end}+results_per_grasp_rep3.MVtw{end})/3;
% 
% SbMid=(results_per_grasp2_rep1{15}+results_per_grasp2_rep2{15}+results_per_grasp2_rep3{15})/3;
% SbEnd=(results_per_grasp2_rep1{end}+results_per_grasp2_rep2{end}+results_per_grasp2_rep3{end})/3;
% 
% 
% plotConfusionMatrix(SaMid,LabelSet,4,['Subject ' num2str(sbjID) ' 0.85 sec dif ESN only forearm'])
% %savefig(['plots\meeting\sbj' num2str(sbjID) '_0.85_difESN_' num2str(length(LabelSet)) 'classes_forearm.fig'])
% plotConfusionMatrix(SaEnd,LabelSet,5,['Subject ' num2str(sbjID) ' 1.5 sec dif ESN only forearm'])
% %savefig(['plots\meeting\sbj' num2str(sbjID) '_1.5_difESN_' num2str(length(LabelSet)) 'classes_forearm.fig'])
% 
% plotConfusionMatrix(SaMid,LabelSet,6,['Subject ' num2str(sbjID) ' 0.85 sec one ESN only forearm'])
% %savefig(['plots\meeting\sbj' num2str(sbjID) '_0.85_oneESN_' num2str(length(LabelSet)) 'classes_forearm.fig'])
% plotConfusionMatrix(SaEnd,LabelSet,7,['Subject ' num2str(sbjID) ' 1.5 sec one ESN only forearm'])
% %savefig(['plots\meeting\sbj' num2str(sbjID) '_1.5_oneESN_' num2str(length(LabelSet)) 'classes_forearm.fig'])
% 
% %close 4 5 6 7




end