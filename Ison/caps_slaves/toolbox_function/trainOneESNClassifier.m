function [oneESNSs,oneESNRpG]=trainOneESNClassifier(dataFolder1,dataFolder2,dataFolder3,testingSet,div,historyTW,classesSet,LabelSet,sbjID,clr,tLast,nbmuscles,nbClasses)


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




%%



trSet1=[crossValidationFolders1{1}.data(:);crossValidationFolders1{2}.data(:);crossValidationFolders1{3}.data(:);crossValidationFolders1{4}.data(:)];
trSetLabels1=[crossValidationFolders1{1}.labels(:);crossValidationFolders1{2}.labels(:);crossValidationFolders1{3}.labels(:);crossValidationFolders1{4}.labels(:)];
            
trSet2=[crossValidationFolders2{1}.data(:);crossValidationFolders2{2}.data(:);crossValidationFolders2{3}.data(:);crossValidationFolders2{4}.data(:)];
trSetLabels2=[crossValidationFolders2{1}.labels(:);crossValidationFolders2{2}.labels(:);crossValidationFolders2{3}.labels(:);crossValidationFolders2{4}.labels(:)];
            
trSet3=[crossValidationFolders3{1}.data(:);crossValidationFolders3{2}.data(:);crossValidationFolders3{3}.data(:);crossValidationFolders3{4}.data(:)];
trSetLabels3=[crossValidationFolders3{1}.labels(:);crossValidationFolders3{2}.labels(:);crossValidationFolders3{3}.labels(:);crossValidationFolders3{4}.labels(:)];


% organise data to the proper way

% for the 1st classifier
trainingDataSet1=struct([]);
trainlabels1=struct([]);

count=1;
for i=1:length(trSet1)
    for j=1:length(trSet1{i})
        
        trainingDataSet1{count}=trSet1{i}{j};
        trainlabels1{count}=trSetLabels1{i}{j};
        count=count+1;
        
    end   
end


% for the 2nd classifier
trainingDataSet2=struct([]);
trainlabels2=struct([]);

count=1;
for i=1:length(trSet2)
    for j=1:length(trSet2{i})
        
        trainingDataSet2{count}=trSet2{i}{j};
        trainlabels2{count}=trSetLabels2{i}{j};
        count=count+1;
        
    end   
end

% for the 2nd classifier
trainingDataSet3=struct([]);
trainlabels3=struct([]);

count=1;
for i=1:length(trSet3)
    for j=1:length(trSet3{i})
        
        trainingDataSet3{count}=trSet3{i}{j};
        trainlabels3{count}=trSetLabels3{i}{j};
        count=count+1;
        
    end   
end


% for one classifier

trainingDataSet=[trainingDataSet1(:);trainingDataSet2(:);trainingDataSet3(:)];
trainlabels=[trainlabels1(:);trainlabels2(:);trainlabels3(:)];

%%

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



models=struct([]);
performances=[];
std_performances=[];
oneESNSs2=struct([]);
oneESNRpG2=struct([]);


rand( 'seed', 5 );

for rround=1:2

    disp(['round: ' num2str(rround)])

    myflage=true;
    while myflage
        try
            disp('Generating ESN ............');
            nInternalUnits = 150;
            nInputUnits =  size(trainingDataSet{1},2);   
            nOutputUnits =  size(trainlabels{1},2); 

            esn = generate_esn(nInputUnits, nInternalUnits, nOutputUnits, 'spectralRadius',0.7,'learningMode', 'offline_multipleTimeSeries', 'reservoirActivationFunction', 'tanh','outputActivationFunction', 'identity','inverseOutputActivationFunction','identity', 'type','plain_esn'); 
            esn.internalWeights = esn.spectralRadius * esn.internalWeights_UnitSR;
            myflage=false;
        catch
            disp('failed to generate an ESN \n start again \n')
        end
    end

    % train ESN

    disp('Training ESN ............');

    nForgetPoints = 1 ; % discard the first 100 points
    [models{1}{1} stateMatrix] = train_esn(trainingDataSet, trainlabels, esn, nForgetPoints) ; 
    
    models{2}{1}=models{1}{1};
    models{3}{1}=models{1}{1};

    
    disp('validation with testing set ....')



    [oneESNSs2{rround},oneESNRpG2{rround}]=ESNTest3(models,testingSet,historyTW,1000,velThreshold,length(classesSet));
    
    
    performances=[performances;mean(oneESNSs2{rround}.MVsuccessRate(~isnan(oneESNSs2{rround}.MVsuccessRate)))];
    std_performances=[std_performances;std(oneESNSs2{rround}.MVsuccessRate(~isnan(oneESNSs2{rround}.MVsuccessRate)))];
    
end



[bestPerf,bestModel]=max(performances);
[bestStd,mmodel]=min(std_performances);



disp(['best performance: ' num2str(bestPerf)])


oneESNSs=oneESNSs2{bestModel};
oneESNRpG=oneESNRpG2{bestModel};




clrs={'b','r','m','g','y'};


if nbmuscles>6
    
    figure(nbClasses)
    hold on
    plot(0:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.05,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3)
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['all muscleset- ' num2str(nbClasses) ' classes - one and dynamic classifier'])
    grid on
    
else
    figure(10+nbClasses)
    hold on
    plot(0:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.05,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3)
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['forearm muscles- ' num2str(nbClasses) ' classes - one and dynamic classifier'])
    grid on
end




% for amputees

%save(['data/amputee' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classes_oneESNClassifier_01042017.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders2')

% for able-bodied

save(['data/ableBodied' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classes_oneESNClassifier_02042017.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders3')

[oneESNSs,oneESNRpG]=ESNClassify(trSet1,trSetLabels1,trSet2,trSetLabels2,trSet3,trSetLabels3,testingSet,historyTW,1000,velThreshold,150,0.7,length(classesSet));



clrs={'b','r','m','g','y'};


if nbmuscles>6
    
    figure(nbClasses)
    hold on
    plot(0:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.05,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3,'LineStyle','--')
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['all muscleset- ' num2str(nbClasses) ' clasees - one and dynamic classifier'])
    grid on
    
else
    figure(10+nbClasses)
    hold on
    plot(0:0.05:length(oneESNSs.MVsuccessRate)*0.05-0.05,oneESNSs.MVsuccessRate,'Color',clrs{sbjID},'LineWidth',3,'LineStyle','--')
    ylabel('classification accuracy [%]')
    xlabel('time [s]')
    title(['forearm muscles- ' num2str(nbClasses) ' clasees - one and dynamic classifier'])
    grid on
end


% for amputees
% save(['data/amputee' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classesESN_dynamicClassifier_01042017_correct2.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders2')

% for able-bodied

save(['data/ableBodied' num2str(sbjID) '/results/' num2str(nbmuscles) 'muscles' num2str(nbClasses) 'classes_ESN_dynamicClassifier_02042017.mat'],'oneESNSs','oneESNRpG','testingSet','crossValidationFolders1','crossValidationFolders2','crossValidationFolders2')




end