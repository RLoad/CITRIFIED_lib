function [bEst]=findBestPerformance(RR,div,nbFolders)

bEst=struct([]);



for tw=1:div
    
    avPerformances=zeros(length(RR),1);
    stdPerformances=zeros(length(RR),1);
    bestModel=zeros(length(RR),1);
    for i=1:length(RR)
        avSuccess=zeros(nbFolders,1);
        
        for CVal=1:nbFolders
            avSuccess(CVal)=RR{i}.scores{CVal}.testSuccessRate(tw);         
        end
        [~,bestModel(i)]=max(avSuccess);
        
        avPerformances(i)=mean(avSuccess);
        stdPerformances(i)=std(avSuccess);
    end
    
    [bestPer,indx]=max(avPerformances);
    
    bEst{tw}.performance.per=bestPer;
    bEst{tw}.performance.std=stdPerformances(indx);
    bEst{tw}.performance.model=RR{indx}.esNet{bestModel(indx)}{tw};
    bEst{tw}.performance.spectralRadius=RR{indx}.spectralRadius;
    bEst{tw}.performance.internalUnits=RR{indx}.internalUnits;
    
    [smallestSTD,indx]=min(stdPerformances);
    
    bEst{tw}.std.per=avPerformances(indx);
    bEst{tw}.std.std=smallestSTD;
    bEst{tw}.std.model=RR{indx}.esNet{bestModel(indx)}{tw};
    bEst{tw}.std.spectralRadius=RR{indx}.spectralRadius;
    bEst{tw}.std.internalUnits=RR{indx}.internalUnits;   
    
    
    
end

% figure(1)
% hold on
% for i=1:length(RR)
%     perf=zeros(nbFolders,div);
%     for j=1:nbFolders
%         perf(j,:)=RR{i}.scores{j}.TestMVresults';
%     end
%     plot(-0.150:0.050:2.50,mean(perf))
%     errorbar(-0.150:0.050:2.50,mean(perf),std(perf))
%     
% end
% 
% figure(2)
% hold on
% for i=1:length(RR)
%     perf=zeros(nbFolders,div);
%     for j=1:nbFolders
%         perf(j,:)=RR{i}.scores{j}.addTestMVresults';
%     end
%     plot(-0.150:0.050:2.50,mean(perf))
%     errorbar(-0.150:0.050:2.50,mean(perf),std(perf))
%     
% end
% 





end