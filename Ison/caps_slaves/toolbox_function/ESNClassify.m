

function [scores,results_per_grasp]=ESNClassify(data1,data1_labels,data2,data2_labels,data3,data3_labels,testingSet,historyTW,SR,velocityThreshold,nUnits,spectralRadius,nb_classes)

% delay_TW=0.05*SR;
% 
% finalSample=1.9*SR;
% 
% l_TW=0.15*SR;
% 
% % velocityThreshold=0.1;
% 
% oldVel=0;
% 
% Predictions=[];
% 
% MajVoteOutcome=[];
% 
% MajVoteConfidence=[];
% 
% trueOutput=zeros(length(dataSet),1);
% 
% lastTW=1;
% 
% if strcmp(historyTW,'all')
%     lastTW=1;
% else
%     lastTW=abs(str2double(historyTW));
% end



% organise data to the proper way

% for the 1st classifier
trainingDataSet1=struct([]);
trainlabels1=struct([]);

count=1;
for i=1:length(data1)
    for j=1:length(data1{i})
        
        trainingDataSet1{count}=data1{i}{j};
        trainlabels1{count}=data1_labels{i}{j};
        count=count+1;
        
    end   
end


% for the 2nd classifier
trainingDataSet2=struct([]);
trainlabels2=struct([]);

count=1;
for i=1:length(data2)
    for j=1:length(data2{i})
        
        trainingDataSet2{count}=data2{i}{j};
        trainlabels2{count}=data2_labels{i}{j};
        count=count+1;
        
    end   
end

% for the 2nd classifier
trainingDataSet3=struct([]);
trainlabels3=struct([]);

count=1;
for i=1:length(data3)
    for j=1:length(data3{i})
        
        trainingDataSet3{count}=data3{i}{j};
        trainlabels3{count}=data3_labels{i}{j};
        count=count+1;
        
    end   
end

models=struct([]);

rand( 'seed', 5);
performances=[];
std_performances=[];
oneESNSs=struct([]);
oneESNRpG=struct([]);


for rround=1:2

    disp(['round: ' num2str(rround)])

    myflage=true;
    while myflage
        try
            disp('Generating ESN ............');
            nInternalUnits = nUnits;
            nInputUnits =  size(trainingDataSet1{1},2);   
            nOutputUnits =  size(trainlabels1{1},2); 

            esn = generate_esn(nInputUnits, nInternalUnits, nOutputUnits, 'spectralRadius',spectralRadius,'learningMode', 'offline_multipleTimeSeries', 'reservoirActivationFunction', 'tanh','outputActivationFunction', 'identity','inverseOutputActivationFunction','identity', 'type','plain_esn'); 
            esn.internalWeights = esn.spectralRadius * esn.internalWeights_UnitSR;
            myflage=false;
        catch
            disp('failed to generate an ESN \n start again \n')
        end
    end

    % train 1st ESN

    disp('Training 1st ESN ............');

    nForgetPoints = 1 ; % discard the first 100 points
    [models{1}{1} stateMatrix] = train_esn(trainingDataSet1', trainlabels1', esn, nForgetPoints) ; 


    % train 2nd ESN

    disp('Training 2nd ESN ............');


    [models{2}{1} stateMatrix] = train_esn(trainingDataSet2', trainlabels2', esn, nForgetPoints) ; 
    
    

    % train 3rd ESN

    disp('Training 3rd ESN ............');


    [models{3}{1} stateMatrix] = train_esn(trainingDataSet3', trainlabels3', esn, nForgetPoints) ; 
    
    

    
    disp('validation with testing set ....')



    [oneESNSs{rround},oneESNRpG{rround}]=ESNTest3(models,testingSet,historyTW,SR,velocityThreshold,nb_classes);
    
%     figure(15)
%     hold on
%     plot(-0.05:0.05:length(oneESNSs{rround}.MVsuccessRate)*0.05-0.1,oneESNSs{rround}.MVsuccessRate,'LineWidth',3)
%     
%     figure(16)
%     hold on
%     plot(-0.05:0.05:length(oneESNSs{rround}.TWsuccessRate)*0.05-0.1,oneESNSs{rround}.TWsuccessRate,'LineWidth',3)
    
    performances=[performances;mean(oneESNSs{rround}.MVsuccessRate)];
    std_performances=[std_performances;std(oneESNSs{rround}.MVsuccessRate)];
    
end



[bestPerf,bestModel]=max(performances);
[bestStd,mmodel]=min(std_performances);

disp(['best performance: ' num2str(bestPerf)])


scores=oneESNSs{bestModel};
results_per_grasp=oneESNRpG{bestModel};









end