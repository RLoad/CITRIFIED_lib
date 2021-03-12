function [ pos_data_serial_norm_time_data_pair_Mean_std force_data_serial_norm_time_data_pair_Mean_std imp_data_serial_norm_time_data_pair_Mean_std vel_knife_data_serial_norm_time_data_pair_Mean_std ] ...
    = get_mean_std( max_phase1, max_phase2,max_phase3,phase_num,dim,time_serise_data_serial,force_data_serial_norm_time,imp_data_serial_norm_time,pos_data_serial_norm_time,vel_knife_data_serial_norm_time )
%UNTITLED2 �˴���ʾ�йش˺����ժҪ
%   �˴���ʾ��ϸ˵��
    exp_time_num=size(time_serise_data_serial,2);
    for phase=phase_num
        for j=1:exp_time_num
            pos_data_serial{phase,j}(1:6,:)=pos_data_serial_norm_time{phase,j}(2:7,:);
            force_data_serial{phase,j}(1:6,:)=force_data_serial_norm_time{phase,j}(2:7,:);
            imp_data_serial{phase,j}(1:6,:)=imp_data_serial_norm_time{phase,j}(2:7,:);
            vel_knife_data_serial{phase,j}(1:6,:)=vel_knife_data_serial_norm_time{phase,j}(2:7,:);
        end
    end
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% make same time : get the longest time for each pahse  %%%%
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
    %  max=0;
      max=0;

    for phase=phase_num
        for j=1:exp_time_num
            size_data=length(imp_data_serial{phase,j});
            if size_data>=max
                max=size_data;
            else 

            end
        end
        if phase==1
            if max>max_phase1
                error('choice big max_phase1!!!');
            else
            end
        elseif phase==2
            if max>max_phase2
                error('choice big max_phase2!!!');
            else
            end
        else
            if max>max_phase3
                error('choice big max_phase3!!!');
            else
            end
        end
        max=0;
    end



    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  downsample to make sure all data in same length for plot and learning (GOOD) %%%
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    pos_data_serial_norm_time{3,exp_time_num}=[];
    force_data_serial_norm_time{3,exp_time_num}=[];
    imp_data_serial_norm_time{3,exp_time_num}=[];
    vel_knife_data_serial_norm_time{3,exp_time_num}=[];

    for phase=phase_num
        for j=1:exp_time_num
            if phase==1
                Q=(1:1:max_phase1);
                for k=dim
                    pos_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase1,length(pos_data_serial{phase,j}));      
                    force_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase1,length(pos_data_serial{phase,j}));
                    imp_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase1,length(pos_data_serial{phase,j}));
                    vel_knife_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase1,length(pos_data_serial{phase,j}));

                    pos_data_serial_norm_time{phase,j}(k+1,:)=pos_data_serial{phase,j}(k,:);
                    force_data_serial_norm_time{phase,j}(k+1,:)=force_data_serial{phase,j}(k,:);
                    imp_data_serial_norm_time{phase,j}(k+1,:)=imp_data_serial{phase,j}(k,:);
                    vel_knife_data_serial_norm_time{phase,j}(k+1,:)=vel_knife_data_serial{phase,j}(k,:);

                end
            elseif phase==2
                Q=(1:1:max_phase2);
                for k=dim
                    pos_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase2,length(pos_data_serial{phase,j}))+max_phase1;      
                    force_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase2,length(pos_data_serial{phase,j}))+max_phase1;
                    imp_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase2,length(pos_data_serial{phase,j}))+max_phase1;
                    vel_knife_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase2,length(pos_data_serial{phase,j}))+max_phase1;

                    pos_data_serial_norm_time{phase,j}(k+1,:)=pos_data_serial{phase,j}(k,:);
                    force_data_serial_norm_time{phase,j}(k+1,:)=force_data_serial{phase,j}(k,:);
                    imp_data_serial_norm_time{phase,j}(k+1,:)=imp_data_serial{phase,j}(k,:);
                    vel_knife_data_serial_norm_time{phase,j}(k+1,:)=vel_knife_data_serial{phase,j}(k,:);
                end
            else
                Q=(1:1:max_phase3);
                for k=dim
                    pos_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase3,length(pos_data_serial{phase,j}))+max_phase2+max_phase1;      
                    force_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase3,length(pos_data_serial{phase,j}))+max_phase2+max_phase1;
                    imp_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase3,length(pos_data_serial{phase,j}))+max_phase2+max_phase1;
                    vel_knife_data_serial_norm_time{phase,j}(1,:)=linspace(1,max_phase3,length(pos_data_serial{phase,j}))+max_phase2+max_phase1;

                    pos_data_serial_norm_time{phase,j}(k+1,:)=pos_data_serial{phase,j}(k,:);
                    force_data_serial_norm_time{phase,j}(k+1,:)=force_data_serial{phase,j}(k,:);
                    imp_data_serial_norm_time{phase,j}(k+1,:)=imp_data_serial{phase,j}(k,:);
                    vel_knife_data_serial_norm_time{phase,j}(k+1,:)=vel_knife_data_serial{phase,j}(k,:);
                end
            end
        end
    end

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% interp all data for get mean and std with time %%%
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pos_data_serial_norm_time_data_pair{3,exp_time_num}=[];
    force_data_serial_norm_time_data_pair{3,exp_time_num}=[];
    imp_data_serial_norm_time_data_pair{3,exp_time_num}=[];
    vel_knife_data_serial_norm_time_data_pair{3,exp_time_num}=[];
    pos_data_serial_norm_time_data_pair_Mean_std{3,2}=[];%{3,2}mean for pahse 1:3 and 1:2 is mean std
    force_data_serial_norm_time_data_pair_Mean_std{3,2}=[];
    imp_data_serial_norm_time_data_pair_Mean_std{3,2}=[];
    vel_knife_data_serial_norm_time_data_pair_Mean_std{3,2}=[];

    for phase=phase_num
        for k=dim
            %% interp all
            for j=1:exp_time_num
                data_length(j)=length(pos_data_serial_norm_time{phase,j}(1,:));
            end
            ind = find(data_length==min(data_length(:)));
            ind=ind(1);
            Q=pos_data_serial_norm_time{phase,ind}(1,:);

            for j=1:exp_time_num
                if j~=ind
                    pos_data_serial_norm_time_data_pair{phase,j}(1,:)=Q;
                    force_data_serial_norm_time_data_pair{phase,j}(1,:)=Q;
                    imp_data_serial_norm_time_data_pair{phase,j}(1,:)=Q;
                    vel_knife_data_serial_norm_time_data_pair{phase,j}(1,:)=Q;
                    pos_data_serial_norm_time_data_pair{phase,j}(k+1,:)=interp1(pos_data_serial_norm_time{phase,j}(1,:),pos_data_serial_norm_time{phase,j}(k+1,:),Q,'linear');%'nearest' 'spline' 'cubic'
                    force_data_serial_norm_time_data_pair{phase,j}(k+1,:)=interp1(force_data_serial_norm_time{phase,j}(1,:),force_data_serial_norm_time{phase,j}(k+1,:),Q,'linear');%'nearest' 'spline' 'cubic'
                    imp_data_serial_norm_time_data_pair{phase,j}(k+1,:)=interp1(imp_data_serial_norm_time{phase,j}(1,:),imp_data_serial_norm_time{phase,j}(k+1,:),Q,'linear');%'nearest' 'spline' 'cubic'
                    vel_knife_data_serial_norm_time_data_pair{phase,j}(k+1,:)=interp1(vel_knife_data_serial_norm_time{phase,j}(1,:),vel_knife_data_serial_norm_time{phase,j}(k+1,:),Q,'linear');%'nearest' 'spline' 'cubic'
                else
                    pos_data_serial_norm_time_data_pair{phase,j}(1,:)=Q;
                    force_data_serial_norm_time_data_pair{phase,j}(1,:)=Q;
                    imp_data_serial_norm_time_data_pair{phase,j}(1,:)=Q;
                    vel_knife_data_serial_norm_time_data_pair{phase,j}(1,:)=Q;
                    pos_data_serial_norm_time_data_pair{phase,j}(k+1,:)=pos_data_serial_norm_time{phase,ind}(k+1,:);
                    force_data_serial_norm_time_data_pair{phase,j}(k+1,:)=force_data_serial_norm_time{phase,ind}(k+1,:);
                    imp_data_serial_norm_time_data_pair{phase,j}(k+1,:)=imp_data_serial_norm_time{phase,ind}(k+1,:);
                    vel_knife_data_serial_norm_time_data_pair{phase,j}(k+1,:)=vel_knife_data_serial_norm_time{phase,ind}(k+1,:);

                end
            end

            %% get mean and std for each time step
            for time_pair=1:length(Q)
                pos_data_serial_norm_time_data_pair_Mean_std{phase,1}(1,:)=Q;
                pos_data_serial_norm_time_data_pair_Mean_std{phase,2}(1,:)=Q;
                for j=1:exp_time_num
                    ayiyou(j)=pos_data_serial_norm_time_data_pair{phase,j}(k+1,time_pair);
                end
                pos_data_serial_norm_time_data_pair_Mean_std{phase,1}(k+1,time_pair)=mean(ayiyou);
                pos_data_serial_norm_time_data_pair_Mean_std{phase,2}(k+1,time_pair)=std(ayiyou);

                force_data_serial_norm_time_data_pair_Mean_std{phase,1}(1,:)=Q;
                force_data_serial_norm_time_data_pair_Mean_std{phase,2}(1,:)=Q;
                for j=1:exp_time_num
                    ayiyou(j)=force_data_serial_norm_time_data_pair{phase,j}(k+1,time_pair);
                end
                force_data_serial_norm_time_data_pair_Mean_std{phase,1}(k+1,time_pair)=mean(ayiyou);
                force_data_serial_norm_time_data_pair_Mean_std{phase,2}(k+1,time_pair)=std(ayiyou);

                imp_data_serial_norm_time_data_pair_Mean_std{phase,1}(1,:)=Q;
                imp_data_serial_norm_time_data_pair_Mean_std{phase,2}(1,:)=Q;
                for j=1:exp_time_num
                    ayiyou(j)=imp_data_serial_norm_time_data_pair{phase,j}(k+1,time_pair);
                end
                imp_data_serial_norm_time_data_pair_Mean_std{phase,1}(k+1,time_pair)=mean(ayiyou);
                imp_data_serial_norm_time_data_pair_Mean_std{phase,2}(k+1,time_pair)=std(ayiyou);

                vel_knife_data_serial_norm_time_data_pair_Mean_std{phase,1}(1,:)=Q;
                vel_knife_data_serial_norm_time_data_pair_Mean_std{phase,2}(1,:)=Q;
                for j=1:exp_time_num
                    ayiyou(j)=vel_knife_data_serial_norm_time_data_pair{phase,j}(k+1,time_pair);
                end
                vel_knife_data_serial_norm_time_data_pair_Mean_std{phase,1}(k+1,time_pair)=mean(ayiyou);
                vel_knife_data_serial_norm_time_data_pair_Mean_std{phase,2}(k+1,time_pair)=std(ayiyou);
            end


        end
    end


end

