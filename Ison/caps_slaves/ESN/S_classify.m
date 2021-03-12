function [all_output,av_predictedOutput, success_rate, av_confidence_all, std_confidence_all, av_max_conf, std_max_conf] = S_classify(predictedOutput, trueOutput, nsteps)

success_rate = 0;
all_output = [];
confidence_all = [];
max_conf = [];
for i = 1:length(predictedOutput)
    time_window = floor(length(predictedOutput{i})/nsteps);
%     nsteps = floor(length(predictedOutput{i})/time_window);
    av_predictedOutput{i} = zeros(nsteps+1,4);
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
    
     predicted_class = zeros(1,4);
     predicted_class(ind) = 1;
     if sum(predicted_class == av_predictedOutput{i}(1,:)) ==4
         success_rate = success_rate +1;
         confidence_all = [confidence_all; confidence];
         max_conf  = [max_conf; ss(end)];
     end     
     
end

success_rate  = 100*(success_rate/length(predictedOutput));
av_confidence_all = mean(confidence_all);
std_confidence_all = std(confidence_all);
av_max_conf  = mean(max_conf);
std_max_conf  = std(max_conf);
% for i=1:length(all_output)
%     all_output(i,:) = exp(all_output(i,:))/sum(exp(all_output(i,:)));
% end