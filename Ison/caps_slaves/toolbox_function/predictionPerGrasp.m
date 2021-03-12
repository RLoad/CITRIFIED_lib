function [confMat]=predictionPerGrasp(predictedOutput,trueOutput,nb_classes)

% nb_classes=length(unique(trueOutput));

confMat=zeros(nb_classes,nb_classes);



for i=1:nb_classes
    
    trials=predictedOutput(trueOutput==i);
    
    for j=1:nb_classes
        
        confMat(i,j)=(length(trials(trials==j))/length(trials))*100;
        
    end    
    
end


end