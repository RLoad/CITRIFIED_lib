function [oneESNSs,oneESNRpG]=rbf_SVMClassification_byAngle(dataFolder1,dataFolder2,dataFolder3,testingSet,div,historyTW,classesSet,LabelSet,sbjID,clr,tLast,nbmuscles,nbClasses)


disp('-----------------------------------------------------------')
disp('       Classification with RBF SVM - dynamic model')
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


gama=[0.05,0.1:0.1:0.8];
C_param=[0.1,1:5:100];

% gama=0.1:0.1:1;
% C_param=0.1:2:10.2;


SVM1_performances=zeros(length(C_param),length(gama));
SVM2_performances=zeros(length(C_param),length(gama));
SVM3_performances=zeros(length(C_param),length(gama));

SVM1_performances_std=zeros(length(C_param),length(gama));
SVM2_performances_std=zeros(length(C_param),length(gama));
SVM3_performances_std=zeros(length(C_param),length(gama));

SVM1_performances_train=zeros(length(C_param),length(gama));
SVM2_performances_train=zeros(length(C_param),length(gama));
SVM3_performances_train=zeros(length(C_param),length(gama));

SVM1_performances_std_train=zeros(length(C_param),length(gama));
SVM2_performances_std_train=zeros(length(C_param),length(gama));
SVM3_performances_std_train=zeros(length(C_param),length(gama));

param_performances1=[];
param_performances2=[];
param_performances3=[];

repCounter=1;

 for C=1:length(C_param)
    for g=1:length(gama)

        performances=zeros(4,3);
        performances_train=zeros(4,3);
        
        
        for i=1:4

%             disp(['repetition: ' num2str(i)])

            validSet1=crossValidationFolders1{i}.data;
            validSetLabels1=crossValidationFolders1{i}.labels;
            
            validSet2=crossValidationFolders2{i}.data;
            validSetLabels2=crossValidationFolders2{i}.labels;
            
            validSet3=crossValidationFolders3{i}.data;
            validSetLabels3=crossValidationFolders3{i}.labels;

            trSet1=[];
            trSetLabels1=[];
            
            trSet2=[];
            trSetLabels2=[];
            
            trSet3=[];
            trSetLabels3=[];

            for j=1:4
                if j~=i
                    trSet1=[trSet1;crossValidationFolders1{j}.data(:)];
                    trSetLabels1=[trSetLabels1;crossValidationFolders1{j}.labels(:)];
                    
                    trSet2=[trSet2;crossValidationFolders2{j}.data(:)];
                    trSetLabels2=[trSetLabels2;crossValidationFolders2{j}.labels(:)];
                    
                    trSet3=[trSet3;crossValidationFolders3{j}.data(:)];
                    trSetLabels3=[trSetLabels3;crossValidationFolders3{j}.labels(:)];
                    
                    
                end
            end
            
            
            % first SVM
            
            [SVMtrSet1,SVMtrSetLabels1]=SVMorganiseData(trSet1,trSetLabels1);
            [SVMvalidSet1,SVMvalidSetLabels1]=SVMorganiseData(validSet1,validSetLabels1);
            
            for kk=1:size(SVMtrSet1,2)
                SVMtrSet1(:,kk)=SVMtrSet1(:,kk)/maxAllData1(kk);
                SVMvalidSet1(:,kk)=SVMvalidSet1(:,kk)/maxAllData1(kk);
            end
            
            SVMmodel1=svmtrain(SVMtrSetLabels1,SVMtrSet1, ['-q -s 0 -t ' num2str(2) ' -g ' num2str(gama(g)) ' -c '  num2str(C_param(C))]);
            
%             SVMmodel1=svmtrain(SVMtrSetLabels1,SVMtrSet1, [' -s 0 -t ' num2str(0) ' -g ' num2str(gama(C)) ' -c '  num2str(11)]);
            
            [resultsTrain, TrainAccuracy, TrianDecision] = svmpredict(SVMtrSetLabels1, SVMtrSet1, SVMmodel1, ' -q');
            
            performances_train(i,1)=TrainAccuracy(1);
            
            
            [ValidationResults, ValidationAccuracy, ValidationDecision] = svmpredict(SVMvalidSetLabels1, SVMvalidSet1, SVMmodel1, ' -q');
            
            scores1{repCounter}{i}=ValidationAccuracy(1);   
%             rPG1{repCounter}{i}=predictionPerGrasp(ValidationResults,SVMvalidSet1);
            
            performances(i,1)=ValidationAccuracy(1);
            
            % second SVM
            
            [SVMtrSet2,SVMtrSetLabels2]=SVMorganiseData(trSet2,trSetLabels2);
            [SVMvalidSet2,SVMvalidSetLabels2]=SVMorganiseData(validSet2,validSetLabels2);
            
            for kk=1:size(SVMtrSet2,2)
                SVMtrSet2(:,kk)=SVMtrSet2(:,kk)/maxAllData2(kk);
                SVMvalidSet2(:,kk)=SVMvalidSet2(:,kk)/maxAllData2(kk);
            end
            
            SVMmodel2=svmtrain(SVMtrSetLabels2,SVMtrSet2, ['-q -s 0 -t ' num2str(2) ' -g ' num2str(gama(g)) ' -c '  num2str(C_param(C))]);
            
            [resultsTrain, TrainAccuracy, TrianDecision] = svmpredict(SVMtrSetLabels2, SVMtrSet2, SVMmodel2, ' -q');
            
             performances_train(i,2)=TrainAccuracy(1);
            
            [ValidationResults, ValidationAccuracy, ValidationDecision] = svmpredict(SVMvalidSetLabels2, SVMvalidSet2, SVMmodel2, ' -q');
            
            scores2{repCounter}{i}=ValidationAccuracy(1);   
%             rPG2{repCounter}{i}=predictionPerGrasp(ValidationResults,SVMvalidSet2);
            
            performances(i,2)=ValidationAccuracy(1);
            
            % third SVM
                    
            
            
            [SVMtrSet3,SVMtrSetLabels3]=SVMorganiseData(trSet3,trSetLabels3);
            [SVMvalidSet3,SVMvalidSetLabels3]=SVMorganiseData(validSet3,validSetLabels3);
            
            for kk=1:size(SVMtrSet3,2)
                SVMtrSet3(:,kk)=SVMtrSet3(:,kk)/maxAllData3(kk);
                SVMvalidSet3(:,kk)=SVMvalidSet3(:,kk)/maxAllData3(kk);
            end
            
            
            SVMmodel3=svmtrain(SVMtrSetLabels3,SVMtrSet3, ['-q -s 0 -t ' num2str(2) ' -g ' num2str(gama(g)) ' -c '  num2str(C_param(C))]);
            
            [resultsTrain, TrainAccuracy, TrianDecision] = svmpredict(SVMtrSetLabels3, SVMtrSet3, SVMmodel3, ' -q');
            
             performances_train(i,3)=TrainAccuracy(1);
            
            [ValidationResults, ValidationAccuracy, ValidationDecision] = svmpredict(SVMvalidSetLabels3, SVMvalidSet3, SVMmodel3, ' -q');
            
            scores3{repCounter}{i}=ValidationAccuracy(1);   
%             rPG3{repCounter}{i}=predictionPerGrasp(ValidationResults,SVMvalidSet2);
            
            performances(i,3)=ValidationAccuracy(1);          
            
            
        end

        
        param_performances1=[param_performances1;[C_param(C),gama(g),mean(performances(:,1))]];
        param_performances2=[param_performances2;[C_param(C),gama(g),mean(performances(:,2))]];
        param_performances3=[param_performances3;[C_param(C),gama(g),mean(performances(:,3))]];


        SVM1_performances(C,g)=mean(performances(:,1));
        SVM1_performances_std(C,g)=std(performances(:,1));
        SVM2_performances(C,g)=mean(performances(:,2));
        SVM2_performances_std(C,g)=std(performances(:,2));
        SVM3_performances(C,g)=mean(performances(:,3));
        SVM3_performances_std(C,g)=std(performances(:,3));
        
        
        SVM1_performances_train(C,g)=mean(performances_train(:,1));
        SVM1_performances_std_train(C,g)=std(performances_train(:,1));
        SVM2_performances_train(C,g)=mean(performances_train(:,2));
        SVM2_performances_std_train(C,g)=std(performances_train(:,2));
        SVM3_performances_train(C,g)=mean(performances_train(:,3));
        SVM3_performances_std_train(C,g)=std(performances_train(:,3));
        
        repCounter=repCounter+1;
        
%         
    end
 end

% 
%  figure(1)
%  surf(C_param,gama,SVM1_performances')
%  title('1st classifier')
%  xlabel('C')
%  ylabel('gama')
%  zlabel('performance')
%  
%  figure(2)
%  surf(C_param,gama,SVM2_performances')
%  title('2nd classifier')
%  xlabel('C')
%  ylabel('gama')
%  zlabel('performance')
%  
%  figure(3)
%  surf(C_param,gama,SVM3_performances')
%  title('3rd classifier')
%  xlabel('C')
%  ylabel('gama')
%  zlabel('performance')
 


 
 
 % find best parameters
 
 % for the 1st classifier
 
[a,b]=max(SVM1_performances);
 
[bestPerf1,best_gama1]=max(a);
 
best_C1=b(best_gama1);
 
% for the 2nd classifier
 
[a,b]=max(SVM2_performances);
 
[bestPerf2,best_gama2]=max(a);

best_C2=b(best_gama2);

% for the 3rd classifier
 
[a,b]=max(SVM3_performances);
 
[bestPerf3,best_gama3]=max(a);

best_C3=b(best_gama3);
 
% train the dynamic classifier with the optimal parameters
bestModels=struct([]);

bestModels{1}=svmtrain(Alldata1_Labels,Alldata1, [' -q -s 0 -t ' num2str(2) ' -g ' num2str(gama(best_gama1)) ' -c ' num2str(C_param(best_C1))]);
bestModels{2}=svmtrain(Alldata2_Labels,Alldata2, [' -q -s 0 -t ' num2str(2) ' -g ' num2str(gama(best_gama2)) ' -c ' num2str(C_param(best_C2))]);
bestModels{3}=svmtrain(Alldata3_Labels,Alldata3, [' -q -s 0 -t ' num2str(2) ' -g ' num2str(gama(best_gama3)) ' -c ' num2str(C_param(best_C3))]);
disp('best performances:') 
disp(['model 1: ' num2str(bestPerf1)])
disp(['model 2: ' num2str(bestPerf2)])
disp(['model 3: ' num2str(bestPerf3)])

disp('validation with the testing set ....')

velThreshold=0.1;
% 
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

[oneESNSs,oneESNRpG]=SVMTest3(bestModels,testingSet,'8',1000,velThreshold,maxValues,length(unique(Alldata1_Labels)));

clrs={'b','r','m','g','y'};


if nbmuscles>6
    
    figure(nbClasses)
    hold on
    plot(0:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.05,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3,'LineStyle','--')
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['all muscleset- ' num2str(nbClasses) ' clasees - dynamic classifier RBF SVM'])
    grid on
    
else
    figure(10+nbClasses)
    hold on
    plot(0:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.05,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3,'LineStyle','--')
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['forearm muscles- ' num2str(nbClasses) ' clasees - dynamic classifier RBF SVM'])
    grid on
end


% for amputees

% save(['data/amputee' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classes_RBF_SVM_dynamicClassifier_01042017.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders2',...
%     'bestModels','SVM1_performances','SVM2_performances','SVM3_performances',...
%     'SVM1_performances_std','SVM2_performances_std','SVM3_performances_std',...
%     'bestPerf1','param_performances1','bestPerf2','param_performances2','bestPerf3','param_performances3','C_param','gama')




% for able-bodied

save(['data/ableBodied' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classes_RBF_SVM_dynamicClassifier_02042017.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders2',...
    'bestModels','SVM1_performances','SVM2_performances','SVM3_performances',...
    'SVM1_performances_std','SVM2_performances_std','SVM3_performances_std',...
    'bestPerf1','param_performances1','bestPerf2','param_performances2','bestPerf3','param_performances3','C_param','gama')




end