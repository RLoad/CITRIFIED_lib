function [oneESNSs,oneESNRpG]=ESNCrossValidation_byAngle(dataFolder1,dataFolder2,dataFolder3,testingSet,div,historyTW,classesSet,LabelSet,sbjID,clr,tLast,nbmuscles,nbClasses)


disp('-----------------------------------------------------------')
disp('                Classification with ESN')
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




echoNetworks=struct([]);
repCounter=1;

performances=zeros(4,3);

% for spectralRadius=0.3:0.3
%     for nUn=80:80

        scores=struct([]);
        rPG=struct([]);
        esns=struct([]);
        onescores1=struct([]);
        onerPG1=struct([]);
        esn1=struct([]);
        
        
        onescores2=struct([]);
        onerPG2=struct([]);
        esn2=struct([]);
        
        onescores3=struct([]);
        onerPG3=struct([]);
        esn3=struct([]);
        
        
        for i=1:4

            disp(['repetition: ' num2str(i)])

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
            
%             for kk=1:length(trSet1)
%                 
%                 for jj=1:length(trSet1{kk})
%                     if size(trSetLabels1{kk}{jj},1)<=150
%                         [kk jj]
%                     end
%                 end
%             end

            
            
            % first ESN
            [oneEsn,performance,fistTWperformance,results_per_grasp2_rep1]=train_ESN(trSet1,trSetLabels1,validSet1,validSetLabels1,130,0.7,historyTW);
            onescores1{i}=performance;
            onerPG1{i}=results_per_grasp2_rep1;
            esn1{i}=oneEsn;
            performances(i,1)=performance;
            
            
             % second ESN
            [oneEsn,performance,fistTWperformance,results_per_grasp2_rep1]=train_ESN(trSet2,trSetLabels2,validSet2,validSetLabels2,130,0.7,historyTW);
            onescores2{i}=performance;
            onerPG2{i}=results_per_grasp2_rep1;
            esn2{i}=oneEsn;
            performances(i,2)=performance;
            
             % third ESN
            [oneEsn,performance,fistTWperformance,results_per_grasp2_rep1]=train_ESN(trSet3,trSetLabels3,validSet3,validSetLabels3,130,0.7,historyTW);
            onescores3{i}=performance;
            onerPG3{i}=results_per_grasp2_rep1;
            esn3{i}=oneEsn;
            performances(i,3)=performance;
            
            
        end

        
        
%         oneesnResults{repCounter}.scores=onescores;
%         oneesnResults{repCounter}.resultsPerGrasp=onerPG;
%         oneesnResults{repCounter}.esNet=oneesns;
%         oneesnResults{repCounter}.spectralRadius=0.7;
%         oneesnResults{repCounter}.internalUnits=130;


        echoNetworks{repCounter}{1}=esn1;
        echoNetworks{repCounter}{2}=esn2;
        echoNetworks{repCounter}{3}=esn3;
        
        repCounter=repCounter+1;
        
%         
%     end
% end

[bestPerf1,bestModel1]=max(performances(:,1));
[bestPerf2,bestModel2]=max(performances(:,2));
[bestPerf3,bestModel3]=max(performances(:,3));

bestESNs=struct([]);

bestESNs{1}=esn1{bestModel1};
bestESNs{2}=esn2{bestModel2};
bestESNs{3}=esn3{bestModel3};
disp('best performances:') 
disp(['esn1: ' num2str(bestPerf1)])
disp(['esn2: ' num2str(bestPerf2)])
disp(['esn3: ' num2str(bestPerf3)])

disp('validation with testing set ....')
% bestESNs=findBestPerformanceOneESN2(echoNetworks);

velThreshold=0.1;

if sbjID==2
    velThreshold=0.05;
end
if sbjID==3
    velThreshold=0.02;
end

if sbjID==4
    velThreshold=0.02;
end

[oneESNSs,oneESNRpG]=ESNTest3(bestESNs,testingSet,'8',1000,velThreshold);

clrs={'b','r','m','g'};


if nbmuscles>6
    
    figure(nbClasses)
    hold on
    plot(-0.05:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.1,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3)
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['all muscleset- ' num2str(nbClasses) ' clasees - dynamic classifier'])
    grid on
    
else
    figure(10+nbClasses)
    hold on
    plot(-0.05:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.1,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3)
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['forearm muscles- ' num2str(nbClasses) ' clasees - dynamic classifier'])
    grid on
end




% save(['plots\new_results\sbj' num2str(sbjID) '\CVResults' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classesESN.mat'],'esnResults','oneesnResults','trainingSet','trainingLabels','testingSet','testingLabels','bEst','Ss','RpG','oneESNbEst','oneESNSs','oneESNRpG')
% save(['data/amputee' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classesESNnormTime.mat'],'esnResults','oneesnResults','trainingSet','trainingLabels','testingSet','testingLabels','bEst','Ss','RpG','oneESNbEst','oneESNSs','oneESNRpG')

save(['data/amputee' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classesESN_dynamicClassifier_27032017.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders2','bestESNs','echoNetworks','performances')








end