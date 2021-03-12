function confidence=confPerGrasp(predictedOutput,trueOutput,confVector,nb_classes)

% nb_classes=length(unique(trueOutput));

% confMat=zeros(nb_classes,nb_classes);

% classes=unique(trueOutput);

confidence=zeros(1,nb_classes);

for i=1:nb_classes
    
    trials=predictedOutput(trueOutput==i);
    
    
    tre=confVector(trueOutput==i);
    
    confidence(i)=mean(tre(trials==i));
%     for j=1:nb_classes
%         
%         confMat(i,j)=(length(trials(trials==j))/length(trials))*100;
%         
%     end    
    
end


end