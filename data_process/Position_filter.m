function [ NDI ] = Position_filter(NDI,FilterOrNot,filter_kind,low_cut_off,high_cut_off,plot_filter )
%POSITION_FILTER 此处显示有关此函数的摘要
%   此处显示详细说明
%    filter_kind 0 low pass,1 band pass
%    plot_filter=0; 
Position_origh=NDI;

if FilterOrNot==1
    !echo Position is filtering!
    % calculate the fs
    fs=round((length(NDI(:,1))-1)/(NDI(end,1)-NDI(1,1)));%Hz
    %for directly filter, the data should begin form zero
    NDI(:,2:4)=NDI(:,2:4)-NDI(1,2:4);
    %before filtering
    if filter_kind==0
        NDI(:,2)=butterworth_filter(filter_kind,plot_filter,3,NDI(:,2),fs,high_cut_off);
        NDI(:,3)=butterworth_filter(filter_kind,plot_filter,3,NDI(:,3),fs,high_cut_off);
        NDI(:,4)=butterworth_filter(filter_kind,plot_filter,3,NDI(:,4),fs,high_cut_off);
    elseif filter_kind==1
        NDI(:,2)=butterworth_filter(filter_kind,plot_filter,3,NDI(:,2),fs,low_cut_off,high_cut_off);
        NDI(:,3)=butterworth_filter(filter_kind,plot_filter,3,NDI(:,3),fs,low_cut_off,high_cut_off);
        NDI(:,4)=butterworth_filter(filter_kind,plot_filter,3,NDI(:,4),fs,low_cut_off,high_cut_off);
    end
        
    NDI=NDI(:,:)+Position_origh(1,:);% cause the position data not like Force_robot begin from 0, so we add them orign value for real position in world
    
    figure
    subplot(311)
    plot(NDI(:,1),NDI(:,2),'b-',Position_origh(:,1),Position_origh(:,2),'r-')
    legend('after filter','before filter'); 
    subplot(312)
    plot(NDI(:,1),NDI(:,3),'b-',Position_origh(:,1),Position_origh(:,3),'r-')
    legend('after filter','before filter'); 
    subplot(313)
    plot(NDI(:,1),NDI(:,4),'b-',Position_origh(:,1),Position_origh(:,4),'r-')
    legend('after filter','before filter'); 
    
    clear Position_robot
else
    !echo Position not filtering!
end

end

