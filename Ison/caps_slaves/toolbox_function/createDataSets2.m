function [Folders_1,AfterEndingTrials]=createDataSets2(SubjectData,ClasseIDs,nbTW,varargin)


Folders_1=struct([]);
% Folders_2=struct([]);

firstSample=150;
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
trialsForExclusion=[];
NormalizedTime=false;



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
         if strcmp(varargin{kk},'NormalizedTime')
            NormalizedTime=varargin{kk+1};
         end
         
         
     end
end

trialLengths=zeros(length(SubjectData.grasp{ClasseIDs(1)}.trial),length(ClasseIDs));

if NormalizedTime
   
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
    
end

outp=struct([]);

AfterEnding=struct([]);

for grsp=1:length(ClasseIDs)
    grsp
    
    trialCounter=1;
    for i=1:length(SubjectData.grasp{ClasseIDs(grsp)}.trial)
       
        if isempty(trialsForExclusion)
            
            
            if NormalizedTime
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

                outp{grsp}{trialCounter}=output; 
                trialCounter=trialCounter+1;
            else
            
            
               
                
                motionOnset=SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.firstSample;
                outp{grsp}{trialCounter}=createTW(motionOnset,SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,extFeatures,featuresIDs);
                
                
                motionOnset=SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.motionEnd;
                AfterEnding{grsp}{trialCounter}=createTW(motionOnset,SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,extFeatures,featuresIDs);
                
                
                trialCounter=trialCounter+1;
                
                
            end
        else
            
            if ~ismember(i,trialsForExclusion)
                if NormalizedTime
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

                    outp{grsp}{trialCounter}=output; 
                    trialCounter=trialCounter+1;
                else
                
                    motionOnset=SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.firstSample;

                    outp{grsp}{trialCounter}=createTW(motionOnset,SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,extFeatures,featuresIDs);

                    
                    motionOnset=SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.motionEnd;
                    AfterEnding{grsp}{trialCounter}=createTW(motionOnset,SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,extFeatures,featuresIDs);
                
                    
                    trialCounter=trialCounter+1;
                           
                end
            end
            
        end
        
    end

end

% trialsPerFolder=floor(length(outp{1})/nbCrossValidationFolders);
trialsPerFolder=ceil(length(outp{1})/nbCrossValidationFolders);

AfterEndingTrials=struct([]);

for Fnumber=1:nbCrossValidationFolders
    
%     ranT=randi([1 length(outp{1})],trialsPerFolder,1);

    ranT=0;

    if Fnumber==nbCrossValidationFolders
        ranT=1:length(outp{1});
    else
        ranT=random_numbers(length(outp{1}),trialsPerFolder,1);
    end
    trialCounter=1;
    trialCounter2=1;
    for i=1:length(ClasseIDs)
        dataFolder=outp{i}(ranT);
        
        dataFolder2=AfterEnding{i}(ranT);
%         ranT
        for kk=1:length(dataFolder)
            if extFeatures
                Folders_1{Fnumber}.data{trialCounter}=[];
%                 Folders_2{Fnumber}.data=[];
%                 Folders_1{Fnumber}.labels{trialCounter}{j}=i;
%                 Folders_2{Fnumber}.labels{trialCounter2}=i;
                AfterEndingTrials{Fnumber}.data{trialCounter}=[];
            end
            for j=1:nbTW
%                 [i kk j]
                if extFeatures
                    Folders_1{Fnumber}.data{trialCounter}=[Folders_1{Fnumber}.data{trialCounter};dataFolder{kk}{j}];
%                     Folders_2{Fnumber}.data=[Folders_2{Fnumber}.data;dataFolder{kk}{j}];
                    Folders_1{Fnumber}.labels{trialCounter}{j}=i;
%                     Folders_2{Fnumber}.labels{trialCounter2}=i;

                else
                    Folders_1{Fnumber}.data{trialCounter}{j}=dataFolder{kk}{j};
                    Folders_1{Fnumber}.labels{trialCounter}{j}=zeros(size(dataFolder{kk}{j},1),length(ClasseIDs));
                    Folders_1{Fnumber}.labels{trialCounter}{j}(:,i)=1;
%                     Folders_2{Fnumber}.data{trialCounter2}=dataFolder{kk}{j};
%                     Folders_2{Fnumber}.labels{trialCounter2}=zeros(size(dataFolder{kk}{j},1),length(ClasseIDs));
%                     Folders_2{Fnumber}.labels{trialCounter2}(:,i)=1;
                end
                trialCounter2=trialCounter2+1;
            end
            
             for j=1:16
%                 [i kk j]
                if extFeatures
                
                    AfterEndingTrials{Fnumber}.data{trialCounter}=[AfterEndingTrials{Fnumber}.data{trialCounter};dataFolder2{kk}{j}];
                    
                else

                    AfterEndingTrials{Fnumber}.data{trialCounter}{j}=dataFolder2{kk}{j};
                    AfterEndingTrials{Fnumber}.labels{trialCounter}{j}=zeros(size(dataFolder{kk}{j},1),length(ClasseIDs));
                    AfterEndingTrials{Fnumber}.labels{trialCounter}{j}(:,i)=1;
                    
                    


                end
                trialCounter2=trialCounter2+1;
            end
            
            trialCounter=trialCounter+1;
        end
        
        outp{i}(ranT)=[];
        AfterEnding{i}(ranT)=[];

    end
    
end


end





