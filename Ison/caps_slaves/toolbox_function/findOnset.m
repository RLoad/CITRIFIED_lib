function [onsetSample,endSample]=findOnset(Traj,timeBefore,firstSample,SR,posLPFCutOffFreq,posLPForder,velLPCutOffFreq,velLPorder,velThreshold)

offset=250;
smaplesBeforeOnset=timeBefore*SR;

% trajectory filtering

Wn=(posLPFCutOffFreq*2)./SR;

[B,A] = butter(posLPForder,Wn,'low');

FTraj=filter(B,A,Traj);


% computing velocity

dTraj=diff(FTraj)/(1/SR);


% filtering velocity

Wn=(velLPCutOffFreq*2)./SR;

[B,A] = butter(velLPorder,Wn,'low');

FdTraj=filter(B,A,dTraj);

% absolute value and 

FdTraj=abs(FdTraj(firstSample+offset:end));


wantedTraj=find(FdTraj>velThreshold);


onsetSample=wantedTraj(1)+firstSample+offset-smaplesBeforeOnset;

if onsetSample<firstSample
    disp('I found one')
end

endSample=wantedTraj(end);


end