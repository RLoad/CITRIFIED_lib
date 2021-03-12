function [features]=exctractFeatures(Signal,featuresIDs)


features=zeros(length(featuresIDs),size(Signal,2));

if size(Signal,2)>1
    if size(Signal,1)==1
        Signal=Signal';
    end
end

    
for i=1:size(Signal,2)
        
    tmp=zeros(6,1);

    tmp(1)=rms(Signal(:,i));
    tmp(2)=mean(Signal(:,i));
    tmp(3)=std(Signal(:,i));
    tmp(4)=waveformlength(Signal(:,i));
    tmp(5)=zeroCrossings(Signal(:,i),3);
    tmp(6)=slopChanges(Signal(:,i),3);

    features(:,i)=tmp(featuresIDs);
        
end
    
features=reshape(features',1,[]);



end