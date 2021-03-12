% This function returns the number of zero crossings in the sequence. a
% zero crossing is defined as: 
%               {x(i)>0 and x(i-1)<0} or {x(i)<0 and x(i-1)>0}



function ZC=zeroCrossings(sequence,e)
                
L=length(sequence);

count_zc=0;
for i=1+e:e:L
    A=sequence(i-e);
    B=sequence(i);
    if (A>0 && B<0) || (A<0 && B>0)
        count_zc=count_zc+1;
    end
end

ZC=count_zc;

end
