function  [task,exp_name,exp_time_good,exp_number,exp_number_good,color]=define_all_tissue_for_ESN_delet_short_data(exp_kind);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
color_list=jet(19);

    if exp_kind==1
        task='avocado';
        exp_name=['avocado_deep'];
        exp_time_good=[2:6];
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==2
        task='avocado';
        exp_name=['avocado_good'];
        exp_time_good=[1:8];
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==3
        task='banana';
        exp_name=['banana_deep'];
        exp_time_good=[2:5];
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==4
        task='banana';
        exp_name=['banana_good'];
        exp_time_good=[3:4 7:9];% 
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==5
        task='banana';
        exp_name=['banana_shallow'];
        exp_time_good=[1 2 3 5];
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==6
        task='orange';
        exp_name=['orange_deep'];
        exp_time_good=[1:10];  %% delet short data for ESN time window same length
%         exp_time_good=[2:10];
        exp_number=length(exp_time_good);
        exp_number_good=[2:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==7
        task='orange';
        exp_name=['orange_good'];
        exp_time_good=[1:15];
        exp_number=length(exp_time_good);
        exp_number_good=[1:9 11:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==8
        task='orange';
        exp_name=['orange_shallow'];
        exp_time_good=[1:10];
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==9
        task='tissue10';
        exp_name=['tissue10'];
        exp_time_good=[1:4];
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==10
        task='tissue30';
        exp_name=['tissue30'];
        exp_time_good=[1:5];
        exp_number=length(exp_time_good);
        exp_number_good=[1 3:4 6:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==11
        task='tissue50';
        exp_name=['tissue50'];
        exp_time_good=[1:5];
        exp_number=length(exp_time_good);
        exp_number_good=[3:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==12
        task='plstask';
        exp_name=['plstask'];
        exp_time_good=[1:10];% 
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(exp_kind,:);
    elseif exp_kind==13
        task='robot_avocado';
        exp_name=['robot_avocado'];
        exp_time_good=[1:28];% 
%         exp_time_good=[1:18];% part using for train
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(1,:);
    elseif exp_kind==14
        task='robot_orange';
        exp_name=['robot_orange'];
        exp_time_good=[2:38];% 
%         exp_time_good=[2:28];%  part using for train
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(5,:);
    elseif exp_kind==15
        task='robot_tissue10';
        exp_name=['robot_tissue10'];
        exp_time_good=[1:33];% 
%         exp_time_good=[1:23];%   part using for train
        exp_number=length(exp_time_good);
        exp_number_good=[1:length(exp_time_good)];
        color=color_list(10,:);
    elseif exp_kind==16
        task='robot_plstask';
        exp_name=['robot_plstask'];
        exp_time_good=[1:6 9:22];% 
%         exp_time_good=[1:6 9:14];%  part using for train
        exp_number=length(exp_time_good);
        exp_number_good=[1:7 9:22];
        color=color_list(15,:);
    elseif exp_kind==17
        task='frank_apple';
        exp_name=['apple'];
        exp_time_good=[1:34];% 
%         exp_time_good=[1:6 9:14];%  part using for train
        exp_number=length(exp_time_good);
        exp_number_good=[1:34];% 
        color=color_list(1,:);
    elseif exp_kind==18
        task='frank_orange';
        exp_name=['orange'];
        exp_time_good=[1:25];% 
%         exp_time_good=[1:6 9:14];%  part using for train
        exp_number=length(exp_time_good);
        exp_number_good=[1:25];% 
        color=color_list(9,:);
    elseif exp_kind==19
        task='frank_banana';
        exp_name=['banana'];
        exp_time_good=[1:11];% 
%         exp_time_good=[1:6 9:14];%  part using for train
        exp_number=length(exp_time_good);
        exp_number_good=[1:11];% 
        color=color_list(19,:);
    end

end

