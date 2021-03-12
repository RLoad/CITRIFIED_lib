function [ output_args ] = cut_data_by_hand_2( getxX , EMG )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
    time_begin=getxX(1);
    time_end=getxX(2);
    
    idEMG= EMG(:,1)<time_begin | EMG(:,1)> time_end;
    EMG(idEMG,:)=[];
output_args=EMG;
end

