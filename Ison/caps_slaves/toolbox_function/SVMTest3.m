function [scores,results_per_grasp]=SVMTest3(Models,dataSet,historyTW,SR,velocityThreshold,maxValues,nb_classes)


delay_TW=0.05*SR;

finalSample=2.2*SR;

l_TW=0.15*SR;

% velocityThreshold=0.1;

oldVel=0;

Predictions=[];

MajVoteOutcome=[];

MajVoteConfidence=[];

trueOutput=zeros(length(dataSet),1);

lastTW=1;

if strcmp(historyTW,'all')
    lastTW=1;
else
    lastTW=abs(str2double(historyTW));
end


counter1=0;
counter2=0;
counter3=0;

predictions=struct([]);
MajVoteOutcome=struct([]);
MajVoteConfidence=struct([]);


for trl=1:length(dataSet)
    
    
    trueOutput(trl)=dataSet{trl}.label;
    TWcounter=1;
    
    trialOutput=[];
    
    MVoutput=[];
    
    TWconfidence=[];
    
    previousModel=Models{1};
    
    tmCounter=1;
    
    for i=1:delay_TW:min([finalSample,(length(dataSet{trl}.emg)*0.05-0.1)*SR])
        
        newVel=abs(mean(dataSet{trl}.angularVelocity(i:i+l_TW)));
        
        timeWindowOutputTest=0;
        
        if newVel>velocityThreshold
        
        
            if newVel>=oldVel
            
                timeWindowOutputTest=svmpredict(1,dataSet{trl}.emg{TWcounter}./maxValues{1},  Models{1}, ' -q');
            
%                 [~,timeWindowOutputTest]=max(sum(predictedOutput));
            
                oldVel=newVel;
            
                previousModel=Models{1};
            
                counter1=counter1+1;
            
            else
%                 newVel<oldVel
                timeWindowOutputTest=svmpredict(1,dataSet{trl}.emg{TWcounter}./maxValues{2},  Models{2}, ' -q');
                
                
                
                oldVel=newVel;
            
                previousModel=Models{2};
                
                counter2=counter2+1;
                
            end
        else
                
            
            timeWindowOutputTest=svmpredict(1,dataSet{trl}.emg{TWcounter}./maxValues{3},  Models{3}, ' -q');
            
                
                oldVel=newVel;
            
                previousModel=Models{3};
                
                counter3=counter3+1;
                
        end
    
            
        
        

        trialOutput=[trialOutput,timeWindowOutputTest];

        winner=0;
        conf=0;

        if TWcounter<=lastTW
            [winner,conf]=majorityVote(trialOutput);
        else
            [winner,conf]=majorityVote(trialOutput(TWcounter-lastTW:end));
        end
        
        

        MVoutput=[MVoutput,winner];

        TWconfidence=[TWconfidence,conf];

        TWcounter=TWcounter+1;
        
        
    end
    
    predictions{trl}=trialOutput;
    MajVoteOutcome{trl}=MVoutput;
    MajVoteConfidence{trl}=TWconfidence;

    
end



TWsuccessRate=zeros(1,(finalSample/delay_TW)-1);
MVsuccessRate=zeros(1,(finalSample/delay_TW)-1);

results_per_grasp=struct();

results_per_grasp.ESNtw=struct([]);
results_per_grasp.MVtw=struct([]);
results_per_grasp.conf=[];


for i=1:(finalSample/delay_TW)-1
    
    twPredictions=[];
    
    MVPredictions=[];
    
    trueOutput=[];
    
    TWconfidence=[];
    
   
    
    counterTrl=1;
    
    for j=1:length(predictions)
    
%         if i==43
%             if j==48
%                 [j i]
%             end
%         end
        if i<length(predictions{j})
            
            trueOutput=[trueOutput;dataSet{j}.label];
            
            twPredictions=[twPredictions,predictions{j}(i)];
            
            winner=0;
            conf=0;

            if i<=lastTW
                [winner,conf]=majorityVote(predictions{j}(1:i));
            else
                [winner,conf]=majorityVote(predictions{j}(i-lastTW:i));
            end
            
            
            
            MVPredictions=[MVPredictions,winner];
            TWconfidence=[TWconfidence,conf];
            
            counterTrl=counterTrl+1;
        end
        
        
    end
    
    
    
    TWsuccessRate(i)=100*sum(twPredictions'==trueOutput)/(counterTrl-1);
    MVsuccessRate(i)=100*sum(MVPredictions'==trueOutput)/(counterTrl-1);
    
    results_per_grasp.MVtw{i}=predictionPerGrasp(MVPredictions,trueOutput,nb_classes);
    
    results_per_grasp.ESNtw{i}=predictionPerGrasp(twPredictions,trueOutput,nb_classes);
    
%     MajVoteConfidence{trl}=[MajVoteConfidence{trl};TWconfidence];
    
    results_per_grasp.conf=[results_per_grasp.conf;confPerGrasp(MVPredictions,trueOutput,TWconfidence,nb_classes)];
    
    
    
    
end

scores=struct();

scores.TWsuccessRate=TWsuccessRate;
scores.MVsuccessRate=MVsuccessRate;
scores.Predictions=predictions;
scores.MajVoteOutcome=MajVoteOutcome;
scores.MajVoteConfidence=MajVoteConfidence;












end