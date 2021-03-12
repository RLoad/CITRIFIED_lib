% this function filters and rectifies signals


function [EMG_pp]=OnlinePreprocEMG(data,sr,B_H,A_H,B_L1,A_L1,B_L2,A_L2,normaLize,rectiFy,mvc,twLength)


% Input arguments:
%      
%   data:       a vector or matrix which contains the signal(s). In the
%               case of a matrix, the signals should be organized 
%               column-wise, meaning that each column should corespond to a
%               signal
%
%   sr:         sampling rate
%
%   B_H,A_H:    
%   B_L1,A_L1:  The transfer function coefficients for the bandpass filter
%   
%   B_L2,A_L2:  The transfer function coefficients for the low-pass filter
%
%   normaLize:  a boolian variable to control if the data should be
%               normalized or not. (True: normalize, False: not normalize)
%
%   rectiFy:    a boolian variable to control if the data should be
%               rectified or not. (True: rectify, False: not rectify)
%
%   mvc:        a vector containing the Maximum Volunteer Contraction value
%               for each muscle
%
%
%   Output argument:
%
%   EMG_pp:     the processed signals, organized collumn-wise





%% DeTrend
data_new=detrend(data,'constant');

%% Band pass filtering

% High pass


data_h=filtfilt(B_H,A_H,data_new);       

data_hl=filter(B_L1,A_L1,data_h);       

 
%% Rectification

if rectiFy
    data_rett=abs(data_hl);
else
    data_rett=data_hl;
end



%% Low pass filtering (for creating linear envelope)

EMG_pp=filter(B_L2,A_L2,data_rett);


%% Normalization

if normaLize
    for i=1:size(EMG_pp,2)
        EMG_pp(:,i)=EMG_pp(:,i)/mvc(i);
    end
end

EMG_pp=EMG_pp(round(twLength*sr)+1:end,:);



end

