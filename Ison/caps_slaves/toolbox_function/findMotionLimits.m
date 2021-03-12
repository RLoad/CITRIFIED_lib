function [motionOnset,motionEnd]=findMotionLimits(angVelocity,SR,lengthTW,overlap,forgetTime,velThreshold)


tw=round(lengthTW*SR);
delay_TW=round((lengthTW-overlap)*SR);
firstSample=round(abs(forgetTime*SR))+1;


TWvelocity=[];
tTW=[];


for j=firstSample:delay_TW:length(angVelocity)
         
    if j+tw<length(angVelocity)
        TWvelocity=[TWvelocity;mean(angVelocity(j:j+tw))];
        tTW=[tTW;j+tw];
    end

end
            
% figure()
% 
% plot(tTW,abs(TWvelocity))
% title('angular velocity')
% xlabel('time [s]')
% ylabel('[rad/s]')
% grid on

activeWindows=find(abs(TWvelocity)>velThreshold);

[~,idx]=max(abs(TWvelocity(activeWindows)));

while length(activeWindows)~=length(activeWindows(1):activeWindows(end))
    
    if length(activeWindows(idx:end))~=length(activeWindows(idx):activeWindows(end))
        activeWindows=activeWindows(1:end-1);
    else
        activeWindows=activeWindows(2:end);
    end
    
    [~,idx]=max(abs(TWvelocity(activeWindows)));
    
end

motionOnset=tTW(activeWindows(1))-tw;

motionEnd=tTW(activeWindows(end))+tw;

% vline([motionOnset,motionEnd],{'g','r'},{'onset','end'})



end
