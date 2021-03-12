function [ P16, raw_EMG_flitered] = EMG_process_9ch( approximatetime_data_EMG )
%UNTITLED �˴���ʾ�йش˺����ժҪ
%   �˴���ʾ��ϸ˵��
pt=[approximatetime_data_EMG(:,2)-mean(approximatetime_data_EMG(:,2))...
    approximatetime_data_EMG(:,3)-mean(approximatetime_data_EMG(:,3))...
    approximatetime_data_EMG(:,4)-mean(approximatetime_data_EMG(:,4))...
    approximatetime_data_EMG(:,5)-mean(approximatetime_data_EMG(:,5))...
    approximatetime_data_EMG(:,6)-mean(approximatetime_data_EMG(:,6))...
    approximatetime_data_EMG(:,7)-mean(approximatetime_data_EMG(:,7))...
    approximatetime_data_EMG(:,8)-mean(approximatetime_data_EMG(:,8))...
    approximatetime_data_EMG(:,9)-mean(approximatetime_data_EMG(:,9))...
    approximatetime_data_EMG(:,10)-mean(approximatetime_data_EMG(:,10))];

time = approximatetime_data_EMG(:,1);
for chanl = 1:(length(approximatetime_data_EMG(1,:))-1)
    ch1=pt(:,chanl);
    % define sampling rate (acquisition frequency)
    SR = 1000;

    % define a time window for extracting the features
    tw = 100; % ms

    % let's use only a band-pass filter on the EMG signals
    % define a small time-window as a buffer for the filters to converge
    s_buffer = 30; % ms

    % cut-off frequencies of the band-pass filter 
    bandPassCuttOffFreq=[50,400]; % Hz
    % bandPassCuttOffFreq=[1,8]; % Hz

    % the order of the filter
    filt_order = 4;

    % let's extract 3 features from the time-window: mean-average, its standard
    % deviation and the number of zero-crossings

    % define the feature vector (check the documentation of the function
    % "exctractFeatures")
    featuresIDs = [0, 1, 0, 1, 0, 1, 0];

    % find the actual number of samples that correspond to the time-window and
    % the buffer
    tw_samples = tw * SR / 1000;

    buffer_samples = s_buffer * SR / 1000;

    % compute the filter coefficients for the band-pass butterworth filter

    Wn=(bandPassCuttOffFreq(1)*2)/SR;

    [B_H, A_H] = butter(filt_order, Wn, 'high'); 

    Wn=(bandPassCuttOffFreq(2)*2)/SR;

    [B_L, A_L] = butter(filt_order, Wn, 'low'); 

    % pre-process the data

    resultedSignal = [];
    tw_features = [];
    tw_labels = [];
    buffer = [];
    
    %%%%%%%%%%%%% for matlab offline %%%%%%%%%%%
    filteredSignal_new = preprocEMG(ch1,SR, B_H, A_H, B_L, A_L, 0, 0, false, false, [], 0 , false);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%% for real time %%%%%%%%%%%%%%%%%%
    for i=1:tw_samples:length(ch1)
        if i+tw < length(ch1)
            tWindow = ch1(i:i+tw_samples - 1 );
    %         tLabels = newLabels(i:i+tw_samples - 1);
        else
            tWindow = ch1(i:end); % end 
    %         tLabels = newLabels(i:end);
        end

        if i ~= 1
            tWindow = [buffer;tWindow];
        end
        if i+tw < length(ch1)
            buffer = tWindow(end - buffer_samples +1 :end);
        end
        if i==1
            filteredSignal = preprocEMG(tWindow,SR, B_H, A_H, B_L, A_L, 0, 0, false, false, [], 0 , false);
        else
            filteredSignal = preprocEMG(tWindow,SR, B_H, A_H, B_L, A_L, 0, 0, false, false, [], s_buffer , false);
        end
        resultedSignal = [resultedSignal; filteredSignal];

%         tw_features = [tw_features; exctractFeatures(filteredSignal, featuresIDs)];

    %     tw_labels = [tw_labels;round(mean(tLabels))];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     %%%%%%%%%%%%%%  plot
%     % inspect the data
%     figure()
%     plot(time, ch1)
%     hold on
%     plot(time, resultedSignal)
%     plot(time, filteredSignal_new)
%     % plot(time, newLabels*1000)
%     legend('original signal', 'filtered signal', 'new filtered signal')
%     %%%%%%%%%%%%%%  plot
    
    pt(:,chanl)=filteredSignal_new;
    
end
raw_EMG_flitered=[approximatetime_data_EMG(:,1) pt];

%% my way

k1=1;k2=length(approximatetime_data_EMG(:,3));
for i=k1:k2
    j=i-k1+1;
    Pa(j,1)=pt(i,1);
    Pb(j,1)=pt(i,2);
    Pc(j,1)=pt(i,3);
    Pd(j,1)=pt(i,4);
    Pe(j,1)=pt(i,5);
    Pf(j,1)=pt(i,6);
    Pg(j,1)=pt(i,7);
    Ph(j,1)=pt(i,8);
    Pi(j,1)=pt(i,9);
end
fs=1000;              %����Ƶ��  
N=100;                %���ڳ��� 
L=length(Pa); 
n=0:L-1;              
t=n/fs;             %ʱ��
a=mod(L,N);
for j=0:N:L-a
     if j==L-a
       for i=1:a
       ma(i)=abs(Pa(i+j));
       mb(i)=abs(Pb(i+j));
       mc(i)=abs(Pc(i+j));
       md(i)=abs(Pd(i+j));
       me(i)=abs(Pe(i+j));
       mf(i)=abs(Pf(i+j));
       mg(i)=abs(Pg(i+j));
       mh(i)=abs(Ph(i+j));
       mi(i)=abs(Pi(i+j));
       end
       for i=1:a
        P1(i+j)=sum(ma)/N;
        P2(i+j)=sum(mb)/N;
        P3(i+j)=sum(mc)/N;
        P4(i+j)=sum(md)/N;
        P5(i+j)=sum(me)/N;
        P6(i+j)=sum(mf)/N;
        P7(i+j)=sum(mg)/N;
        P8(i+j)=sum(mh)/N;
        P9(i+j)=sum(mi)/N;
       end 
    else
for i=1:N
ma(i)=abs(Pa(i+j));
mb(i)=abs(Pb(i+j));
mc(i)=abs(Pc(i+j));
md(i)=abs(Pd(i+j));
me(i)=abs(Pe(i+j));
mf(i)=abs(Pf(i+j));
mg(i)=abs(Pg(i+j));
mh(i)=abs(Ph(i+j));
mi(i)=abs(Pi(i+j));
end
for i=1:N
P1(i+j)=sum(ma)/N;
P2(i+j)=sum(mb)/N;
P3(i+j)=sum(mc)/N;
P4(i+j)=sum(md)/N;
P5(i+j)=sum(me)/N;
P6(i+j)=sum(mf)/N;
P7(i+j)=sum(mg)/N;
P8(i+j)=sum(mh)/N;
P9(i+j)=sum(mi)/N;
end
    end
end
P1=P1';
P2=P2';
P3=P3';
P4=P4';
P5=P5';
P6=P6';
P7=P7';
P8=P8';
P9=P9';

% plot(t,P(:,1));hold on;

% plot(t,P1(:,1));
% k1=5000;k2=10000;
% for i=k1:k2
%     j=i-k1+1;
%     Paa(j,1)=P1(i,1);
%     Pbb(j,1)=P2(i,1);
%     Pcc(j,1)=P3(i,1);
%     Pdd(j,1)=P4(i,1);
%     Pee(j,1)=P5(i,1);
%     Pff(j,1)=P6(i,1);
% end
% Paf=[Paa Pbb Pcc Pdd Pee Pff];
%  Pa_ave=mean(Paa);
%  Pb_ave=mean(Pbb);
%  Pc_ave=mean(Pcc);
%  Pd_ave=mean(Pdd);
%  Pe_ave=mean(Pee);
%  Pf_ave=mean(Pff);
 
 P1=smooth(P1,200);
  P2=smooth(P2,200);
   P3=smooth(P3,200);
    P4=smooth(P4,200);
     P6=smooth(P6,200);
      P5=smooth(P5,200);
      P7=smooth(P7,200);
      P8=smooth(P8,200);
      P9=smooth(P9,200);
      
 P16=[approximatetime_data_EMG(:,1) P1 P2 P3 P4 P5 P6 P7 P8 P9];
 
f=figure;a=plot_wr(f,1);
subplot(331);plot(approximatetime_data_EMG(:,1),pt(:,1),'b-');
        hold on;plot(P16(:,1),P16(:,2),'r-','linewidth',2);
subplot(332);plot(approximatetime_data_EMG(:,1),pt(:,2),'b-');
        hold on;plot(P16(:,1),P16(:,3),'r-','linewidth',2);
subplot(333);plot(approximatetime_data_EMG(:,1),pt(:,3),'b-');
        hold on;plot(P16(:,1),P16(:,4),'r-','linewidth',2);
subplot(334);plot(approximatetime_data_EMG(:,1),pt(:,4),'b-');
        hold on;plot(P16(:,1),P16(:,5),'r-','linewidth',2);
subplot(335);plot(approximatetime_data_EMG(:,1),pt(:,5),'b-');
        hold on;plot(P16(:,1),P16(:,6),'r-','linewidth',2);
subplot(336);plot(approximatetime_data_EMG(:,1),pt(:,6),'b-');
        hold on;plot(P16(:,1),P16(:,7),'r-','linewidth',2);
subplot(337);plot(approximatetime_data_EMG(:,1),pt(:,7),'b-');
        hold on;plot(P16(:,1),P16(:,8),'r-','linewidth',2);
subplot(338);plot(approximatetime_data_EMG(:,1),pt(:,8),'b-');
       hold on;plot(P16(:,1),P16(:,9),'r-','linewidth',2);
subplot(339);plot(approximatetime_data_EMG(:,1),pt(:,9),'b-');
        hold on;plot(P16(:,1),P16(:,10),'r-','linewidth',2);

end

