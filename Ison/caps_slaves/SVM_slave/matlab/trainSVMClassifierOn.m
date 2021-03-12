function [SVMmodelalldata,SVMmodelonlylast,maxVal]=trainSVMClassifierOn(dataFolder1,dataFolder2,dataFolder3,historyTW,classesSet,gama,C_param,sbjID,nbmuscles)


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








scores1=struct([]);




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


maxVal=max([maxAllData1;maxAllData2;maxAllData3]);


SVM_performances=zeros(length(C_param),length(gama));

SVM_performances_std=zeros(length(C_param),length(gama));

SVM_performances_train=zeros(length(C_param),length(gama));

SVM_performances_std_train=zeros(length(C_param),length(gama));

repCounter=1;

 for C=1:length(C_param)
    for g=1:length(gama)

        performances=zeros(4,1);
        performances_train=zeros(4,1);
        
        
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
            
            
            [SVMtrSet2,SVMtrSetLabels2]=SVMorganiseData(trSet2,trSetLabels2);
            [SVMvalidSet2,SVMvalidSetLabels2]=SVMorganiseData(validSet2,validSetLabels2);
            
            
            for kk=1:size(SVMtrSet2,2)
                SVMtrSet2(:,kk)=SVMtrSet2(:,kk)/maxAllData2(kk);
                SVMvalidSet2(:,kk)=SVMvalidSet2(:,kk)/maxAllData2(kk);
            end
            
            [SVMtrSet3,SVMtrSetLabels3]=SVMorganiseData(trSet3,trSetLabels3);
            [SVMvalidSet3,SVMvalidSetLabels3]=SVMorganiseData(validSet3,validSetLabels3);
            
            for kk=1:size(SVMtrSet3,2)
                SVMtrSet3(:,kk)=SVMtrSet3(:,kk)/maxAllData3(kk);
                SVMvalidSet3(:,kk)=SVMvalidSet3(:,kk)/maxAllData3(kk);
            end
            
            
            TrainingSet=[SVMtrSet1;SVMtrSet2;SVMtrSet3];
            TrainingSet_Labels=[SVMtrSetLabels1;SVMtrSetLabels2;SVMtrSetLabels3];
            
            ValidationSet=[SVMvalidSet1;SVMvalidSet2;SVMvalidSet3];
            ValidationSet_Labels=[SVMvalidSetLabels1;SVMvalidSetLabels2;SVMvalidSetLabels3];
            
            
            SVMmodel=svmtrain(TrainingSet_Labels,TrainingSet, ['-q -s 0 -t ' num2str(2) ' -g ' num2str(gama(g)) ' -c '  num2str(C_param(C))]);
            
%             SVMmodel1=svmtrain(SVMtrSetLabels1,SVMtrSet1, [' -s 0 -t ' num2str(0) ' -g ' num2str(gama(C)) ' -c '  num2str(11)]);
            
            [resultsTrain, TrainAccuracy, TrianDecision] = svmpredict(TrainingSet_Labels, TrainingSet, SVMmodel, ' -q');
            
            performances_train(i)=TrainAccuracy(1);
            
            
            [ValidationResults, ValidationAccuracy, ValidationDecision] = svmpredict(ValidationSet_Labels, ValidationSet, SVMmodel, ' -q');
            
            scores1{repCounter}=ValidationAccuracy(1);               
            performances(i)=ValidationAccuracy(1);
            
            
            
            
        end

        

        SVM_performances(C,g)=mean(performances);
        SVM_performances_std(C,g)=std(performances);
        
        
        
        SVM_performances_train(C,g)=mean(performances_train(:,1));
        SVM_performances_std_train(C,g)=std(performances_train(:,1));
        
        
        repCounter=repCounter+1;
        
%         
    end
 end
 
%  figure(1)
%  surf(C_param,gama,SVM_performances')
%  title('1st classifier')
%  xlabel('C')
%  ylabel('gama')
%  zlabel('performance')


% find best parameters 
[a,b]=max(SVM_performances);
 
[bestPerf,best_gama]=max(a);
 
best_C=b(best_gama);
 
Alldata=[Alldata1;Alldata2;Alldata3];
Alldata_Labels=[Alldata1_Labels;Alldata2_Labels;Alldata3_Labels];



SVMmodelalldata=svmtrain(Alldata_Labels,Alldata, ['-q -s 0 -t ' num2str(2) ' -g ' num2str(gama(best_gama)) ' -c ' num2str(C_param(best_C)) ' -b 1']);

[TRianingResults, TrainingAccuracy, TrainingDecision] = svmpredict(Alldata_Labels, Alldata, SVMmodelalldata, ' -q -b 1');


ClassesPerformances=struct([]);

for i=1:length(classesSet)
    
    ClassesPerformances{i}=[];
    
end


for i=1:4

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
            
            
    [SVMtrSet1,SVMtrSetLabels1]=SVMorganiseData(trSet1,trSetLabels1);
    [SVMvalidSet1,SVMvalidSetLabels1]=SVMorganiseData(validSet1,validSetLabels1);
            
    for kk=1:size(SVMtrSet1,2)
        SVMtrSet1(:,kk)=SVMtrSet1(:,kk)/maxAllData1(kk);
        SVMvalidSet1(:,kk)=SVMvalidSet1(:,kk)/maxAllData1(kk);
    end
            
            
    [SVMtrSet2,SVMtrSetLabels2]=SVMorganiseData(trSet2,trSetLabels2);
    [SVMvalidSet2,SVMvalidSetLabels2]=SVMorganiseData(validSet2,validSetLabels2);
            
            
    for kk=1:size(SVMtrSet2,2)
        SVMtrSet2(:,kk)=SVMtrSet2(:,kk)/maxAllData2(kk);
        SVMvalidSet2(:,kk)=SVMvalidSet2(:,kk)/maxAllData2(kk);
    end
            
    [SVMtrSet3,SVMtrSetLabels3]=SVMorganiseData(trSet3,trSetLabels3);
    [SVMvalidSet3,SVMvalidSetLabels3]=SVMorganiseData(validSet3,validSetLabels3);
            
    for kk=1:size(SVMtrSet3,2)
        SVMtrSet3(:,kk)=SVMtrSet3(:,kk)/maxAllData3(kk);
        SVMvalidSet3(:,kk)=SVMvalidSet3(:,kk)/maxAllData3(kk);
    end
            
            
    TrainingSet=[SVMtrSet1;SVMtrSet2;SVMtrSet3];
    TrainingSet_Labels=[SVMtrSetLabels1;SVMtrSetLabels2;SVMtrSetLabels3];
            
    ValidationSet=[SVMvalidSet1;SVMvalidSet2;SVMvalidSet3];
    ValidationSet_Labels=[SVMvalidSetLabels1;SVMvalidSetLabels2;SVMvalidSetLabels3];
            
            
    SVMmodel=svmtrain(TrainingSet_Labels,TrainingSet, ['-q -s 0 -t ' num2str(2) ' -g ' num2str(gama(best_gama)) ' -c ' num2str(C_param(best_C))]);
            
    results_per_grasp=zeros(3,length(classesSet));
    
    [results_phase1, Accuracy_phase1, Decision_phase1] = svmpredict(SVMvalidSetLabels1, SVMvalidSet1, SVMmodel, ' -q');
    
    for kk=1:length(classesSet)
        truO=SVMvalidSetLabels1(SVMvalidSetLabels1==kk);
        proO=results_phase1(SVMvalidSetLabels1==kk);
        results_per_grasp(1,kk)=(sum(proO==truO)/length(truO))*100;
    end
    
    [results_phase2, Accuracy_phase2, Decision_phase2] = svmpredict(SVMvalidSetLabels2, SVMvalidSet2, SVMmodel, ' -q');
    
    for kk=1:length(classesSet)
        truO=SVMvalidSetLabels2(SVMvalidSetLabels2==kk);
        proO=results_phase2(SVMvalidSetLabels2==kk);
        results_per_grasp(2,kk)=(sum(proO==truO)/length(truO))*100;
    end
    
    [results_phase3, Accuracy_phase3, Decision_phase3] = svmpredict(SVMvalidSetLabels3, SVMvalidSet3, SVMmodel, ' -q');
    
    for kk=1:length(classesSet)
        truO=SVMvalidSetLabels3(SVMvalidSetLabels3==kk);
        proO=results_phase3(SVMvalidSetLabels3==kk);
        results_per_grasp(3,kk)=(sum(proO==truO)/length(truO))*100;
    end
       
    
    
    for cc=1:length(classesSet)
        
        ClassesPerformances{cc}=[ClassesPerformances{cc};results_per_grasp(:,cc)'];
    
    end 
     
        
            
            
            
end







SVMmodelonlylast=svmtrain(Alldata3_Labels,Alldata3, ['-q -s 0 -t ' num2str(2) ' -g ' num2str(gama(best_gama)) ' -c ' num2str(C_param(best_C)) ' -b 1']);

[ValidResults1, ValidAccuracy1, ValidDecision1] = svmpredict(Alldata1_Labels, Alldata1, SVMmodelonlylast, ' -q -b 1');

[ValidResults2, ValidAccuracy2, ValidDecision2] = svmpredict(Alldata2_Labels, Alldata2, SVMmodelonlylast, ' -q -b 1');

[TRianingResults3, TrainingAccuracy3, TrainingDecision3] = svmpredict(Alldata3_Labels, Alldata3, SVMmodelonlylast, ' -q -b 1');

disp('best performance:') 
disp(['model : ' num2str(bestPerf)])

















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
title('SVM Classification performance for each class in each section')
grid on
saveas(gcf,'classifPerf.fig')






end