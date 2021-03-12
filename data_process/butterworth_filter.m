    function [ output_args ] = butterworth_filter(filter_kind,plot_switch,n_of_butt, input_args , frs, cutoff, high_cutoff)
%BUTTERWORTH_FILTER Summary of this function goes here
% 1.set the filter kind, 0 is low pass, other is band pass,
% 2.decide the n of butt,4 or 3 is ok
% 3.frs is need to calcute the time
% 4.if you are the low pass, only cutoff is need, for band pass, cutoff and high_cutoff are both needed

% NOTICE only can filter one row data

%   Detailed explanation goes here

s=input_args;
Length_of_data=length(s);
number_serial_of_data=0:Length_of_data-1;
time_serial_of_data=number_serial_of_data/frs;

    if filter_kind == 0% 0 is ditong
       
        sfft=fft(s);
        

        if 0
        Wp=cutoff/frs;Ws=high_cutoff/frs;                %cutoff 1Hz,stop_band cut off 2Hz
        %estimate the Butterworth N and 3dB cutoff frequence Wn
        [n,Wn]=buttord(Wp,Ws,1,50);     %Stop-band attenuation is greater than 50db and pass-band ripple is less than 1db.
        else
        n=n_of_butt;
        Wn=cutoff/(frs/2);%directly give cut off
        end
        %Butterworth
        [a,b]=butter(n,Wn);
        [h,f]=freqz(a,b,'whole',frs);      
        
        f=(0:length(f)-1*frs/length(f));   
        
%         sF=filter(a,b,s);                   %filter
        sF=filtfilt(a,b,s);                   %filter which has zero phase move
        
        
        SF=fft(sF);
        
        if plot_switch==1
             figure
            set(gcf,'outerposition',get(0,'screensize'));
            subplot(6,2,[2 4 6]);plot(time_serial_of_data,s);
            title('input signal');xlabel('t/s');ylabel('amplitude');
            subplot(6,2,[1 3]);
            plot((1:length(sfft)/2)*frs/length(sfft),2*abs(sfft(1:length(sfft)/2))/length(sfft));
            title('signal spectrum');xlabel('Hz');ylabel('amplitude');
            subplot(6,2,[5 7])
            plot(f(1:length(f)/2),abs(h(1:length(f)/2)));       %Draw amplitude-frequency response diagram
            title('Butterworth low pass filter');xlabel('Frequency/Hz');ylabel('Amplitude');
            grid;
            subplot(6,2,[8 10 12])
            plot(time_serial_of_data,sF);                         
            title('out put signal');xlabel('t/s');ylabel('Amplitude');
            subplot(6,2,[9 11])
            plot((1:length(SF)/2)*frs/length(SF),2*abs(SF(1:length(SF)/2))/length(SF));
            title('Low-pass filtered spectrum');xlabel('Frequency/Hz');ylabel('Amplitude');
        else
            
        end
    
        
    else    %else is daitong
        
        sfft=fft(s);
        

        n=n_of_butt;
        Wn=[cutoff/(frs/2) high_cutoff/(frs/2)];   %low and high cut off 

        %Butterworth
        [a,b]=butter(n,Wn);
        [h,f]=freqz(a,b,'whole',frs);       
        f=(0:length(f)-1*frs/length(f));   
        
%         sF=filter(a,b,s);                   %filter
        sF=filtfilt(a,b,s);                   %filter which has zero phase move
        
        
        SF=fft(sF);
        
        if plot_switch==1
            figure
            set(gcf,'outerposition',get(0,'screensize'));
            subplot(6,2,[2 4 6]);plot(time_serial_of_data,s);
            title('input signal');xlabel('t/s');ylabel('amplitude');
            subplot(6,2,[1 3]);
            plot((1:length(sfft)/2)*frs/length(sfft),2*abs(sfft(1:length(sfft)/2))/length(sfft));
            title('signal spectrum');xlabel('Hz');ylabel('amplitude');
            subplot(6,2,[5 7])
            plot(f(1:length(f)/2),abs(h(1:length(f)/2)));       %Draw amplitude-frequency response diagram
            title('Butterworth band pass filter');xlabel('Frequency/Hz');ylabel('Amplitude');
            grid;
            subplot(6,2,[8 10 12])
            plot(time_serial_of_data,sF);                         
            title('out put signal');xlabel('t/s');ylabel('Amplitude');
            subplot(6,2,[9 11])
            plot((1:length(SF)/2)*frs/length(SF),2*abs(SF(1:length(SF)/2))/length(SF));
            title('Band-pass filtered spectrum');xlabel('Frequency/Hz');ylabel('Amplitude');
        else
            
        end
        
    end

    

    output_args=sF;

    end

