function [output]=signalRMS(Signal)

output=struct([]);
%TWcounter=1;

for i=1:length(Signal)
    
    output{i}=rms(Signal{i});
    
end



end