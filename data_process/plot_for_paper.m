function [ output_args ] = plot_for_paper(figure_obj,position_and_size)
%%% plot as I like
% this funciton will give each plot a framework to decied size, position,
% front, color, linetype, linewidth, title .......

% size=get(0,'ScreenSize');
if position_and_size==1
%     figure_obj.Position=[1 1 size(3:4)*0.8];
    
    set(gcf,'unit','centimeters','position',[10 5 7*2 5*2])
    
%     set(gca,'Position',[.15 .15 .8 .75],'FontName','Times New Roman','FontSize',3);
% 
%     figureHandle = gcf;
%     %# make all text in the figure to size 14 and bold
%     set(findall(figureHandle,'type','text'),'FontName','Times New Roman','FontSize',3)
%     
%     colorbar('FontName','Times New Roman','FontSize',3);e
elseif position_and_size==2
    set(gcf,'unit','centimeters','position',[10 5 7*1.4 5*1.4])
end

output_args=1;
end

