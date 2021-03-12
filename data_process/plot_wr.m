function [ output_args ] = plot_wr(figure_obj,position_and_size)
%%% plot as I like
% this funciton will give each plot a framework to decied size, position,
% front, color, linetype, linewidth, title .......

size=get(0,'ScreenSize');
if position_and_size==1
    figure_obj.Position=[1 1 size(3:4)*0.8];
    
%     set(gcf,'unit','centimeters','position',[0 0 size(3:4)*0.8])
    set(gca,'Position',[.15 .15 .8 .75],'FontName','Times New Roman','FontSize',12);

    figureHandle = gcf;
    %# make all text in the figure to size 14 and bold
    set(findall(figureHandle,'type','text'),'FontName','Times New Roman','FontSize',12)
    
    colorbar('FontName','Times New Roman','FontSize',12);
    
elseif position_and_size==2
    figure_obj.Position=[1+10 50 size(3:4)*0.4];
elseif position_and_size==3
    figure_obj.Position=[size(3)*0.4+10 50 size(3:4)*0.4];
elseif position_and_size==4
    figure_obj.Position=[1+10 size(3)*0.25 size(3:4)*0.4];
elseif position_and_size==5
    figure_obj.Position=[size(3)*0.4*(position_and_size-2) 2 size(3:4)*0.4];
elseif position_and_size==6
    figure_obj.Position=[size(3)*0.4*(position_and_size-2) size(4)*0.4*(position_and_size-2) size(3:4)*0.4];
end

output_args=1;
end

