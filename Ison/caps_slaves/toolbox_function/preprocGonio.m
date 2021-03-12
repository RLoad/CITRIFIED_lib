function [AVel,FTraj]=preprocGonio(signal,SR,posLPFCutOffFreq,posLPForder,velLPCutOffFreq,velLPorder)



Wn=(posLPFCutOffFreq*2)./SR;

[B,A] = butter(posLPForder,Wn,'low');

FTraj=filter(B,A,signal);

% computing velocity

dTraj=diff(FTraj)/(1/SR);


% filtering velocity

Wn=(velLPCutOffFreq*2)./SR;

[B,A] = butter(velLPorder,Wn,'low');

AVel=filter(B,A,dTraj);







end