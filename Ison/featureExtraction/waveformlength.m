% This function returns the waveform length of the sequence. for every step
% new substraction is added. the waveform length is the cumulative length
% of the waveform over the sequence.



function B=waveformlength(sequence)

L=length(sequence);

sum_length=0;

for i=2:L
    Sub=abs(sequence(i)-sequence(i-1));
    sum_length=sum_length+Sub;
end

B=sum_length;

end