function [ESNmodelallmotion,ESNmodelonlylast]=trainESNClassifierOn(dataFolder1,dataFolder2,dataFolder3,historyTW,classesSet,nInternalUnits,alpha,sbjID,nbmuscles)


disp('-----------------------------------------------------------')
disp('                Classification with ESN- one ESN')
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
    
    trialsPerFolder=length(dataFolder1{1}.data)/length(classesSet);
    
    trainingSet1=[];
    trainingLabels1=[];
    
    for i=1:length(classesSet)
        for j=1:length(dataFolder1)
            trainingSet1=[trainingSet1,dataFolder1{j}.data((i-1)*trialsPerFolder+1:i*trialsPerFolder)];
            trainingLabels1=[trainingLabels1,dataFolder1{j}.labels((i-1)*trialsPerFolder+1:i*trialsPerFolder)];
        end
    end
        
    
    
    
    
    %trainingSet1=[dataFolder1{1}.data(1:10),dataFolder1{2}.data(1:10),dataFolder1{1}.data(11:20),dataFolder1{2}.data(11:20),dataFolder1{1}.data(21:30),dataFolder1{2}.data(21:30),dataFolder1{1}.data(31:40),dataFolder1{2}.data(31:40)];

    %trainingLabels1=[dataFolder1{1}.labels(1:10),dataFolder1{2}.labels(1:10),dataFolder1{1}.labels(11:20),dataFolder1{2}.labels(11:20),dataFolder1{1}.labels(21:30),dataFolder1{2}.labels(21:30),dataFolder1{1}.labels(31:40),dataFolder1{2}.labels(31:40)];
    
    
%     ranT1=random_numbers(length(trainingSet1)/length(classesSet),round(length(trainingSet1)/(4*length(classesSet))),1);
%     ranT2=random_numbers(length(trainingSet1)/length(classesSet)-round(length(trainingSet1)/(4*length(classesSet))),round(length(trainingSet1)/(4*length(classesSet))),1);
%     ranT3=random_numbers(length(trainingSet1)/length(classesSet)-2*round(length(trainingSet1)/(4*length(classesSet))),round(length(trainingSet1)/(4*length(classesSet))),1);
    
    ranNum=struct([]);
    ranNum{1}=random_numbers(length(trainingSet1)/length(classesSet),round(length(trainingSet1)/(4*length(classesSet))),1);
    ranNum{2}=random_numbers(length(trainingSet1)/length(classesSet)-round(length(trainingSet1)/(4*length(classesSet))),round(length(trainingSet1)/(4*length(classesSet))),1);
    ranNum{3}=random_numbers(length(trainingSet1)/length(classesSet)-2*round(length(trainingSet1)/(4*length(classesSet))),round(length(trainingSet1)/(4*length(classesSet))),1);
    
%     ranT1=random_numbers(20,5,1);
%     ranT2=random_numbers(15,5,1);
%     ranT3=random_numbers(10,5,1);
    

    for k=1:3
        crossValidationFolders1{k}.data=[];
        crossValidationFolders1{k}.labels=[];
        toExclude=[];
    
        for i=1:length(classesSet)
            crossValidationFolders1{k}.data=[crossValidationFolders1{k}.data,trainingSet1(ranNum{k}+(i-1)*(length(trainingSet1)/length(classesSet)))];
            crossValidationFolders1{k}.labels=[crossValidationFolders1{k}.labels,trainingLabels1(ranNum{k}+(i-1)*(length(trainingSet1)/length(classesSet)))];
            toExclude=[toExclude;ranNum{k}+(i-1)*(length(trainingSet1)/length(classesSet))];
        end
    
%     crossValidationFolders1{1}.data=trainingSet1([ranT1;20+ranT1;40+ranT1;60+ranT1]);
%     crossValidationFolders1{1}.labels=trainingLabels1([ranT1;20+ranT1;40+ranT1;60+ranT1]);
        
       
        trainingSet1(toExclude)=[];
        trainingLabels1(toExclude)=[];
        
%         trainingSet1([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
%         trainingLabels1([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];

    end

%     trainingSet1([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
%     trainingLabels1([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
%     
%     crossValidationFolders1{2}.data=trainingSet1([ranT2;15+ranT2;30+ranT2;45+ranT2]);
%     crossValidationFolders1{2}.labels=trainingLabels1([ranT2;15+ranT2;30+ranT2;45+ranT2]);
% 
% 
%     trainingSet1([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
%     trainingLabels1([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
%     
%     crossValidationFolders1{3}.data=trainingSet1([ranT3;10+ranT3;20+ranT3;30+ranT3]);
%     crossValidationFolders1{3}.labels=trainingLabels1([ranT3;10+ranT3;20+ranT3;30+ranT3]);
% 
%     trainingSet1([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];
%     trainingLabels1([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];

    crossValidationFolders1{4}.data=trainingSet1;
    crossValidationFolders1{4}.labels=trainingLabels1;

    
     %-------------------------------------%
      
     
     
    trainingSet2=[];
    trainingLabels2=[];
    
    for i=1:length(classesSet)
        for j=1:length(dataFolder2)
            trainingSet2=[trainingSet2,dataFolder2{j}.data((i-1)*trialsPerFolder+1:i*trialsPerFolder)];
            trainingLabels2=[trainingLabels2,dataFolder2{j}.labels((i-1)*trialsPerFolder+1:i*trialsPerFolder)];
        end
    end
     
     
    ranNum=struct([]);
    ranNum{1}=random_numbers(length(trainingSet2)/length(classesSet),round(length(trainingSet2)/(4*length(classesSet))),1);
    ranNum{2}=random_numbers(length(trainingSet2)/length(classesSet)-round(length(trainingSet2)/(4*length(classesSet))),round(length(trainingSet2)/(4*length(classesSet))),1);
    ranNum{3}=random_numbers(length(trainingSet2)/length(classesSet)-2*round(length(trainingSet2)/(4*length(classesSet))),round(length(trainingSet2)/(4*length(classesSet))),1);
    
    
    for k=1:3
        crossValidationFolders2{k}.data=[];
        crossValidationFolders2{k}.labels=[];
        toExclude=[];
    
        for i=1:length(classesSet)
            crossValidationFolders2{k}.data=[crossValidationFolders2{k}.data,trainingSet2(ranNum{k}+(i-1)*(length(trainingSet2)/length(classesSet)))];
            crossValidationFolders2{k}.labels=[crossValidationFolders2{k}.labels,trainingLabels2(ranNum{k}+(i-1)*(length(trainingSet2)/length(classesSet)))];
            toExclude=[toExclude;ranNum{k}+(i-1)*(length(trainingSet2)/length(classesSet))];
        end
    
        
       
        trainingSet2(toExclude)=[];
        trainingLabels2(toExclude)=[];

    end
     
    crossValidationFolders2{4}.data=trainingSet2;
    crossValidationFolders2{4}.labels=trainingLabels2;
    
     
%     trainingSet2=[dataFolder2{1}.data(1:10),dataFolder2{2}.data(1:10),dataFolder2{1}.data(11:20),dataFolder2{2}.data(11:20),dataFolder2{1}.data(21:30),dataFolder2{2}.data(21:30),dataFolder2{1}.data(31:40),dataFolder2{2}.data(31:40)];
% 
%     trainingLabels2=[dataFolder2{1}.labels(1:10),dataFolder2{2}.labels(1:10),dataFolder2{1}.labels(11:20),dataFolder2{2}.labels(11:20),dataFolder2{1}.labels(21:30),dataFolder2{2}.labels(21:30),dataFolder2{1}.labels(31:40),dataFolder2{2}.labels(31:40)];
%  
%     
%     ranT1=random_numbers(20,5,1);
%     ranT2=random_numbers(15,5,1);
%     ranT3=random_numbers(10,5,1);
%     
%     crossValidationFolders2{1}.data=trainingSet2([ranT1;20+ranT1;40+ranT1;60+ranT1]);
%     crossValidationFolders2{1}.labels=trainingLabels2([ranT1;20+ranT1;40+ranT1;60+ranT1]);
% 
%     trainingSet2([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
%     trainingLabels2([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
%     
%     crossValidationFolders2{2}.data=trainingSet2([ranT2;15+ranT2;30+ranT2;45+ranT2]);
%     crossValidationFolders2{2}.labels=trainingLabels2([ranT2;15+ranT2;30+ranT2;45+ranT2]);
% 
% 
%     trainingSet2([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
%     trainingLabels2([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
%     
%     crossValidationFolders2{3}.data=trainingSet2([ranT3;10+ranT3;20+ranT3;30+ranT3]);
%     crossValidationFolders2{3}.labels=trainingLabels2([ranT3;10+ranT3;20+ranT3;30+ranT3]);
% 
%     trainingSet2([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];
%     trainingLabels2([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];
% 
%     crossValidationFolders2{4}.data=trainingSet2;
%     crossValidationFolders2{4}.labels=trainingLabels2;
     
    
    %-------------------------------------%
      
    
    
    
    trainingSet3=[];
    trainingLabels3=[];
    
    for i=1:length(classesSet)
        for j=1:length(dataFolder2)
            trainingSet3=[trainingSet3,dataFolder2{j}.data((i-1)*trialsPerFolder+1:i*trialsPerFolder)];
            trainingLabels3=[trainingLabels3,dataFolder2{j}.labels((i-1)*trialsPerFolder+1:i*trialsPerFolder)];
        end
    end
     
     
    ranNum=struct([]);
    ranNum{1}=random_numbers(length(trainingSet3)/length(classesSet),round(length(trainingSet3)/(4*length(classesSet))),1);
    ranNum{2}=random_numbers(length(trainingSet3)/length(classesSet)-round(length(trainingSet3)/(4*length(classesSet))),round(length(trainingSet3)/(4*length(classesSet))),1);
    ranNum{3}=random_numbers(length(trainingSet3)/length(classesSet)-2*round(length(trainingSet3)/(4*length(classesSet))),round(length(trainingSet3)/(4*length(classesSet))),1);
    
    
    for k=1:3
        crossValidationFolders3{k}.data=[];
        crossValidationFolders3{k}.labels=[];
        toExclude=[];
    
        for i=1:length(classesSet)
            crossValidationFolders3{k}.data=[crossValidationFolders3{k}.data,trainingSet3(ranNum{k}+(i-1)*(length(trainingSet3)/length(classesSet)))];
            crossValidationFolders3{k}.labels=[crossValidationFolders3{k}.labels,trainingLabels3(ranNum{k}+(i-1)*(length(trainingSet3)/length(classesSet)))];
            toExclude=[toExclude;ranNum{k}+(i-1)*(length(trainingSet3)/length(classesSet))];
        end
    
        
       
        trainingSet3(toExclude)=[];
        trainingLabels3(toExclude)=[];

    end
     
    crossValidationFolders3{4}.data=trainingSet3;
    crossValidationFolders3{4}.labels=trainingLabels3;
    
    
%     
%      
%     trainingSet3=[dataFolder3{1}.data(1:10),dataFolder3{2}.data(1:10),dataFolder3{1}.data(11:20),dataFolder3{2}.data(11:20),dataFolder3{1}.data(21:30),dataFolder3{2}.data(21:30),dataFolder3{1}.data(31:40),dataFolder3{2}.data(31:40)];
% 
%     trainingLabels3=[dataFolder3{1}.labels(1:10),dataFolder3{2}.labels(1:10),dataFolder3{1}.labels(11:20),dataFolder3{2}.labels(11:20),dataFolder3{1}.labels(21:30),dataFolder3{2}.labels(21:30),dataFolder3{1}.labels(31:40),dataFolder3{2}.labels(31:40)];
%  
%      
%     ranT1=random_numbers(20,5,1);
%     ranT2=random_numbers(15,5,1);
%     ranT3=random_numbers(10,5,1);
%     
%     crossValidationFolders3{1}.data=trainingSet3([ranT1;20+ranT1;40+ranT1;60+ranT1]);
%     crossValidationFolders3{1}.labels=trainingLabels3([ranT1;20+ranT1;40+ranT1;60+ranT1]);
% 
%     trainingSet3([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
%     trainingLabels3([ranT1;20+ranT1;40+ranT1;60+ranT1])=[];
%     
%     crossValidationFolders3{2}.data=trainingSet3([ranT2;15+ranT2;30+ranT2;45+ranT2]);
%     crossValidationFolders3{2}.labels=trainingLabels3([ranT2;15+ranT2;30+ranT2;45+ranT2]);
% 
% 
%     trainingSet3([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
%     trainingLabels3([ranT2;15+ranT2;30+ranT2;45+ranT2])=[];
%     
%     crossValidationFolders3{3}.data=trainingSet3([ranT3;10+ranT3;20+ranT3;30+ranT3]);
%     crossValidationFolders3{3}.labels=trainingLabels3([ranT3;10+ranT3;20+ranT3;30+ranT3]);
% 
%     trainingSet3([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];
%     trainingLabels3([ranT3;10+ranT3;20+ranT3;30+ranT3])=[];
% 
%     crossValidationFolders3{4}.data=trainingSet3;
%     crossValidationFolders3{4}.labels=trainingLabels3;
    
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




%%




echoNetworks=struct([]);


performances=zeros(4,3);

OverallPerformances=zeros(4,1);

ClassesPerformances=struct([]);

for i=1:length(classesSet)
    
    ClassesPerformances{i}=[];
    
end


for i=1:4
    
    

    disp(['repetition: ' num2str(i)])

    validSet1=crossValidationFolders1{i}.data;
    validSetLabels1=crossValidationFolders1{i}.labels;

    validSet2=crossValidationFolders2{i}.data;
    validSetLabels2=crossValidationFolders2{i}.labels;

    validSet3=crossValidationFolders3{i}.data;
    validSetLabels3=crossValidationFolders3{i}.labels;
    
    validSet=[validSet1;validSet2;validSet3];
    validSetLabels=[validSetLabels1;validSetLabels2;validSetLabels3];

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
    
    trSet=[trSet1;trSet2;trSet3];
    trSetLabels=[trSetLabels1;trSetLabels2;trSetLabels3];

    [ESNmodel,ValidRateOverall,ValidRates,results_per_grasp]=train_ESN2(trSet,trSetLabels,validSet,validSetLabels,nInternalUnits,alpha);

    
    echoNetworks{i}=ESNmodel;
    
    performances(i,:)=ValidRates;

    OverallPerformances(i)=ValidRateOverall;
    
    for cc=1:length(classesSet)
    
        ClassesPerformances{cc}=[ClassesPerformances{cc};results_per_grasp(:,cc)'];
    
    end
    

end

colorMap=winter(length(classesSet));

figure()
hold on
for c=1:length(classesSet)
    bar(0.7+(c-1)*1:6:17.7+(c-1)*1,mean(ClassesPerformances{c}),'FaceColor',colorMap(c,:),'LineWidth',1,'BarWidth',0.2)
end
for c=1:length(classesSet)
    errorbar(0.7+(c-1)*1:6:17.7+(c-1)*1,mean(ClassesPerformances{c}),std(ClassesPerformances{c}),'.')
end
lgd={};

for c=1:length(classesSet)
    lgd{c}=['class ' num2str(c)];
end
set(gca,'xtick',[2:6:20])
set(gca,'xticklabels',{'A','B','C'})
legend(lgd)
ylabel('classification accuracy [%]')
xlabel('reaching motion phases')
title('Classification performance for each class in each section')
grid on
saveas(gcf,'classifPerf.fig')

%%


for j=1:4
    
    trSet1=[trSet1;crossValidationFolders1{j}.data(:)];
    trSetLabels1=[trSetLabels1;crossValidationFolders1{j}.labels(:)];

    trSet2=[trSet2;crossValidationFolders2{j}.data(:)];
    trSetLabels2=[trSetLabels2;crossValidationFolders2{j}.labels(:)];

    trSet3=[trSet3;crossValidationFolders3{j}.data(:)];
    trSetLabels3=[trSetLabels3;crossValidationFolders3{j}.labels(:)];

    
end

trSet=[trSet1;trSet2;trSet3];
trSetLabels=[trSetLabels1;trSetLabels2;trSetLabels3];

trSetnew=[trSet1,trSet2,trSet3]';
trSetLabelsnew=[trSetLabels1,trSetLabels2,trSetLabels3]';


[ESNmodelallmotion,~,~,~]=train_ESN2(trSet,trSetLabels,trSetnew,trSetLabelsnew,nInternalUnits,alpha);

[ESNmodelonlylast,ValidRateOverall,ValidRates,results_per_grasp]=train_ESN2(trSet3,trSetLabels3,trSetnew,trSetLabelsnew,nInternalUnits,alpha);






end