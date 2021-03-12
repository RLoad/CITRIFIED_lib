function [bEst]=findBestPerformance2(Models,Scores)


bEst=struct([]);

for i=1:length(Scores{1}.testSuccessRate)
    tmp=zeros(1,length(Models));
    
    for j=1:length(Models)
        tmp(j)=Scores{j}.testSuccessRate(i);
    end
    [~,indx]=max(tmp);
    
    bEst{i}=Models{indx}{i};
    
    
end







end