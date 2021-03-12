% this function filters and rectifies signals


function [EMG_pp]=preprocessSignals(data,sr,BandPass_F,LowPass_F,normaLize,rectiFy,mvc)


% Input arguments:
%      
%   data:       a vector or matrix which contains the signal(s). In the
%               case of a matrix, the signals should be organized 
%               column-wise, meaning that each column should corespond to a
%               signal
%
%   sr:         sampling rate
%
%   BandPass_F: a vector of two elements that correspond to the cut-off
%               frequencies of the bandpass filter (the first element 
%               should correspond to the lower frequency while the second 
%               element shold correspond to the highest frequency)
%   
%   LowPass_F:  the cut-off frequency of the lowpass filter
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


% High pass frequency
cof_h=BandPass_F(1); 
cof=BandPass_F(2);

%Low pass frequency
cof_l=LowPass_F; 


%% DeTrend
data_new=detrend(data,'constant');

%% Band pass filtering

% High pass

Wn=(cof_h*2)./sr;
if Wn>1.0
    Wn=0.99;
end

[B,A] = butter(7,Wn,'high'); %Butterworth 7th order
data_h=filtfilt(B,A,data_new);       

Wn=(cof*2)./sr;
if Wn>1.0
    Wn=0.99;
end


[B,A] = butter(7,Wn,'low'); %Butterworth 7th order
data_hl=filter(B,A,data_h);       

 
%% Rectification

if rectiFy
    data_rett=abs(data_hl);
else
    data_rett=data_hl;
end



%% Low pass filtering
cof=cof_l;
Wn=(cof*2)/sr;
if Wn>1.0
    Wn=0.99;
end


[B,A] = butter(7,Wn); %Butterworth 7th order

EMG_pp=filter(B,A,data_rett);


%% Normalization

if normaLize
    for i=1:size(EMG_pp,2)
        EMG_pp(:,i)=EMG_pp(:,i)/mvc(i);
    end
end

end

