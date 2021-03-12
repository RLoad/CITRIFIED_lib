function ch=checkVelocity(Traj,SR,posLPFCutOffFreq,posLPForder,velLPCutOffFreq,velLPorder,velThreshold)


ch=0;

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

%FdTraj=abs(FdTraj(firstSample+offset:end));
FdTraj=abs(FdTraj);

if mean(FdTraj)>velThreshold
    ch=1;
end
    



end