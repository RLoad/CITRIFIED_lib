

function [dataFolder1,dataFolder2,dataFolder3,FdataFolder1,FdataFolder2,FdataFolder3,mvc]=createDataSetsOn(SubjectData,ClasseIDs,sbjID,varargin)


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
velThreshold=0.1;


nbCrossValidationFolders=3;
normaLize=false;
mvc=calcMVC(SubjectData,ClasseIDs);
rectiFy=true;
extFeatures=false;
featuresIDs=[];


trialsForExclusion=struct([]);

% for able-bodied subject 1
trialsForExclusion{1}{1}=[];
trialsForExclusion{1}{2}=[];
trialsForExclusion{1}{3}=[];
trialsForExclusion{1}{4}=[];
trialsForExclusion{1}{5}=[];
trialsForExclusion{1}{6}=[];





%%

NormalizedTime=false;


% cut-off frequency of the low-pass filter for the elbow joint angle
cutoff_LP=50; % Hz

% order of the low-pass filter for the elbow joint angle
order_LP=2;

% cut-off frequency of the low-pass filter for the angular velocity of
% the elbow joint 
velLPCutOffFreq=5; % Hz



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


data1=struct([]);
data2=struct([]);
data3=struct([]);

Fdata1=struct([]);
Fdata2=struct([]);
Fdata3=struct([]);

dataFolder1=struct([]);
dataFolder2=struct([]);
dataFolder3=struct([]);

FdataFolder1=struct([]);
FdataFolder2=struct([]);
FdataFolder3=struct([]);


trialsPerFolder=floor(length(SubjectData.grasp{ClasseIDs(1)}.trial)/nbCrossValidationFolders);
% trialsPerFolder=ceil(length(SubjectData.grasp{ClasseIDs(1)}.trial)/nbCrossValidationFolders);

for Fnumber=1:nbCrossValidationFolders

    ranT=0;
    
   
    trialCounter=1;
    
    
    for grsp=1:length(ClasseIDs)
        grsp
        
        
       
        
        
        ranT=random_numbers(length(SubjectData.grasp{ClasseIDs(grsp)}.trial),trialsPerFolder,1);
        
        if ~isempty(trialsForExclusion{sbjID}{ClasseIDs(grsp)})
            
            
            while sum(ismember(ranT,trialsForExclusion{sbjID}{ClasseIDs(grsp)}))~=0
                ranT=random_numbers(length(SubjectData.grasp{ClasseIDs(grsp)}.trial),trialsPerFolder,1);
            end

            for trl=1:length(trialsForExclusion{sbjID}{ClasseIDs(grsp)})
                trialsForExclusion{sbjID}{ClasseIDs(grsp)}(trl)=trialsForExclusion{sbjID}{ClasseIDs(grsp)}(trl)-length(find(ranT<trialsForExclusion{sbjID}{ClasseIDs(grsp)}(trl)));
            end
        end

        
        
        tmpFolder=SubjectData.grasp{ClasseIDs(grsp)}.trial(ranT);


        for i=1:length(tmpFolder)

            if tmpFolder{i}.motionOnset~=0

                
                 if grsp==1||2
                     
                    motionOnset=1000;
                    motionEnd=3000;
                    maxPoint=2000;
                    
                 else
                     

                    [angVel,filtGonio]=preprocGonio(tmpFolder{i}.gonio,SR,cutoff_LP,order_LP,velLPCutOffFreq,order_LP);

                    [~,maxPoint]=max(abs(angVel(370:end)));

                    maxPoint=maxPoint+370;

                    if maxPoint<=0
                        disp('error')
                        countErrors=countErrors+1;
                    end

                    [motionOnset,motionEnd]=findMotionLimits(angVel,SR,lengthTW,overlap,0.370,velThreshold);
                
                 end
                

                data1{grsp}{trialCounter}=createTW2(motionOnset,maxPoint,tmpFolder{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,false,featuresIDs);
                
                Fdata1{grsp}{trialCounter}=createTW2(motionOnset,maxPoint,tmpFolder{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,true,featuresIDs);

                data2{grsp}{trialCounter}=createTW2(maxPoint,motionEnd,tmpFolder{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,false,featuresIDs);
                
                Fdata2{grsp}{trialCounter}=createTW2(maxPoint,motionEnd,tmpFolder{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,true,featuresIDs);


                data3{grsp}{trialCounter}=createTW2(motionEnd,min([motionEnd+1000,length(tmpFolder{i}.emg)]),tmpFolder{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,false,featuresIDs);

                Fdata3{grsp}{trialCounter}=createTW2(motionEnd,min([motionEnd+1000,length(tmpFolder{i}.emg)]),tmpFolder{i}.emg,lengthTW,SR,MuscleSet,overlap,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc,true,featuresIDs);

                

                FdataFolder1{Fnumber}.data{trialCounter}=[];
                FdataFolder2{Fnumber}.data{trialCounter}=[];
                FdataFolder3{Fnumber}.data{trialCounter}=[];





                for j=1:length(data1{grsp}{trialCounter})




                        FdataFolder1{Fnumber}.data{trialCounter}=[FdataFolder1{Fnumber}.data{trialCounter};Fdata1{grsp}{trialCounter}{j}];

                        FdataFolder1{Fnumber}.labels{trialCounter}{j}=grsp;



                        dataFolder1{Fnumber}.data{trialCounter}{j}=data1{grsp}{trialCounter}{j};
                        dataFolder1{Fnumber}.labels{trialCounter}{j}=zeros(size(data1{grsp}{trialCounter}{j},1),length(ClasseIDs));
                        dataFolder1{Fnumber}.labels{trialCounter}{j}(:,grsp)=1;



                end

                for j=1:length(data2{grsp}{trialCounter})



                        FdataFolder2{Fnumber}.data{trialCounter}=[FdataFolder2{Fnumber}.data{trialCounter};Fdata2{grsp}{trialCounter}{j}];

                        FdataFolder2{Fnumber}.labels{trialCounter}{j}=grsp;


                        dataFolder2{Fnumber}.data{trialCounter}{j}=data2{grsp}{trialCounter}{j};
                        dataFolder2{Fnumber}.labels{trialCounter}{j}=zeros(size(data2{grsp}{trialCounter}{j},1),length(ClasseIDs));
                        dataFolder2{Fnumber}.labels{trialCounter}{j}(:,grsp)=1;



                end




                for j=1:length(data3{grsp}{trialCounter})



                        FdataFolder3{Fnumber}.data{trialCounter}=[FdataFolder3{Fnumber}.data{trialCounter};Fdata3{grsp}{trialCounter}{j}];

                        FdataFolder3{Fnumber}.labels{trialCounter}{j}=grsp;



                        dataFolder3{Fnumber}.data{trialCounter}{j}=data3{grsp}{trialCounter}{j};
                        dataFolder3{Fnumber}.labels{trialCounter}{j}=zeros(size(data3{grsp}{trialCounter}{j},1),length(ClasseIDs));
                        dataFolder3{Fnumber}.labels{trialCounter}{j}(:,grsp)=1;



                end

                trialCounter=trialCounter+1;


            end


        end

        SubjectData.grasp{ClasseIDs(grsp)}.trial(ranT)=[];

    end




end



end





