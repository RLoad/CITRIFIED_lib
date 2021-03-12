function [ output_x ] = cut_data_by_hand( f )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

    getxX = []; getxY = [];
    while 0<1
        [x,y,b] = ginput(1); 
        if isempty(b); 
            break;
        elseif b==91;
            ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);%
            axis([x-width/2 x+width/2 y-height/2 y+height/2]);%y-height/2 y+height/2
            zoom xon;
            zoom(1/2);
        elseif b==93;
            ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
            axis([x-width/2 x+width/2 y-height/2 y+height/2]);
            zoom xon;
            zoom(2);    
        else
            getxX=[getxX;x];
            getxY=[getxY;y];
        end;
    end
    [getxX getxY]

output_x=getxX;

end

