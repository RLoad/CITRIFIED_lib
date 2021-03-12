function [output]=createTW2(firstSample,finalSample,Signal,lenthgTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,extFeatures,featuresIDs)

% it discards the time windows that have smaller length than the desired
% length of the time window


output=struct([]);

%Signal=preprocessSignals(Signal(fistSample:end,:),SR,[50,400],20);

Signal=preprocessSignals(Signal,SR,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc);

l_TW=lenthgTW*SR;
delay_TW=l_TW-overlap*SR;
countTW=1;

for i=firstSample:delay_TW:finalSample
    
    if i+l_TW<finalSample
       if extFeatures
            output{countTW}=exctractFeatures(Signal(i:i+l_TW,MuscleSet),featuresIDs);
        else
            output{countTW}=Signal(i:i+l_TW,MuscleSet);
        end
        
         countTW=countTW+1;
    end
    
   
end






end