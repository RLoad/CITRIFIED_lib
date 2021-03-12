function [dataS,labelS]=SVMorganiseData(Fold,Labels)



dataS=[];

for i=1:length(Fold)

    dataS=[dataS;Fold{i}];
    

end


labelS=[];
for i=1:length(Labels)
    
    for j=1:length(Labels{i})
        labelS=[labelS;Labels{i}{j}];
    end

end



end