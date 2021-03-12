function [folders]=createDataSetsNormTime(SubjectData,ClasseIDs,varargin)



lengthTW=0.150;
overlap=0.100;
SR=1000;
MuscleSet=1:size(SubjectData.grasp{1}.trial{1}.emg,2);
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
mvc=calcMVC(SubjectData,ClasseIDs);
rectiFy=true;
extFeatures=false;
featuresIDs=[];

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
         if strcmp(varargin{kk},'NumberOfCrossValidationFolders')
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
     end
end


% find the smallest number of samples among all the trials in order to
% resample according to tis number


trialLengths=zeros(length(SubjectData.grasp{ClasseIDs(1)}.trial),length(ClasseIDs));


for i=1:length(ClasseIDs)
    
    for j=1:length(SubjectData.grasp{ClasseIDs(i)}.trial)
        trialLengths(j,i)=(SubjectData.grasp{ClasseIDs(i)}.trial{j}.motionEnd-SubjectData.grasp{ClasseIDs(i)}.trial{j}.motionOnset);
    end
end

disp('average and standard deviation of the task completion times of each grasp type:')
disp(mean(trialLengths)/SR)
disp(std(trialLengths)/SR)
vecTrialLength=reshape(trialLengths,[1,size(trialLengths,1)*size(trialLengths,2)]);
disp('average and standard deviation of the task completion times among all grasp types:')
disp([num2str(mean(vecTrialLength)/SR) '+-' num2str(std(vecTrialLength)/SR)])
nbSamples=min(vecTrialLength);
disp(['nimimum time: ' num2str(nbSamples/SR)])

outp=struct([]);

for grsp=1:length(ClasseIDs)
    grsp
    for i=1:length(SubjectData.grasp{ClasseIDs(grsp)}.trial)
    
        
        Signal=preprocessSignals(SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.emg,SR,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc);
        
        reSignal=resample(Signal(SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.motionOnset:SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.motionEnd,:),SR,trialLengths(i,grsp));
        
        l_TW=lengthTW*SR;
        delay_TW=l_TW-overlap*SR;
        countTW=1;
        
        output=struct([]);

        for j=1:delay_TW:length(reSignal)

            if j+l_TW>length(reSignal)
                if extFeatures
                    output{countTW}=exctractFeatures(reSignal(j:end,MuscleSet),featuresIDs);
                else
                    output{countTW}=reSignal(j:end,MuscleSet);
                end
            else
                if extFeatures
                    output{countTW}=exctractFeatures(reSignal(j:j+l_TW,MuscleSet),featuresIDs);
                else
                    output{countTW}=reSignal(j:j+l_TW,MuscleSet);
                end
            end

            countTW=countTW+1;
        end

        outp{grsp}{i}=output;
               
        
    end

end

trialsPerFolder=floor(length(outp{1})/nbCrossValidationFolders);

nbTW=length(outp{1}{1})-3;
for Fnumber=1:nbCrossValidationFolders
   
%     ranT=randi([1 length(outp{1})],trialsPerFolder,1);

    ranT=0;

    if Fnumber==nbCrossValidationFolders
        ranT=1:trialsPerFolder;
    else
        ranT=random_numbers(length(outp{1}),trialsPerFolder,1);
    end
    trialCounter=1;
    trialCounter2=1;
    for i=1:length(ClasseIDs)
        dataFolder=outp{i}(ranT);
%         ranT
        for kk=1:length(dataFolder)
            if extFeatures
                Folders_1{Fnumber}.data{trialCounter}=[];
                Folders_2{Fnumber}.data=[];

            end
            for j=1:nbTW
%                 [i kk j]
                if extFeatures
                    Folders_1{Fnumber}.data{trialCounter}=[Folders_1{Fnumber}.data{trialCounter};dataFolder{kk}{j}];
                    
                    Folders_1{Fnumber}.labels{trialCounter}{j}=i;
                   
                else
                    Folders_1{Fnumber}.data{trialCounter}{j}=dataFolder{kk}{j};
                    Folders_1{Fnumber}.labels{trialCounter}{j}=zeros(size(dataFolder{kk}{j},1),length(ClasseIDs));
                    Folders_1{Fnumber}.labels{trialCounter}{j}(:,i)=1;
                    
                end
                trialCounter2=trialCounter2+1;
            end
            trialCounter=trialCounter+1;
        end
        
        outp{i}(ranT)=[];

    end
    
end

folders=Folders_1;


end