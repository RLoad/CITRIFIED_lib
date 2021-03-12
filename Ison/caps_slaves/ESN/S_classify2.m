function [all_output,av_predictedOutput, success_rate, av_confidence_all, std_confidence_all, av_max_conf, std_max_conf, error, error2, confidence_matrix] = S_classify2(predictedOutput, trueOutput, nsteps,tw, proc)

success_rate = 0;
all_output = [];
confidence_all = [];
max_conf = [];
error=zeros(length(predictedOutput),1);
error2=zeros(length(predictedOutput),1);
confidence_matrix=struct();
tw_matrix=[0.25;0.35;0.45;0.55;0.65;0.75;0.85;0.95;1.05;1.15;1.25;1.35;1.45;1.55;1.65;1.75];
count3=1;
count4=1;
count5=1;
conf03=struct([]);
conf04=struct([]);
conf05=struct([]);

for i = 1:length(predictedOutput)
    
    time_window = floor(length(predictedOutput{i})/nsteps);
%     nsteps = floor(length(predictedOutput{i})/time_window);
    av_predictedOutput{i} = zeros(nsteps+1,2);
    av_predictedOutput{i}(1,:) = trueOutput{i}(1,:);
    for j=1:nsteps-1
        av_predictedOutput{i}(j+1,:) = mean(predictedOutput{i}((j-1)*time_window+1:j*time_window,:));
    end
     av_predictedOutput{i}(nsteps+1,:) = mean(predictedOutput{i}((nsteps-1)*time_window+1:end, :));
     sum_av_predictedOutput = sum(av_predictedOutput{i}(2:end,:));
     all_output = [all_output;  sum_av_predictedOutput./sum(sum_av_predictedOutput) ];

%     sum_av_predictedOutput =  sum(predictedOutput{i}(2:end,:));
%      [val, ind] = max(sum_av_predictedOutput );
    [val, ind] = max(sum_av_predictedOutput./sum(sum_av_predictedOutput));
     
     ss = sort(sum_av_predictedOutput./sum(sum_av_predictedOutput));
     confidence = ss(end)-ss(end-1);
    
     predicted_class = zeros(1,2);
     predicted_class(ind) = 1;
     if sum(predicted_class == av_predictedOutput{i}(1,:)) ==2
         success_rate = success_rate +1;
         confidence_all = [confidence_all; confidence];
         max_conf  = [max_conf; ss(end)];
         if tw~=12 && i~=25 
         if confidence>0.3
            conf03{count3}.id=i;
            
            %[PropHand,PropArm]=gsp_meta2(i,tw_matrix(tw),proc);
            %conf03{count3}.PropHand=PropHand;
            conf03{count3}.PropHand=1;
%             conf03{count3}.PropArm=PropArm;
%             conf03{count3}.Confidence=confidence;
            conf03{count3}.PropArm=1;
            conf03{count3}.Confidence=1;
            count3=count3+1;
         end
         if confidence>0.4
            conf04{count4}.id=i;
            %[PropHand,PropArm]=gsp_meta2(i,tw_matrix(tw),proc);
%             conf04{count4}.PropHand=PropHand;
%             conf04{count4}.PropArm=PropArm;
%             conf04{count4}.Confidence=confidence;
            conf04{count4}.PropHand=1;
            conf04{count4}.PropArm=1;
            conf04{count4}.Confidence=1;
            count4=count4+1;
         end
         if confidence>0.5
            conf05{count5}.id=i;
            %[PropHand,PropArm]=gsp_meta2(i,tw_matrix(tw),proc);
%             conf05{count5}.PropHand=PropHand;
%             conf05{count5}.PropArm=PropArm;
%             conf05{count5}.Confidence=confidence;
            conf05{count5}.PropHand=1;
            conf05{count5}.PropArm=1;
            conf05{count5}.Confidence=1;
            count5=count5+1;
         end
         end
         error2(i)=ind;
     else
         error(i)=find(predicted_class,1);
         error2(i)=find(predicted_class,1);
     end     
     
end

confidence_matrix.conf3=conf03;
confidence_matrix.conf4=conf04;
confidence_matrix.conf5=conf05;


success_rate  = 100*(success_rate/length(predictedOutput));
av_confidence_all = mean(confidence_all);
std_confidence_all = std(confidence_all);
av_max_conf  = mean(max_conf);
std_max_conf  = std(max_conf);
% for i=1:length(all_output)
%     all_output(i,:) = exp(all_output(i,:))/sum(exp(all_output(i,:)));
% end