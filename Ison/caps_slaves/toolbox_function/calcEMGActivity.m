function [aRMS,aAver,aSlop]=calcEMGActivity(sData,varargin)

lengthTW=0.150;
overlap=0.100;
SR=1000;

ClasseIDs=2:6;
MuscleSet=1:size(sData.grasp{1}.trial{1}.emg,2);

bandPassCuttOffFreq=[50,400];
lowPassCutOffFreq=20;
timeBefore=0.300;
posLPFCutOffFreq=40;
posLPForder=7;
velLPCutOffFreq=5;
velLPorder=2;
velThreshold=0.05;
nbCrossValidationFolders=3;
normaLize=false;
mvc=calcMVC(sData,ClasseIDs);
rectiFy=true;
extFeatures=false;
featuresIDs=[];
trialsForExclusion=[];
nbTw=44;

ClasseIDs=2:6;


if ~isempty(varargin)
    for kk=1:2:length(varargin)
         if strcmp(varargin{kk},'FirstSample')
            firstSample=varargin{kk+1};
         end
         if strcmp(varargin{kk},'TwLength')
             lengthTW=varargin{kk+1};
         end
         if strcmp(varargin{kk},'SampleRate')
             SR=varargin{kk+1};
         end
         if strcmp(varargin{kk},'MuscleSet')
             MuscleSet=varargin{kk+1};
         end
         if strcmp(varargin{kk},'OverLap')
             overlap=varargin{kk+1};
         end
         if strcmp(varargin{kk},'BandPassCuttOffFreqEMG')
             bandPassCuttOffFreq=varargin{kk+1};
         end
         if strcmp(varargin{kk},'LowPassCutOffFreqEMG')
             lowPassCutOffFreq=varargin{kk+1};
         end
         if strcmp(varargin{kk},'TimeBeforeOnset')
             timeBefore=varargin{kk+1};
         end
         if strcmp(varargin{kk},'TimeBeforeOnset')
             timeBefore=varargin{kk+1};
         end
         if strcmp(varargin{kk},'GoniometerAngleLowPassCutOffFreq')
             posLPFCutOffFreq=varargin{kk+1};
         end
         if strcmp(varargin{kk},'GoniometerAngleLowPassOrder')
             posLPForder=varargin{kk+1};
         end
         if strcmp(varargin{kk},'GoniometerVelocityLowPassCutOffFreq')
             velLPCutOffFreq=varargin{kk+1};
         end
         if strcmp(varargin{kk},'GoniometerVelocityLowPassOrder')
             velLPorder=varargin{kk+1};
         end
         if strcmp(varargin{kk},'VelocityThreshold')
            velThreshold=varargin{kk+1};
         end
         if strcmp(varargin{kk},'NumberOfDataFolders')
            nbCrossValidationFolders=varargin{kk+1};
         end
         if strcmp(varargin{kk},'Normalization')
            normaLize=varargin{kk+1};
         end
         if strcmp(varargin{kk},'Rectification')
            rectiFy=varargin{kk+1};
         end
         if strcmp(varargin{kk},'FeatureExtraction')
            extFeatures=true;
            nbFeatures=length(varargin{kk+1});
            for i=1:nbFeatures
                if strcmp(varargin{kk+1}{i},'RMS')
                    featuresIDs=[featuresIDs;1];
                end
                if strcmp(varargin{kk+1}{i},'Average')
                    featuresIDs=[featuresIDs;2];
                end
                if strcmp(varargin{kk+1}{i},'STD')
                    featuresIDs=[featuresIDs;3];
                end
                if strcmp(varargin{kk+1}{i},'WaveFormLength')
                    featuresIDs=[featuresIDs;4];
                end
                if strcmp(varargin{kk+1}{i},'ZeroCrossings')
                    featuresIDs=[featuresIDs;5];
                end
                if strcmp(varargin{kk+1}{i},'SlopeChanges')
                    featuresIDs=[featuresIDs;6];
                end
            end
         end
         if strcmp(varargin{kk},'ExcludeTrials')
            trialsForExclusion=varargin{kk+1};
         end
         if strcmp(varargin{kk},'numberofTimeWindows')
            nbTw=varargin{kk+1};
         end
     end
end


% aRMS=zeros(length(ClasseIDs)*length(sData.grasp{1}.trial),nbTw);
% aAver=zeros(length(ClasseIDs)*length(sData.grasp{1}.trial),nbTw);
% aSlop=zeros(length(ClasseIDs)*length(sData.grasp{1}.trial),nbTw);

aRMS=struct([]);
aAver=struct([]);
aSlop=struct([]);

outp=struct([]);

counter=1;

for grsp=1:length(ClasseIDs)
    grsp
    
    trialCounter=1;
    for i=1:length(sData.grasp{ClasseIDs(grsp)}.trial)
       
        if isempty(trialsForExclusion)
            
            
            motionOnset=sData.grasp{ClasseIDs(grsp)}.trial{i}.firstSample;
        
            outp{grsp}{trialCounter}=createTW(motionOnset,sData.grasp{ClasseIDs(grsp)}.trial{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,extFeatures,featuresIDs);

            for fk=1:nbTw
                for j=1:length(MuscleSet)
                    aRMS{j}(counter,fk)=outp{grsp}{trialCounter}{fk}(j);
                    aAver{j}(counter,fk)=outp{grsp}{trialCounter}{fk}(j+length(MuscleSet));
                    aSlop{j}(counter,fk)=outp{grsp}{trialCounter}{fk}(j+length(MuscleSet)*3);
                end
            end
            counter=counter+1;
            trialCounter=trialCounter+1;
        else
            
            if ~ismember(i,trialsForExclusion)
                motionOnset=sData.grasp{ClasseIDs(grsp)}.trial{i}.firstSample;

                outp{grsp}{trialCounter}=createTW(motionOnset,sData.grasp{ClasseIDs(grsp)}.trial{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,extFeatures,featuresIDs);
                
                for fk=1:nbTw
                    for j=1:length(MuscleSet)
                        aRMS{j}(counter,fk)=outp{grsp}{trialCounter}{fk}(j);
                        aAver{j}(counter,fk)=outp{grsp}{trialCounter}{fk}(j+length(MuscleSet));
                        aSlop{j}(counter,fk)=outp{grsp}{trialCounter}{fk}(j+length(MuscleSet)*3);
                    end
                end
                counter=counter+1;
                trialCounter=trialCounter+1;
            end
            
        end
        
    end

end




end