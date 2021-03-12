

function [timings]=anglePercentage(gonio,percentages,SR,LPFCutOffFreq,LPForder)

dumbingSamples=50;

timings=zeros(length(percentages),1);

Wn=(LPFCutOffFreq*2)./SR;

[B,A] = butter(LPForder,Wn,'low');

FTraj=filter(B,A,gonio);

FTrafj_Norm=abs(FTraj(dumbingSamples:end)-FTraj(dumbingSamples));

% figure()
% 
% subplot(3,1,1)
% hold on
% plot(1/SR:(1/SR):(length(gonio)/SR),gonio*180/pi)
% title('raw signal')
% ylabel('degrees')
% 
% subplot(3,1,2)
% hold on
% plot(1/SR:(1/SR):(length(FTraj)/SR),FTraj*180/pi)
% title(['filtered signal order ' num2str(LPForder) ' cut off freq ' num2str(LPFCutOffFreq)])
% ylabel('degrees')
% 
% subplot(3,1,3)
% hold on
% plot(1/SR:(1/SR):(length(FTrafj_Norm)/SR),FTrafj_Norm*180/pi)
% title('normalized filtered signal')
% ylabel('degrees')
% xlabel('time [s]')

finalValue=FTrafj_Norm(end);

for i=1:length(percentages)

    %perc=percentages(i);
    
    if percentages(i)<100
        
        %tM=perc*finalValue;
        
        timings(i)=dumbingSamples+sum(FTrafj_Norm<finalValue*percentages(i)/100);
        
        
    else
        
        if percentages(i)==100
            timings(i)=length(gonio);
        else
            
            timings(i)=(percentages(i)/100)*length(gonio);
            
        end
        
    end
    
end





end