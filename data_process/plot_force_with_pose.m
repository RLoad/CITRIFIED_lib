function [ a] = plot_force_with_pose( Data_pose_vel,vel_samples,vel_size )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% figure
%2d
%     h_data = plot3(Data_pose_vel(1,:),Data_pose_vel(2,:),Data_pose_vel(3,:),'r.','markersize',10); hold on;
    h_att = [];
    att=[0;0;0];
    h_att = scatter3(att(1),att(2),att(3),150,[0 0 0],'d','Linewidth',2); hold on;
    
    % Plot Velocities of Reference Trajectories
    vel_points = Data_pose_vel(:,1:vel_samples:end);
    U = zeros(size(vel_points,2),1);
    V = zeros(size(vel_points,2),1);
    W = zeros(size(vel_points,2),1);
    for i = 1:size(vel_points, 2)
        dir_    = vel_points(4:end,i);%/norm(vel_points(3:end,i))
        U(i,1)   = dir_(1);
        V(i,1)   = dir_(2);
        W(i,1)   = dir_(3);
    end
    h_vel = quiver3(vel_points(1,:)',vel_points(2,:)',vel_points(3,:)', U, V, W, vel_size, 'Color', 'r', 'LineWidth',2); hold on;
    grid on;
    box on;
    
a=1;
end

