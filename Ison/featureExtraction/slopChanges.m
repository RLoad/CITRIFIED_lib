% This functions counts the slope slid changes of the sequence input 
% "sequence". 
%           sequence: a vector (matrix Lx1)
%           e:        a positive number

% explanation of the algorithm:
%   for every loop 3 samples are exatred (sequence(i), sequence(i+e),
%   sequence(i+2e)), where e is the threshold
%   if the sign of the substraction for these consetutive samples changes,
%   then the slop sign is changed, increasing the counter by 1




function A=slopChanges(sequence,e)

L=length(sequence);

count_slops=0;

for i=1:2*e:L-2*e
    SubA=sequence(i+e)-sequence(i);
    SubB=sequence(i+e)-sequence(i+2*e);
    if SubA>0 && SubB>0
        count_slops=count_slops+1;
    end
end


A=count_slops;

end
