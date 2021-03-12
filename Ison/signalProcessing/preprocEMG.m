
function [EMG_pp]=preprocEMG(data,sr,B_H,A_H,B_L1,A_L1,B_L2,A_L2,normaLize,rectiFy,mvc,twLength,plotTrue)


% Function for preprocessing the signals (filtering, rectification, 
% normalization)
%
%
% Input arguments:
%      
%   data:       a vector or matrix which contains the signal(s). In the
%               case of a matrix, the signals should be organized 
%               column-wise, meaning that each column should corespond to a
%               channel
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

data_new=data;

if plotTrue
    figure(20)
    subplot(2,3,1)
    if size(data,2) > 1
        plot(data(:,3))
    else
        plot(data)
    end
    title('original')
    
    subplot(2,3,2)
    if size(data,2) > 1
        plot(data(round(twLength*sr)+1:end,3))
    else
        plot(data(round(twLength*sr/1000)+1:end))
    end
    title('part interested in')
end

%% Band pass filtering

% High pass


data_h=filtfilt(B_H,A_H,data_new);       

data_hl=filter(B_L1,A_L1,data_h);     

if plotTrue
    figure(20)
    subplot(2,3,3)
    if size(data,2) > 1
        plot(data_hl(:,3))
    else
        plot(data_hl)
    end
    title('band-pass')
end

 
%% Rectification

if rectiFy
    data_rett=abs(data_hl);
else
    data_rett=data_hl;
end

if plotTrue
    figure(20)
    subplot(2,3,4)
    if size(data,2) > 1
        plot(data_rett(:,3))
    else
        plot(data_rett)
    end
    title('rectified')
end



%% Low pass filtering (for creating linear envelope)

if B_L2 ~= 0
    EMG_pp=filter(B_L2,A_L2,data_rett);

    if plotTrue
        figure(20)
        subplot(2,3,5)
        if size(data,2) > 1
            plot(EMG_pp(:,3))
        else
            plot(EMG_pp)
        end
        title('low-pass')
    end

else
    EMG_pp = data_rett;
end


%% Normalization

if normaLize
    for i=1:size(EMG_pp,2)
        EMG_pp(:,i)=EMG_pp(:,i)/mvc(i);
    end
end

EMG_pp=EMG_pp(round(twLength*sr/1000)+1:end,:);

if plotTrue
    figure(20)
    subplot(2,3,6)
    if size(data,2) > 1
        plot(EMG_pp(:,3))
    else
        plot(EMG_pp)
    end
    title('returned signal')
end



end

