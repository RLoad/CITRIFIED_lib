function [features]=exctractFeatures(Signal,featuresIDs)

% Function to extract features from signals
% 
% Inputs: 
%       Singal:         a matrix where the rows correspond to samples and
%                       the columns correspond to dimensions (channels)
%       featureIDs:     an array of logical values
%                       the length of the array should not be 
%                       grreater than 7
%                       the features correspondence is:
%                       featuresIDs(1): Root Mean Square (RMS)
%                       featuresIDs(2): Mean Average (MAV)
%                       featuresIDs(3): Mean Absolute (aMAV)
%                       featuresIDs(4): Standard Deviation (STD)
%                       featuresIDs(5): Waveform Length (WAV)
%                       featuresIDs(6): Number of Zero Crossings (NZC)
%                       featuresIDs(7): Number of Slope Changes (NSC)
%                       

if size(Signal,2) > 1
    features=zeros(length(sum(featuresIDs)),size(Signal,2));
else
    features=zeros(sum(featuresIDs),1);
end

if size(Signal,2)>1
    if size(Signal,1)==1
        Signal=Signal';
    end
end

    
for i=1:size(Signal,2)
        
    tmp=zeros(7,1);

    tmp(1)=rms(Signal(:,i));
    tmp(2)=mean(Signal(:,i));
    tmp(3)=mean(abs(Signal(:,i)));
    tmp(4)=std(Signal(:,i));
    tmp(5)=waveformlength(Signal(:,i));
    tmp(6)=zeroCrossings(Signal(:,i),3);
    tmp(7)=slopChanges(Signal(:,i),3);

    features(:,i)=tmp(featuresIDs);
        
end
    
features=reshape(features',1,[]);



end