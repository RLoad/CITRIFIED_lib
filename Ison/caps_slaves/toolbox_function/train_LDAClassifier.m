function [oneESNSs,oneESNRpG]=train_LDAClassifier(dataFolder1,dataFolder2,dataFolder3,testingSet,div,historyTW,classesSet,LabelSet,sbjID,clr,tLast,nbmuscles,nbClasses)


disp('-----------------------------------------------------------')
disp('                Classification with LDA')
disp('-----------------------------------------------------------')

disp('Cross-validation between the training set and the validation set.....')



%% classification and cross-validation

% creating the testing set and the training set

crossValidationFolders1=struct([]);
crossValidationFolders2=struct([]);
crossValidationFolders3=struct([]);


if length(classesSet)==5
    
    trainingSet1=[dataFolder1{1}.data(1:10),dataFolder1{2}.data(1:10),dataFolder1{1}.data(11:20),dataFolder1{2}.data(11:20),dataFolder1{1}.data(21:30),dataFolder1{2}.data(21:30),dataFolder1{1}.data(31:40),dataFolder1{2}.data(31:40),dataFolder1{1}.data(41:end),dataFolder1{2}.data(41:end)];
    trainingLabels1=[dataFolder1{1}.labels(1:10),dataFolder1{2}.labels(1:10),dataFolder1{1}.labels(11:20),dataFolder1{2}.labels(11:20),dataFolder1{1}.labels(21:30),dataFolder1{2}.labels(21:30),dataFolder1{1}.labels(31:40),dataFolder1{2}.labels(31:40),dataFolder1{1}.labels(41:end),dataFolder1{2}.labels(41:end)];
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
        
%     ranT1=random_numbers(floor(length(trainingSet1)/4)-1,5,1);
%     ranT2=random_numbers(floor(length(trainingSet1)/4)-1-length(ranT1),5,1);
%     ranT1=random_numbers(floor(length(trainingSet1)/4)-1-length(ranT1)-length(ranT2),5,1);
%     
    crossValidationFolders1{1}.data=trainingSet1([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1]);
    crossValidationFolders1{1}.labels=trainingLabels1([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1]);

    trainingSet1([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1])=[];
    trainingLabels1([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1])=[];
    
    crossValidationFolders1{2}.data=trainingSet1([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2]);
    crossValidationFolders1{2}.labels=trainingLabels1([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2]);


    trainingSet1([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2])=[];
    trainingLabels1([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2])=[];
    
    crossValidationFolders1{3}.data=trainingSet1([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3]);
    crossValidationFolders1{3}.labels=trainingLabels1([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3]);

    trainingSet1([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3])=[];
    trainingLabels1([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3])=[];

    crossValidationFolders1{4}.data=trainingSet1;
    crossValidationFolders1{4}.labels=trainingLabels1;
    
  
    %-------------------------------------%
    
    trainingSet2=[dataFolder2{1}.data(1:10),dataFolder2{2}.data(1:10),dataFolder2{1}.data(11:20),dataFolder2{2}.data(11:20),dataFolder2{1}.data(21:30),dataFolder2{2}.data(21:30),dataFolder2{1}.data(31:40),dataFolder2{2}.data(31:40),dataFolder2{1}.data(41:end),dataFolder2{2}.data(41:end)];
    trainingLabels2=[dataFolder2{1}.labels(1:10),dataFolder2{2}.labels(1:10),dataFolder2{1}.labels(11:20),dataFolder2{2}.labels(11:20),dataFolder2{1}.labels(21:30),dataFolder2{2}.labels(21:30),dataFolder2{1}.labels(31:40),dataFolder2{2}.labels(31:40),dataFolder2{1}.labels(41:end),dataFolder2{2}.labels(41:end)];
 
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
    crossValidationFolders2{1}.data=trainingSet2([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1]);
    crossValidationFolders2{1}.labels=trainingLabels2([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1]);

    trainingSet2([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1])=[];
    trainingLabels2([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1])=[];
    
    crossValidationFolders2{2}.data=trainingSet2([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2]);
    crossValidationFolders2{2}.labels=trainingLabels2([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2]);


    trainingSet2([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2])=[];
    trainingLabels2([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2])=[];
    
    crossValidationFolders2{3}.data=trainingSet2([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3]);
    crossValidationFolders2{3}.labels=trainingLabels2([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3]);

    trainingSet2([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3])=[];
    trainingLabels2([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3])=[];

    crossValidationFolders2{4}.data=trainingSet2;
    crossValidationFolders2{4}.labels=trainingLabels2;
    
   
    %-------------------------------------%
    
    
    trainingSet3=[dataFolder3{1}.data(1:10),dataFolder3{2}.data(1:10),dataFolder3{1}.data(11:20),dataFolder3{2}.data(11:20),dataFolder3{1}.data(21:30),dataFolder3{2}.data(21:30),dataFolder3{1}.data(31:40),dataFolder3{2}.data(31:40),dataFolder3{1}.data(41:end),dataFolder3{2}.data(41:end)];
    trainingLabels3=[dataFolder3{1}.labels(1:10),dataFolder3{2}.labels(1:10),dataFolder3{1}.labels(11:20),dataFolder3{2}.labels(11:20),dataFolder3{1}.labels(21:30),dataFolder3{2}.labels(21:30),dataFolder3{1}.labels(31:40),dataFolder3{2}.labels(31:40),dataFolder3{1}.labels(41:end),dataFolder3{2}.labels(41:end)];
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
    crossValidationFolders3{1}.data=trainingSet3([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1]);
    crossValidationFolders3{1}.labels=trainingLabels3([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1]);

    trainingSet3([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1])=[];
    trainingLabels3([ranT1;20+ranT1;40+ranT1;60+ranT1;80+ranT1])=[];
    
    crossValidationFolders3{2}.data=trainingSet3([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2]);
    crossValidationFolders3{2}.labels=trainingLabels3([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2]);


    trainingSet3([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2])=[];
    trainingLabels3([ranT2;15+ranT2;30+ranT2;45+ranT2;60+ranT2])=[];
    
    crossValidationFolders3{3}.data=trainingSet3([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3]);
    crossValidationFolders3{3}.labels=trainingLabels3([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3]);

    trainingSet3([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3])=[];
    trainingLabels3([ranT3;10+ranT3;20+ranT3;30+ranT3;40+ranT3])=[];

    crossValidationFolders3{4}.data=trainingSet3;
    crossValidationFolders3{4}.labels=trainingLabels3;
    
    
  
    
    
    
    
end

if length(classesSet)==4
    
    trainingSet1=[dataFolder1{1}.data(1:10),dataFolder1{2}.data(1:10),dataFolder1{1}.data(11:20),dataFolder1{2}.data(11:20),dataFolder1{1}.data(21:30),dataFolder1{2}.data(21:30),dataFolder1{1}.data(31:40),dataFolder1{2}.data(31:40)];

    trainingLabels1=[dataFolder1{1}.labels(1:10),dataFolder1{2}.labels(1:10),dataFolder1{1}.labels(11:20),dataFolder1{2}.labels(11:20),dataFolder1{1}.labels(21:30),dataFolder1{2}.labels(21:30),dataFolder1{1}.labels(31:40),dataFolder1{2}.labels(31:40)];
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
    crossValidationFolders1{1}.data=trainingSet1([ranT1;20+ranT1;40+ranT1;60+ranT1]);
    crossValidationFolders1{1}.labels=trainingLabels1([ranT1;20+ranT1;40+ranT1;60+ranT1]);

    trainingSet1([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
    trainingLabels1([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
    
    crossValidationFolders1{2}.data=trainingSet1([ranT2;15+ranT2;30+ranT2;45+ranT2]);
    crossValidationFolders1{2}.labels=trainingLabels1([ranT2;15+ranT2;30+ranT2;45+ranT2]);


    trainingSet1([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
    trainingLabels1([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
    
    crossValidationFolders1{3}.data=trainingSet1([ranT3;10+ranT3;20+ranT3;30+ranT3]);
    crossValidationFolders1{3}.labels=trainingLabels1([ranT3;10+ranT3;20+ranT3;30+ranT3]);

    trainingSet1([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];
    trainingLabels1([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];

    crossValidationFolders1{4}.data=trainingSet1;
    crossValidationFolders1{4}.labels=trainingLabels1;

    
     %-------------------------------------%
      
     
    trainingSet2=[dataFolder2{1}.data(1:10),dataFolder2{2}.data(1:10),dataFolder2{1}.data(11:20),dataFolder2{2}.data(11:20),dataFolder2{1}.data(21:30),dataFolder2{2}.data(21:30),dataFolder2{1}.data(31:40),dataFolder2{2}.data(31:40)];

    trainingLabels2=[dataFolder2{1}.labels(1:10),dataFolder2{2}.labels(1:10),dataFolder2{1}.labels(11:20),dataFolder2{2}.labels(11:20),dataFolder2{1}.labels(21:30),dataFolder2{2}.labels(21:30),dataFolder2{1}.labels(31:40),dataFolder2{2}.labels(31:40)];
 
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
    crossValidationFolders2{1}.data=trainingSet2([ranT1;20+ranT1;40+ranT1;60+ranT1]);
    crossValidationFolders2{1}.labels=trainingLabels2([ranT1;20+ranT1;40+ranT1;60+ranT1]);

    trainingSet2([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
    trainingLabels2([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
    
    crossValidationFolders2{2}.data=trainingSet2([ranT2;15+ranT2;30+ranT2;45+ranT2]);
    crossValidationFolders2{2}.labels=trainingLabels2([ranT2;15+ranT2;30+ranT2;45+ranT2]);


    trainingSet2([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
    trainingLabels2([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
    
    crossValidationFolders2{3}.data=trainingSet2([ranT3;10+ranT3;20+ranT3;30+ranT3]);
    crossValidationFolders2{3}.labels=trainingLabels2([ranT3;10+ranT3;20+ranT3;30+ranT3]);

    trainingSet2([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];
    trainingLabels2([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];

    crossValidationFolders2{4}.data=trainingSet2;
    crossValidationFolders2{4}.labels=trainingLabels2;
     
    
    %-------------------------------------%
      
     
    trainingSet3=[dataFolder3{1}.data(1:10),dataFolder3{2}.data(1:10),dataFolder3{1}.data(11:20),dataFolder3{2}.data(11:20),dataFolder3{1}.data(21:30),dataFolder3{2}.data(21:30),dataFolder3{1}.data(31:40),dataFolder3{2}.data(31:40)];

    trainingLabels3=[dataFolder3{1}.labels(1:10),dataFolder3{2}.labels(1:10),dataFolder3{1}.labels(11:20),dataFolder3{2}.labels(11:20),dataFolder3{1}.labels(21:30),dataFolder3{2}.labels(21:30),dataFolder3{1}.labels(31:40),dataFolder3{2}.labels(31:40)];
 
     
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
    crossValidationFolders3{1}.data=trainingSet3([ranT1;20+ranT1;40+ranT1;60+ranT1]);
    crossValidationFolders3{1}.labels=trainingLabels3([ranT1;20+ranT1;40+ranT1;60+ranT1]);

    trainingSet3([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
    trainingLabels3([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
    
    crossValidationFolders3{2}.data=trainingSet3([ranT2;15+ranT2;30+ranT2;45+ranT2]);
    crossValidationFolders3{2}.labels=trainingLabels3([ranT2;15+ranT2;30+ranT2;45+ranT2]);


    trainingSet3([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
    trainingLabels3([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
    
    crossValidationFolders3{3}.data=trainingSet3([ranT3;10+ranT3;20+ranT3;30+ranT3]);
    crossValidationFolders3{3}.labels=trainingLabels3([ranT3;10+ranT3;20+ranT3;30+ranT3]);

    trainingSet3([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];
    trainingLabels3([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];

    crossValidationFolders3{4}.data=trainingSet3;
    crossValidationFolders3{4}.labels=trainingLabels3;
    
end
   
if length(classesSet)==3
    
    trainingSet1=[dataFolder1{1}.data(1:10),dataFolder1{2}.data(1:10),dataFolder1{1}.data(11:20),dataFolder1{2}.data(11:20),dataFolder1{1}.data(21:30),dataFolder1{2}.data(21:30)];

    trainingLabels1=[dataFolder1{1}.labels(1:10),dataFolder1{2}.labels(1:10),dataFolder1{1}.labels(11:20),dataFolder1{2}.labels(11:20),dataFolder1{1}.labels(21:30),dataFolder1{2}.labels(21:30)];
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
    crossValidationFolders1{1}.data=trainingSet1([ranT1;20+ranT1;40+ranT1]);
    crossValidationFolders1{1}.labels=trainingLabels1([ranT1;20+ranT1;40+ranT1]);

    trainingSet1([ranT1;20+ranT1;40+ranT1])=[];
    trainingLabels1([ranT1;20+ranT1;40+ranT1])=[];
    
    crossValidationFolders1{2}.data=trainingSet1([ranT2;15+ranT2;30+ranT2]);
    crossValidationFolders1{2}.labels=trainingLabels1([ranT2;15+ranT2;30+ranT2]);


    trainingSet1([ranT2;15+ranT2;30+ranT2])=[];
    trainingLabels1([ranT2;15+ranT2;30+ranT2])=[];
    
    crossValidationFolders1{3}.data=trainingSet1([ranT3;10+ranT3;20+ranT3]);
    crossValidationFolders1{3}.labels=trainingLabels1([ranT3;10+ranT3;20+ranT3]);

    trainingSet1([ranT3;10+ranT3;20+ranT3])=[];
    trainingLabels1([ranT3;10+ranT3;20+ranT3])=[];

    crossValidationFolders1{4}.data=trainingSet1;
    crossValidationFolders1{4}.labels=trainingLabels1;
    
    
    %-------------------------------------%
    
    trainingSet2=[dataFolder2{1}.data(1:10),dataFolder2{2}.data(1:10),dataFolder2{1}.data(11:20),dataFolder2{2}.data(11:20),dataFolder2{1}.data(21:30),dataFolder2{2}.data(21:30)];

    trainingLabels2=[dataFolder2{1}.labels(1:10),dataFolder2{2}.labels(1:10),dataFolder2{1}.labels(11:20),dataFolder2{2}.labels(11:20),dataFolder2{1}.labels(21:30),dataFolder2{2}.labels(21:30)];
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
    crossValidationFolders2{1}.data=trainingSet2([ranT1;20+ranT1;40+ranT1]);
    crossValidationFolders2{1}.labels=trainingLabels2([ranT1;20+ranT1;40+ranT1]);

    trainingSet2([ranT1;20+ranT1;40+ranT1])=[];
    trainingLabels2([ranT1;20+ranT1;40+ranT1])=[];
    
    crossValidationFolders2{2}.data=trainingSet2([ranT2;15+ranT2;30+ranT2]);
    crossValidationFolders2{2}.labels=trainingLabels2([ranT2;15+ranT2;30+ranT2]);


    trainingSet2([ranT2;15+ranT2;30+ranT2])=[];
    trainingLabels2([ranT2;15+ranT2;30+ranT2])=[];
    
    crossValidationFolders2{3}.data=trainingSet2([ranT3;10+ranT3;20+ranT3]);
    crossValidationFolders2{3}.labels=trainingLabels2([ranT3;10+ranT3;20+ranT3]);

    trainingSet2([ranT3;10+ranT3;20+ranT3])=[];
    trainingLabels2([ranT3;10+ranT3;20+ranT3])=[];

    crossValidationFolders2{4}.data=trainingSet2;
    crossValidationFolders2{4}.labels=trainingLabels2;
    
     %-------------------------------------%
    
    trainingSet3=[dataFolder3{1}.data(1:10),dataFolder3{2}.data(1:10),dataFolder3{1}.data(11:20),dataFolder3{2}.data(11:20),dataFolder3{1}.data(21:30),dataFolder3{2}.data(21:30)];

    trainingLabels3=[dataFolder3{1}.labels(1:10),dataFolder3{2}.labels(1:10),dataFolder3{1}.labels(11:20),dataFolder3{2}.labels(11:20),dataFolder3{1}.labels(21:30),dataFolder3{2}.labels(21:30)];
    
    ranT1=random_numbers(20,5,1);
    ranT2=random_numbers(15,5,1);
    ranT3=random_numbers(10,5,1);
    
    crossValidationFolders3{1}.data=trainingSet3([ranT1;20+ranT1;40+ranT1]);
    crossValidationFolders3{1}.labels=trainingLabels3([ranT1;20+ranT1;40+ranT1]);

    trainingSet3([ranT1;20+ranT1;40+ranT1])=[];
    trainingLabels3([ranT1;20+ranT1;40+ranT1])=[];
    
    crossValidationFolders3{2}.data=trainingSet3([ranT2;15+ranT2;30+ranT2]);
    crossValidationFolders3{2}.labels=trainingLabels3([ranT2;15+ranT2;30+ranT2]);


    trainingSet3([ranT2;15+ranT2;30+ranT2])=[];
    trainingLabels3([ranT2;15+ranT2;30+ranT2])=[];
    
    crossValidationFolders3{3}.data=trainingSet3([ranT3;10+ranT3;20+ranT3]);
    crossValidationFolders3{3}.labels=trainingLabels3([ranT3;10+ranT3;20+ranT3]);

    trainingSet3([ranT3;10+ranT3;20+ranT3])=[];
    trainingLabels3([ranT3;10+ranT3;20+ranT3])=[];

    crossValidationFolders3{4}.data=trainingSet3;
    crossValidationFolders3{4}.labels=trainingLabels3;
    
    
end




SVMs=struct([]);




repCounter=1;

SVM1_performances=[];
SVM2_performances=[];
SVM3_performances=[];

SVM1_performances_std=[];
SVM2_performances_std=[];
SVM3_performances_std=[];

SVM1_performances_train=[];
SVM2_performances_train=[];
SVM3_performances_train=[];

SVM1_performances_std_train=[];
SVM2_performances_std_train=[];
SVM3_performances_std_train=[];

scores1=struct([]);
rPG1=struct([]);
        %esn1=struct([]);
        
        
scores2=struct([]);
rPG2=struct([]);
        %esn2=struct([]);

scores3=struct([]);
rPG3=struct([]);
        %esn3=struct([]);

        



Alldata1=[crossValidationFolders1{1}.data(:);crossValidationFolders1{2}.data(:);crossValidationFolders1{3}.data(:);crossValidationFolders1{4}.data(:)];
Alldata1_Labels=[crossValidationFolders1{1}.labels(:);crossValidationFolders1{2}.labels(:);crossValidationFolders1{3}.labels(:);crossValidationFolders1{4}.labels(:)];
[Alldata1,Alldata1_Labels]=SVMorganiseData(Alldata1,Alldata1_Labels);

maxAllData1=max(Alldata1);

for i=1:size(Alldata1,2)
    Alldata1(:,i)=Alldata1(:,i)/maxAllData1(i);
end



Alldata2=[crossValidationFolders2{1}.data(:);crossValidationFolders2{2}.data(:);crossValidationFolders2{3}.data(:);crossValidationFolders2{4}.data(:)];
Alldata2_Labels=[crossValidationFolders2{1}.labels(:);crossValidationFolders2{2}.labels(:);crossValidationFolders2{3}.labels(:);crossValidationFolders2{4}.labels(:)];
[Alldata2,Alldata2_Labels]=SVMorganiseData(Alldata2,Alldata2_Labels);

maxAllData2=max(Alldata2);

for i=1:size(Alldata2,2)
    Alldata2(:,i)=Alldata2(:,i)/maxAllData2(i);
end



Alldata3=[crossValidationFolders3{1}.data(:);crossValidationFolders3{2}.data(:);crossValidationFolders3{3}.data(:);crossValidationFolders3{4}.data(:)];
Alldata3_Labels=[crossValidationFolders3{1}.labels(:);crossValidationFolders3{2}.labels(:);crossValidationFolders3{3}.labels(:);crossValidationFolders3{4}.labels(:)];
[Alldata3,Alldata3_Labels]=SVMorganiseData(Alldata3,Alldata3_Labels);

maxAllData3=max(Alldata3);

for i=1:size(Alldata3,2)
    Alldata3(:,i)=Alldata3(:,i)/maxAllData3(i);
end


maxValues=struct([]);

maxValues{1}=maxAllData1;
maxValues{2}=maxAllData2;
maxValues{3}=maxAllData3;


bestModels=struct([]);


disp('Training dynamice LDA model ....')

bestModels{1}=fitcdiscr(Alldata1,Alldata1_Labels,'DiscrimType','pseudoquadratic');
bestModels{2}=fitcdiscr(Alldata2,Alldata2_Labels,'DiscrimType','pseudoquadratic');
bestModels{3}=fitcdiscr(Alldata3,Alldata3_Labels,'DiscrimType','pseudoquadratic');
      
disp('validation with the testing set ....')

velThreshold=0.1;

% if sbjID==2
%     velThreshold=0.05;
% end
% if sbjID==3
%     velThreshold=0.02;
% end
% 
% if sbjID==4
%     velThreshold=0.05;
% end

[oneESNSs,oneESNRpG]=LDATest3(bestModels,testingSet,'8',1000,velThreshold,maxValues,length(unique(Alldata1_Labels)));

clrs={'b','r','m','g','y'};


if nbmuscles>6
    
    figure(nbClasses)
    hold on
    plot(0:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.05,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3,'LineStyle','--')
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['all muscleset- ' num2str(nbClasses) ' clasees - one and dynamic classifier LDA'])
    grid on
    
else
    figure(10+nbClasses)
    hold on
    plot(0:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.05,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3,'LineStyle','--')
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['forearm muscles- ' num2str(nbClasses) ' clasees - one and dynamic classifier LDA'])
    grid on
end


% for amputees

% save(['data/amputee' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classes_LDA_dynamicClassifier_01042017.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders2',...
%     'bestModels')

% for able-bodied

save(['data/ableBodied' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classes_LDA_dynamicClassifier_02042017.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders2',...
    'bestModels')



bestModels=struct([]);
disp('Training one LDA model ....')

bestModels{1}=fitcdiscr([Alldata1;Alldata2;Alldata3],[Alldata1_Labels;Alldata2_Labels;Alldata3_Labels],'DiscrimType','pseudoquadratic');
bestModels{2}=bestModels{1};
bestModels{3}=bestModels{1};
disp('validation with the testing set ....')
[oneESNSs,oneESNRpG]=LDATest3(bestModels,testingSet,'8',1000,velThreshold,maxValues,length(unique(Alldata1_Labels)));


if nbmuscles>6
    
    figure(nbClasses)
    hold on
    plot(0:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.05,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3)
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['all muscleset- ' num2str(nbClasses) ' clasees - one and dynamic classifier LDA'])
    grid on
    
else
    figure(10+nbClasses)
    hold on
    plot(0:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.05,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3)
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['forearm muscles- ' num2str(nbClasses) ' clasees - one and dynamic classifier LDA'])
    grid on
end


% for amputees
% 
% save(['data/amputee' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classes_LDA_oneClassifier_01042017.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders2',...
%     'bestModels')


% for able-bodied

save(['data/ableBodied' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classes_LDA_oneClassifier_02042017.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders2',...
    'bestModels')


end