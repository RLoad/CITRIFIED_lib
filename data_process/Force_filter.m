function [ F ] = Force_filter(F,FilterOrNot,filter_kind,low_cut_off,high_cut_off,plot_filter )
%POSITION_FILTER 此处显示有关此函数的摘要
%   此处显示详细说明
%    filter_kind 0 low pass,1 band pass
%    plot_filter=0; 

Force_robot=F;
if FilterOrNot==1
     % calculate the fs 
    fs=round((length(F(:,1))-1)/(F(end,1)-F(1,1)));%Hz
    %for directly filter, the data should begin form zero
	F(:,2:4)=F(:,2:4)-F(1,2:4);
    !echo Force is filtering!
    if filter_kind==0
        F(:,2)=butterworth_filter(filter_kind,plot_filter,3,F(:,2),fs,high_cut_off);
        F(:,3)=butterworth_filter(filter_kind,plot_filter,3,F(:,3),fs,high_cut_off);
        F(:,4)=butterworth_filter(filter_kind,plot_filter,3,F(:,4),fs,high_cut_off);
    elseif filter_kind==1
        F(:,2)=butterworth_filter(filter_kind,plot_filter,3,F(:,2),fs,low_cut_off,high_cut_off);
        F(:,3)=butterworth_filter(filter_kind,plot_filter,3,F(:,3),fs,low_cut_off,high_cut_off);
        F(:,4)=butterworth_filter(filter_kind,plot_filter,3,F(:,4),fs,low_cut_off,high_cut_off);
    end
    figure
    subplot(311)
    plot(F(:,1),F(:,2),'b-',Force_robot(:,1),Force_robot(:,2),'r-')
    legend('after filter','before filter'); 
    subplot(312)
    plot(F(:,1),F(:,3),'b-',Force_robot(:,1),Force_robot(:,3),'r-')
    legend('after filter','before filter'); 
    subplot(313)
    plot(F(:,1),F(:,4),'b-',Force_robot(:,1),Force_robot(:,4),'r-')
    legend('after filter','before filter'); 
    
    
    clear Force_robot
else
    !echo Force not filtering!
end

end

