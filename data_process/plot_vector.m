function [ a] = plot_vector( Data_pose_vel,vel_samples,vel_size )
%UNTITLED �˴���ʾ�йش˺����ժҪ
%   �˴���ʾ��ϸ˵��
% Data_pose_vel 123 vector is 456 nothing is 789 is position

%% figure
% subplot(211)
% %2d
%     h_data = plot(Data_pose_vel(7,:),Data_pose_vel(9,:),'r.','markersize',10); hold on;
%     h_att = [];
%     att=[0;0];
%     h_att = scatter(att(1),att(2),150,[0 0 0],'d','Linewidth',2); hold on;
%     
%     % Plot Velocities of Reference Trajectories
%     vel_points = Data_pose_vel([7 9 1 3],1:vel_samples:end);
%     U = zeros(size(vel_points,2),1);
%     V = zeros(size(vel_points,2),1);
%     for i = 1:size(vel_points, 2)
%         dir_    = vel_points(3:end,i);%/norm(vel_points(3:end,i))
%         U(i,1)   = dir_(1);
%         V(i,1)   = dir_(2);
%     end
%     h_vel = quiver(vel_points(1,:)',vel_points(2,:)', U, V, vel_size, 'Color', 'b', 'LineWidth',2); hold on;
%     grid on;
%     box on;
    
%%     figure %3D
% subplot(212)
    h_data = plot3(Data_pose_vel(7,:),Data_pose_vel(8,:),Data_pose_vel(9,:),'r.','markersize',10); hold on;
    h_att = [];
    att=[0;0;0];
    h_att = scatter3(att(1),att(2),att(3),150,[0 0 0],'d','Linewidth',2); hold on;
    
    % Plot Velocities of Reference Trajectories
    vel_points = Data_pose_vel([7 8 9 1 2 3],1:vel_samples:end);
    U = zeros(size(vel_points,2),1);
    V = zeros(size(vel_points,2),1);
    W = zeros(size(vel_points,2),1);
    for i = 1:size(vel_points, 2)
        dir_    = vel_points(4:end,i);%/norm(vel_points(4:end,i))
        U(i,1)   = dir_(1);
        V(i,1)   = dir_(2);
         W(i,1)   = dir_(3);
    end
    h_vel = quiver3(vel_points(1,:)',vel_points(2,:)',vel_points(3,:)', U, V, W,vel_size, 'Color', 'b', 'LineWidth',2); hold on;
    grid on;axis equal;
    box on;
a=1;
end

