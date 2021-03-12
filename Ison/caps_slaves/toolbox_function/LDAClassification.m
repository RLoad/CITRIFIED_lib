function [LDAResults]=LDAClassification(Fold1,div,historyTW,classesSet,LabelSet,sbjID,clr,tLast,nbmuscles,nbClasses)


disp('-----------------------------------------------------------')
disp('                Classification with LDA')
disp('-----------------------------------------------------------')

disp('Cross-validation between the training set and the validation set.....')



%% classification and cross-validation

% creating the testing set and the training set



crossValidationFolders=struct([]);

if length(classesSet)==5
    trainingSet=[Fold1{1}.data(1:10),Fold1{2}.data(1:10),Fold1{1}.data(11:20),Fold1{2}.data(11:20),Fold1{1}.data(21:30),Fold1{2}.data(21:30),Fold1{1}.data(31:40),Fold1{2}.data(31:40),Fold1{1}.data(41:end),Fold1{2}.data(41:end)];
    %trainingLabels=[Fold1{1}.labels(:);Fold1{2}.labels(:)];
    trainingLabels=[Fold1{1}.labels(1:10),Fold1{2}.labels(1:10),Fold1{1}.labels(11:20),Fold1{2}.labels(11:20),Fold1{1}.labels(21:30),Fold1{2}.labels(21:30),Fold1{1}.labels(31:40),Fold1{2}.labels(31:40),Fold1{1}.labels(41:end),Fold1{2}.labels(41:end)];
    
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
    trainingSet=[Fold1{1}.data(1:10),Fold1{2}.data(1:10),Fold1{1}.data(11:20),Fold1{2}.data(11:20),Fold1{1}.data(21:30),Fold1{2}.data(21:30),Fold1{1}.data(31:40),Fold1{2}.data(31:40)];

    trainingLabels=[Fold1{1}.labels(1:10),Fold1{2}.labels(1:10),Fold1{1}.labels(11:20),Fold1{2}.labels(11:20),Fold1{1}.labels(21:30),Fold1{2}.labels(21:30),Fold1{1}.labels(31:40),Fold1{2}.labels(31:40)];
    
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
    trainingSet=[Fold1{1}.data(1:10),Fold1{2}.data(1:10),Fold1{1}.data(11:20),Fold1{2}.data(11:20),Fold1{1}.data(21:30),Fold1{2}.data(21:30)];

    trainingLabels=[Fold1{1}.labels(1:10),Fold1{2}.labels(1:10),Fold1{1}.labels(11:20),Fold1{2}.labels(11:20),Fold1{1}.labels(21:30),Fold1{2}.labels(21:30)];
    
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

AllTrainingScoresManyLDA=[];
AllValidationScoresManyLDA=[];
addAllValidationScoresManyLDA=[];
AllTrainingScoresOneLDA=[];
AllValidationScoresOneLDA=[];
addAllValidationScoresOneLDA=[];

LDAModels=struct([]);
scores=struct([]);
maxValues=struct([]);
ValidationScore=struct([]);
ValidationScoreRpG=struct([]);
oneLDAscores=struct([]);
oneLDArPG=struct([]);
oneLDAModel=struct([]);
oneModelValidationScore=struct([]);
oneModelValidationRpG=struct([]);

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
    
    [LDAtrSet,LDAtrSetLabels]=SVMorganiseData(trSet,trSetLabels,div);
    [LDAvalidSet,LDAvalidSetLabels]=SVMorganiseData(validSet,validSetLabels,div);
    
    
    disp('Training many LDA models')
    disp('------------------------')
    disp('Training performance')
    [scores{i},rPG,LDAModels{i},maxValues{i}]=LDA_MV(LDAtrSet,LDAtrSetLabels,div,historyTW,'pseudoquadratic');
    
    disp('Validation results: ')

    [ValidationScore{i},ValidationScoreRpG{i}]=LDAtest(LDAModels{i},LDAvalidSet,LDAvalidSetLabels,maxValues{i},div,historyTW);
    
    disp('Training one LDA model')
    disp('------------------------')
    disp('Training performance')
    
    [oneLDAscores{i},oneLDArPG{i},oneLDAModel{i}]=oneLDA_MV(LDAtrSet,LDAtrSetLabels,div,historyTW,1,'pseudoquadratic');
    
    disp('Validation results: ')
    
    [oneModelValidationScore{i},oneModelValidationRpG{i}]=LDAtest(oneLDAModel{i},LDAvalidSet,LDAvalidSetLabels,maxValues{i},div,historyTW);
    
    
    AllTrainingScoresManyLDA=[AllTrainingScoresManyLDA;scores{i}.TrainMVresults'];
    AllValidationScoresManyLDA=[AllValidationScoresManyLDA;ValidationScore{i}.TestMVresults'];
    addAllValidationScoresManyLDA=[addAllValidationScoresManyLDA;ValidationScore{i}.addTestMVresults'];
    
    AllTrainingScoresOneLDA=[AllTrainingScoresOneLDA;oneLDAscores{i}.TrainMVresults'];
    AllValidationScoresOneLDA=[AllValidationScoresOneLDA;oneModelValidationScore{i}.TestMVresults'];
    addAllValidationScoresOneLDA=[addAllValidationScoresOneLDA;oneModelValidationScore{i}.addTestMVresults'];

end

OverallResults=struct();

OverallResults.averageTrainScoresManyLDA=mean(AllTrainingScoresManyLDA);
OverallResults.stdTrainScoresManyLDA=std(AllTrainingScoresManyLDA);

OverallResults.averageValidationScoresManyLDA=mean(AllValidationScoresManyLDA);
OverallResults.stdValidationScoresManyLDA=std(AllValidationScoresManyLDA);

OverallResults.averageAddValidationScoresManyLDA=mean(addAllValidationScoresManyLDA);
OverallResults.stdAddValidationScoresManyLDA=std(addAllValidationScoresManyLDA);

OverallResults.averageTrainScoresOneLDA=mean(AllTrainingScoresOneLDA);
OverallResults.stdTrainScoresOneLDA=std(AllTrainingScoresOneLDA);

OverallResults.averageValidationScoresOneLDA=mean(AllValidationScoresOneLDA);
OverallResults.stdValidationScoresOneLDA=std(AllValidationScoresOneLDA);

OverallResults.averageAddValidationScoresOneLDA=mean(addAllValidationScoresOneLDA);
OverallResults.stdAddValidationScoresOneLDA=std(addAllValidationScoresOneLDA);

OverallResults.oneModelValidationScores=oneModelValidationScore;
OverallResults.oneModelValidationRpG=oneModelValidationRpG;

models=findBestPerformance2(LDAModels,ValidationScore);


% performance of the testing set

[LDATestingSet,LDATestingSetLabels]=SVMorganiseData(testingSet,testingLabels,div);

disp('Many LDA models, Testing results: ')

[TestingScore,TestingRpG]=LDAtest(models,LDATestingSet,LDATestingSetLabels,maxValues{1},div,historyTW);

OverallResults.manyModels.testingScores=TestingScore;
OverallResults.manyModels.testingresultsPerGrasp=TestingRpG;

disp('One LDA model, Testing results: ')

[oneModelValidationScore,oneModelValidationRpG]=LDAtest(oneLDAModel{1},LDATestingSet,LDATestingSetLabels,maxValues{1},div,historyTW);
            
OverallResults.oneModel.testingScores=oneModelValidationScore;
OverallResults.oneModel.testingresultsPerGrasp=oneModelValidationRpG;


OverallResults.TrainingScores=scores;
OverallResults.LDAModels=LDAModels;
OverallResults.maxValues=maxValues;

OverallResults.ValidationScore=ValidationScore;
OverallResults.ValidationScoreRpG=ValidationScoreRpG;

OverallResults.oneLDATrainingScores=oneLDAscores;
OverallResults.oneLDArPG=oneLDArPG;
OverallResults.oneLDAModel=oneLDAModel;




LDAResults=OverallResults;

save(['data/amputee' num2str(sbjID) '/results/CVResults' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classesLDANormalizedTime.mat'],'OverallResults','trainingSet','trainingLabels','testingSet','testingLabels','maxValues')









end