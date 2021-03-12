function [mean_Vel,FTraj]=OnlinePreprocGonio(signal,SR,B_elbowJoint,A_elbowJoint,B_elbowVel,A_elbowVel,twLength)


% filter singal

FTraj=filter(B_elbowJoint,A_elbowJoint,signal);

% differentiate signal

dTraj=diff(FTraj)/(1/SR);


% filtering velocity

AVel=filter(B_elbowVel,A_elbowVel,dTraj);

% extract the data that correspond to the time window

FTraj=FTraj(round(twLength*SR)+1:end);

mean_Vel=mean(AVel(round(twLength*SR)+1:end));


end