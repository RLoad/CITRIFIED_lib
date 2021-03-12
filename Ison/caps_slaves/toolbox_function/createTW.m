function [output]=createTW(firstSample,Signal,lenthgTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,extFeatures,featuresIDs)

output=struct([]);

%Signal=preprocessSignals(Signal(fistSample:end,:),SR,[50,400],20);

Signal=preprocessSignals(Signal,SR,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc);

l_TW=lenthgTW*SR;
delay_TW=l_TW-overlap*SR;
countTW=1;

for i=firstSample:delay_TW:length(Signal)
    
    if i+l_TW>length(Signal)
        if extFeatures
            output{countTW}=exctractFeatures(Signal(i:end,MuscleSet),featuresIDs);
        else
            output{countTW}=Signal(i:end,MuscleSet);
        end
    else
        if extFeatures
            output{countTW}=exctractFeatures(Signal(i:i+l_TW,MuscleSet),featuresIDs);
        else
            output{countTW}=Signal(i:i+l_TW,MuscleSet);
        end
    end
    
    countTW=countTW+1;
end






end