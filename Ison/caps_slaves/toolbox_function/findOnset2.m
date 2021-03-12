function [onsetSample]=findOnset2(Traj,TWLength,overlap,SR,posLPFCutOffFreq,posLPForder,velThreshold)

% offset=250;
% smaplesBeforeOnset=timeBefore*SR;

% trajectory filtering

tw=TWLength*SR;
ov=overlap*SR;

Wn=(posLPFCutOffFreq*2)./SR;
[B,A] = butter(posLPForder,Wn,'low');


historyData=[];

twVellocity=[];


for i=1:(tw-ov):length(Traj)
    
    if i+tw<length(Traj)
    	tmp=[historyData;Traj(i:i+tw)];
        FTraj=filter(B,A,tmp);
        % computing velocity

        dTraj=diff(FTraj)/(1/SR);
        if i==1
            twVellocity=[twVellocity;mean(abs(dTraj))];
        else
            if length(tmp)>tw
                twVellocity=[twVellocity;mean(abs(dTraj(end-tw:end)))];
            else
                twVellocity=[twVellocity;mean(abs(dTraj))];
            end
        end
        historyData=Traj(i:i+tw);
        
    else
        tmp=[historyData;Traj(i:end)];
        FTraj=filter(B,A,tmp);
        % computing velocity

        dTraj=diff(FTraj)/(1/SR);
        if length(tmp)>tw
            twVellocity=[twVellocity;mean(abs(dTraj(end-tw:end)))];
        else
            twVellocity=[twVellocity;mean(abs(dTraj))];
        end
        historyData=Traj(i:end);
        
        
    end;
    
    
    
end




wantedTraj=find(twVellocity(4:end)>velThreshold);

onsetSample=tw+(wantedTraj(1)+3)*(tw-ov);



% 
% 
% 
% % filtering velocity
% 
% Wn=(velLPCutOffFreq*2)./SR;
% 
% [B,A] = butter(velLPorder,Wn,'low');
% 
% FdTraj=filter(B,A,dTraj);
% 
% % absolute value and 
% 
% FdTraj=abs(FdTraj(firstSample+offset:end));
% 
% 
% wantedTraj=find(FdTraj>velThreshold);


% onsetSample=wantedTraj(1)+firstSample+offset-smaplesBeforeOnset;
% 
% if onsetSample<firstSample
%     disp('I found one')
% end
% 
% endSample=wantedTraj(end);


end