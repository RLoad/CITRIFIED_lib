

function [TrainPerf,ValidationSuccessRates,results_per_grasp]=train_linearSVM(trainingSet,trainingSet_Labels,testingSet,validationSet_Labels,c_param,historyTW)



lastTW=1;

if strcmp(historyTW,'all')
    lastTW=1;
else
    lastTW=abs(str2double(historyTW));
end


















end



