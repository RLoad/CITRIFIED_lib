function [oneESNSs,oneESNRpG]=ESNCrossValidation2(Fold1,aeTr,div,nUn,historyTW,classesSet,LabelSet,sbjID,clr,tLast,nbmuscles,nbClasses)


disp('-----------------------------------------------------------')
disp('                Classification with ESN')
disp('-----------------------------------------------------------')

disp('Cross-validation between the training set and the validation set.....')



%% classification and cross-validation

% creating the testing set and the training set

crossValidationFolders=struct([]);

if length(classesSet)==5
    trainingSet=[aeTr{1}.data(1:10),aeTr{2}.data(1:10),aeTr{1}.data(11:20),aeTr{2}.data(11:20),aeTr{1}.data(21:30),aeTr{2}.data(21:30),aeTr{1}.data(31:40),aeTr{2}.data(31:40),aeTr{1}.data(41:end),aeTr{2}.data(41:end)];
    %trainingLabels=[Fold1{1}.labels(:);Fold1{2}.labels(:)];
    trainingLabels=[aeTr{1}.labels(1:10),aeTr{2}.labels(1:10),aeTr{1}.labels(11:20),aeTr{2}.labels(11:20),aeTr{1}.labels(21:30),aeTr{2}.labels(21:30),aeTr{1}.labels(31:40),aeTr{2}.labels(31:40),aeTr{1}.labels(41:end),aeTr{2}.labels(41:end)];
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
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
    
  
    
end

if length(classesSet)==4
    trainingSet=[aeTr{1}.data(1:10),aeTr{2}.data(1:10),aeTr{1}.data(11:20),aeTr{2}.data(11:20),aeTr{1}.data(21:30),aeTr{2}.data(21:30),aeTr{1}.data(31:40),aeTr{2}.data(31:40)];

    trainingLabels=[aeTr{1}.labels(1:10),aeTr{2}.labels(1:10),aeTr{1}.labels(11:20),aeTr{2}.labels(11:20),aeTr{1}.labels(21:30),aeTr{2}.labels(21:30),aeTr{1}.labels(31:40),aeTr{2}.labels(31:40)];
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
    crossValidationFolders{1}.data=trainingSet([ranT1;20+ranT1;40+ranT1;60+ranT1]);
    crossValidationFolders{1}.labels=trainingLabels([ranT1;20+ranT1;40+ranT1;60+ranT1]);

    trainingSet([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
    trainingLabels([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
    
    crossValidationFolders{2}.data=trainingSet([ranT2;15+ranT2;30+ranT2;45+ranT2]);
    crossValidationFolders{2}.labels=trainingLabels([ranT2;15+ranT2;30+ranT2;45+ranT2]);


    trainingSet([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
    trainingLabels([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
    
    crossValidationFolders{3}.data=trainingSet([ranT3;10+ranT3;20+ranT3;30+ranT3]);
    crossValidationFolders{3}.labels=trainingLabels([ranT3;10+ranT3;20+ranT3;30+ranT3]);

    trainingSet([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];
    trainingLabels([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];

    crossValidationFolders{4}.data=trainingSet;
    crossValidationFolders{4}.labels=trainingLabels;

    
    
    
end
   
if length(classesSet)==3
    trainingSet=[aeTr{1}.data(1:10),aeTr{2}.data(1:10),aeTr{1}.data(11:20),aeTr{2}.data(11:20),aeTr{1}.data(21:30),aeTr{2}.data(21:30)];

    trainingLabels=[aeTr{1}.labels(1:10),aeTr{2}.labels(1:10),aeTr{1}.labels(11:20),aeTr{2}.labels(11:20),aeTr{1}.labels(21:30),aeTr{2}.labels(21:30)];
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
    crossValidationFolders{1}.data=trainingSet([ranT1;20+ranT1;40+ranT1]);
    crossValidationFolders{1}.labels=trainingLabels([ranT1;20+ranT1;40+ranT1]);

    trainingSet([ranT1;20+ranT1;40+ranT1])=[];
    trainingLabels([ranT1;20+ranT1;40+ranT1])=[];
    
    crossValidationFolders{2}.data=trainingSet([ranT2;15+ranT2;30+ranT2]);
    crossValidationFolders{2}.labels=trainingLabels([ranT2;15+ranT2;30+ranT2]);


    trainingSet([ranT2;15+ranT2;30+ranT2])=[];
    trainingLabels([ranT2;15+ranT2;30+ranT2])=[];
    
    crossValidationFolders{3}.data=trainingSet([ranT3;10+ranT3;20+ranT3]);
    crossValidationFolders{3}.labels=trainingLabels([ranT3;10+ranT3;20+ranT3]);

    trainingSet([ranT3;10+ranT3;20+ranT3])=[];
    trainingLabels([ranT3;10+ranT3;20+ranT3])=[];

    crossValidationFolders{4}.data=trainingSet;
    crossValidationFolders{4}.labels=trainingLabels;
end


testingSet=Fold1{3}.data(:);
testingLabels=Fold1{3}.labels(:);


esnResults=struct([]);
oneesnResults=struct([]);
repCounter=1;

% for spectralRadius=0.3:0.3
%     for nUn=80:80

        scores=struct([]);
        rPG=struct([]);
        esns=struct([]);
        onescores=struct([]);
        onerPG=struct([]);
        oneesns=struct([]);
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

            % optimization of the ESN

%             [scores_rep1,results_per_grasp_rep1,esNs]=ESN_NV(trSet,trSetLabels,validSet,validSetLabels,20,120,historyTW,1);
%             scores{i}=scores_rep1;
%             rPG{i}=results_per_grasp_rep1;
%             esns{i}=esNs;
            
            [scores2_rep1,results_per_grasp2_rep1,oneEsn]=oneESN_NV(trSet,trSetLabels,validSet,validSetLabels,14,120,historyTW,0.7,8);
            onescores{i}=scores2_rep1;
            onerPG{i}=results_per_grasp2_rep1;
            oneesns{i}=oneEsn;
            
            
        end
%         esnResults{repCounter}.scores=scores;
%         esnResults{repCounter}.resultsPerGrasp=rPG;
%         esnResults{repCounter}.esNet=esns;
%         esnResults{repCounter}.spectralRadius=0.3;
%         esnResults{repCounter}.internalUnits=90;
        
        
        oneesnResults{repCounter}.scores=onescores;
        oneesnResults{repCounter}.resultsPerGrasp=onerPG;
        oneesnResults{repCounter}.esNet=oneesns;
        oneesnResults{repCounter}.spectralRadius=0.7;
        oneesnResults{repCounter}.internalUnits=110;
        repCounter=repCounter+1;
        
%         
%     end
% end


% [bEst]=findBestPerformance(esnResults,20,4);
% [Ss,RpG]=ESNTest(bEst,testingSet,testingLabels,div,'8');

[oneESNbEst]=findBestPerformanceOneESN2(oneesnResults,14,4);
[oneESNSs,oneESNRpG]=ESNTest2(oneESNbEst,testingSet,testingLabels,div,'8');

clrs={'b','r','m','g'};


if nbmuscles>6
    
    figure(nbClasses)
    hold on
    plot(-0.15:0.05:length(oneESNSs.TestMVresults)*0.05-0.155,oneESNSs.TestMVresults,'Color',clrs{sbjID},'LineWidth',2)
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['all muscleset- ' num2str(nbClasses) ' clasees'])
    grid on
    
else
    figure(10+nbClasses)
    hold on
    plot(-0.15:0.05:length(oneESNSs.TestMVresults)*0.05-0.155,oneESNSs.TestMVresults,'Color',clrs{sbjID},'LineWidth',2)
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['forearm muscles- ' num2str(nbClasses) ' clasees'])
    grid on
end




% save(['plots\new_results\sbj' num2str(sbjID) '\CVResults' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classesESN.mat'],'esnResults','oneesnResults','trainingSet','trainingLabels','testingSet','testingLabels','bEst','Ss','RpG','oneESNbEst','oneESNSs','oneESNRpG')
% save(['data/amputee' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classesESNnormTime.mat'],'esnResults','oneesnResults','trainingSet','trainingLabels','testingSet','testingLabels','bEst','Ss','RpG','oneESNbEst','oneESNSs','oneESNRpG')

% save(['data/amputee' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classesESN_AE_14032017.mat'],'esnResults','oneesnResults','trainingSet','trainingLabels','testingSet','testingLabels','oneESNbEst','oneESNSs','oneESNRpG')








end