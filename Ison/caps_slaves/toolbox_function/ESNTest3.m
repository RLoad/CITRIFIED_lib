function [scores,results_per_grasp]=ESNTest3(esnModel,dataSet,historyTW,SR,velocityThreshold,nb_classes)

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
    
    previousModel=esnModel{1};
    
    
    for i=1:delay_TW:min([finalSample,(length(dataSet{trl}.emg)*0.05-0.1)*SR])


        newVel=abs(mean(dataSet{trl}.angularVelocity(i:i+l_TW)));
        
        timeWindowOutputTest=0;
        
        if newVel>velocityThreshold
        
        
            if newVel>=oldVel
            
                predictedOutput=test_esn(dataSet{trl}.emg{TWcounter},  esnModel{1}{1}, 1);
            
                [~,timeWindowOutputTest]=max(sum(predictedOutput));
            
                oldVel=newVel;
            
                previousModel=esnModel{1};
            
                counter1=counter1+1;
            
            else
%                 newVel<oldVel
                
                predictedOutput=test_esn(dataSet{trl}.emg{TWcounter},  esnModel{2}{1}, 1);
                
                [~,timeWindowOutputTest]=max(sum(predictedOutput));
                
                oldVel=newVel;
            
                previousModel=esnModel{2};
                
                counter2=counter2+1;
                
            end
        else
                
                predictedOutput=test_esn(dataSet{trl}.emg{TWcounter},  esnModel{3}{1}, 1);
                
                [~,timeWindowOutputTest]=max(sum(predictedOutput));
                
                oldVel=newVel;
            
                previousModel=esnModel{3};
                
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



% 
% 
% 
% 
% trueOutputTest=zeros(length(dataSet),1);
% for i=1:length(dataSet)
%     [~,trueOutputTest(i)]=max(labelsSet{i}{1}(1,:));
% end
% 
% 
% results_per_grasp=struct();
% 
% results_per_grasp.ESNtw=struct([]);
% results_per_grasp.MVtw=struct([]);
% results_per_grasp.conf=[];
% 
% scores=struct();
% 
% 
% scores.testSuccessRate=[];
% scores.testTWConfAv=[];
% scores.testTWConfStd=[];
% scores.TestMVresults=[];
% scores.TestMVconfAv=[];
% scores.TestMVconfStd=[];
% scores.addTestMVresults=[];
% scores.addTestMVconfAv=[];
% scores.addTestMVconfStd=[];
% 
% allTWOutputsTest=zeros(length(dataSet),div);
% mv_results=zeros(length(dataSet),div);
% 
% for i=1:div
%     
%     testInputSequence=struct([]);
%     testOutputSequence=struct([]);
%     
%     timeWindowOutputTest=zeros(length(dataSet),1);
%     
%     for j=1:length(dataSet)
%         testInputSequence{j}=dataSet{j}{i};
%         testOutputSequence{j}=labelsSet{j}{i};
%     end
%     
%     predictedTestOutput = [];
%     nForgetPoints=10;
%     for j=1:length(testOutputSequence)
%         
%         predictedTestOutput{j} = zeros(length(testInputSequence{j})-nForgetPoints, size(testOutputSequence{1},2));
% 
%         predictedTestOutput{j} = test_esn(testInputSequence{j},  esnModel, nForgetPoints) ; 
% 
%         [val,timeWindowOutputTest(j)]=max(sum(predictedTestOutput{j}));
%         
%         sorted=sort(sum(predictedTestOutput{j}));
%         
%         TWconfs(j)=(sorted(end)-sorted(end-1))/sorted(end);
%         
%     end
%     
%     
%     
%     successRateTest=100*sum(timeWindowOutputTest==trueOutputTest)/length(dataSet);
%     
%     results_per_grasp.ESNtw{i}=predictionPerGrasp(timeWindowOutputTest,trueOutputTest);
%     
%     scores.testSuccessRate=[scores.testSuccessRate;successRateTest];
%     
%     allTWOutputsTest(:,i)=timeWindowOutputTest;
%     
%     scores.testTWConfAv=[scores.testTWConfAv;mean(TWconfs)];
%     scores.testTWConfStd=[scores.testTWConfStd;std(TWconfs)];
%     
%     winners=zeros(length(testOutputSequence),1);
%     conf=zeros(length(testOutputSequence),1);
%     
%     winners2=zeros(length(testOutputSequence),1);
%     conf2=zeros(length(testOutputSequence),1);
%     
%     for j=1:length(testOutputSequence)
%         
%         [winners(j),conf(j)]=majorityVote(allTWOutputsTest(j,1:i));
%         
%         if i<=lastTW
%             [winners2(j),conf2(j)]=majorityVote(allTWOutputsTest(j,1:i));
%         else
%             [winners2(j),conf2(j)]=majorityVote(allTWOutputsTest(j,i-lastTW:i));
%         end
%         
%     end
%     
%     mv_results(:,i)=winners2;
%     
%     %plotconfusion(winners2,trueOutputTest)
%     
%     MVsuccessRateTest=100*sum(winners==trueOutputTest)/length(dataSet);
%     
%     results_per_grasp.MVtw{i}=predictionPerGrasp(winners2,trueOutputTest);
%     
%     cc=confPerGrasp(winners2,trueOutputTest,conf2);
%     
%     results_per_grasp.conf=[results_per_grasp.conf;cc];
%     
%     scores.TestMVresults=[scores.TestMVresults;MVsuccessRateTest];
%     
%     scores.TestMVconfAv=[scores.TestMVconfAv;mean(conf)];
%     
%     scores.TestMVconfStd=[scores.TestMVconfStd;std(conf)];
%     
%     MVsuccessRateTest2=100*sum(winners2==trueOutputTest)/length(dataSet);
%     
%     scores.addTestMVresults=[scores.addTestMVresults;MVsuccessRateTest2];
%     
%     scores.addTestMVconfAv=[scores.addTestMVconfAv;mean(conf2)];
%     
%     scores.addTestMVconfStd=[scores.addTestMVconfStd;std(conf2)];
%     
%     
% end
% 
% 
% results_per_grasp.mv_r=mv_results;
% 
% % figure(5)
% % plot(-0.150:0.050:2.50,scores.TestMVresults)
% % hold on
% % plot(-0.150:0.050:2.50,scores.addTestMVresults)
% % grid on
% 




end