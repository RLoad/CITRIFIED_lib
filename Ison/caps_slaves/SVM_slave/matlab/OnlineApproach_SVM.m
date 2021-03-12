
% SLAVE_STATUS = 0;                         % variable not there!  stop PCE looping.
% SLAVE_MSG = [];
% % frame=FRAME_CNT;
% record=CAPS_FILE_RECORD_ON;
%PCEmex(7, 90, 'CLAS_OUT');
% addpath('C:\Users\ibatzianoulis\Documents\MATLAB\dd')
% addpath('C:\Users\ibatzianoulis\Documents\MATLAB\dd\CBM')
% addpath('C:\Users\ibatzianoulis\Documents\MATLAB\dd\CBM\toolbox_function')
% 
% addpath('C:\Users\ibatzianoulis\Documents\MATLAB\dd\ESN')
% addpath('C:\Users\ibatzianoulis\Documents\MATLAB\dd\ESN\Toolbox_ESN')

% PCEmex(7, 90, 'CLAS_OUT');
% SLAVE_MSG

% PCEmex(7, 90, 'SLAVE_MSG');
% PCEmex(7, 90, 'SLAVE_STATUS');
PCEmex(7, 90, 'CLAS_OUT')

% PCEmex(7, 90, 'CLAS_OUT')
% CLAS_OUT=[1,0,0,0,0,0,0,0];

SLAVE_MSG = '';
SLAVE_STATUS = 0;






try

    
    CLAS_OUT=[16,0,0,0,0,0,0,0];
    WIN=0;
    CONFIDENCE=0;
    TIMEWINDOW=0;
 

    frame_cnt=PCEmex(8, 'FRAME_CNT');

    if frame_cnt==0
    
        % which model to use:
        % 1 -> use data including the reaching motion
        % 2 -> use data without including the reaching motion
        
        typController=1;
    
        % classes correspondence
    
        cclasses=[16,16,18,21];%[1,16,18,21];
    
        % sample rate

        SR=1000;

        % time-window length in seconds

        twLength=0.150;
        

        % normalization of the EMG signals by the MVC
        
        normaLize=true;
        
        % rectifications of the EMG signals
        
        rectiFy=true;
        
        
        %% 
        
        % cut-off frequencies of the band-pass filter for the EMG signals
        
        bandPassCuttOffFreq=[50,400];
        
        % cut-off frequency of the low-pass filter for the EMG signals
        
        lowPassCutOffFreq=20;
        
        % order of the filter
        filter_order=7;
        
        % compute the transfer function coefficients for the EMG filtering
        
        Wn=(bandPassCuttOffFreq(1)*2)/SR;
                
        [B_H,A_H] = butter(filter_order,Wn,'high'); 
        
        
        Wn=(bandPassCuttOffFreq(2)*2)/SR;
        
        [B_L1,A_L1] = butter(filter_order,Wn,'low'); 
        
        Wn=(lowPassCutOffFreq*2)/SR;
        
        [B_L2,A_L2] = butter(filter_order,Wn); 
        
        
        %%
        
        % cut-off frequency of the low-pass filter for the elbow joint angle
        
        cutoff_LP=50; % Hz

        % order of the low-pass filter for the elbow joint angle
        
        order_LP=2;

        % cut-off frequency of the low-pass filter for the angular velocity of
        % the elbow joint 
        
        velLPCutOffFreq=5; % Hz
        
        % compute the transfer coefficients for the elbow joibt angle
        
        Wn=(cutoff_LP*2)/SR;

        [B_elbowJoint,A_elbowJoint] = butter(order_LP,Wn,'low');
        
        % compute the transfer coefficients for the elbow joibt angle
        
        Wn=(velLPCutOffFreq*2)/SR;

        [B_elbowVel,A_elbowVel] = butter(order_LP,Wn,'low');        
        
        

        %%

        % the thesholds for the confidence of the majority vote and the minimun
        % number of the time windows
        MV_Conf_Threshold=0.7;
        Least_TW=12;

        % counter of the time windows
        counter=1;

        % a vector to contain the classification outcome of all the time windows
        allTWOutputs=[];

        % number of channels
        nb_channels=12;

        % history of the goniometer to keep
        gonioHistory=zeros(round(SR*twLength),1);

        % history of the emg signals to keep
        emgHistory=zeros(round(SR*twLength),nb_channels);

        % time windows to take into account
        TWHistory=8;

    end


record=PCEmex(8,'CAPS_FILE_RECORD_ON');


%% classification for CAPS
% if record==1
dd=PCEmex(8,'DAQ_DATA');
ddFrame=PCEmex(8,'DAQ_FRAME');


% 
% cc=PCEmex(8,'CLAS_OUT');
% CLAS_OUT=cc;
% classify the emg signal

% scale the signals to +-5V

dd=double(dd')/(2^16 - 1)*10-5;


% filter emg signals

emgSignals=OnlinePreprocEMG([emgHistory;dd(:,1:nb_channels)],SR,B_H,A_H,B_L1,A_L1,B_L2,A_L2,normaLize,rectiFy,mvc,twLength);

emgHistory=dd(:,1:nb_channels);

% feature extraction
twFeatures=[];

for i=1:nb_channels
    twFeatures=[twFeatures,[rms(emgSignals(:,i)),waveformlength(emgSignals(:,i)),slopChanges(emgSignals(:,i),3)]];
end

twFeatures=twFeatures./maxValues;

% filter goniometer data
[angVel,filtGonio]=OnlinePreprocGonio([gonioHistory;dd(:,nb_channels+1)],SR,B_elbowJoint,A_elbowJoint,B_elbowVel,A_elbowVel,twLength);

gonioHistory=dd(:,nb_channels+1);



% classify emg signals

if typController==1
    [timeWindowOutput, ~, ~] = svmpredict(1, twFeatures, SVMmodelallmotion, ' -q');
else
    [timeWindowOutput, ~, ~] = svmpredict(1, twFeatures, SVMmodelonlylast, ' -q');    
end
   
disp(['tw output: ' num2str(timeWindowOutput)])


allTWOutputs=[allTWOutputs;timeWindowOutput];

if counter>Least_TW
    
    [winner,conf]=majorityVote(allTWOutputs(length(allTWOutputs)-TWHistory:end));
    disp(['winner class: ' num2str(winner)])
    WIN=winner;
    CONFIDENCE=conf;
    TIMEWINDOW=timeWindowOutput;
    
    if conf>=MV_Conf_Threshold
            tmpClass=zeros(1,8);
            tmpClass(1)=cclasses(winner);
            CLAS_OUT=tmpClass;
    end
    
    
end


counter=counter+1;

PCEmex(6, 90, 'WIN', WIN)
PCEmex(6, 90, 'CONFIDENCE', CONFIDENCE)
PCEmex(6, 90, 'TIMEWINDOW', TIMEWINDOW)

disp(['winner=' num2str(WIN)])
disp(['confidence=' num2str(CONFIDENCE)])


catch
    SLAVE_STATUS = 1;                             % variable not there!  stop PCE looping.
    SLAVE_MSG = 'Classification error';   % this will appear in the PCE log
end
