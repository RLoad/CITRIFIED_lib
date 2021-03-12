function []=plotConfusionMatrix(confusionData,labels,nbFigm,ttle)



figure(nbFigm)
%Corralation Matrices
%L={'precision disk','tripod','thumb-2 fingers','thumb-4 fingers','ulnar'};
imagesc(confusionData)
%%
set(gca, 'YTick', 1:size(confusionData,1));
set(gca, 'YTickLabel', labels)
set(gca, 'XTick', []);
%%
    %set(gca, 'YTickLabel', L)
    %xlabel('rot',45)
x = 1:size(confusionData,1);
t = text(x,(size(confusionData,1)+0.5)*ones(1,length(x)),labels);%5.5
%%
set(t,'HorizontalAlignment','right','VerticalAlignment','top', ...
    'Rotation',45);
    
colorbar
title(ttle)



end