function []=plotTrial(sData,figureID)

figure(figureID)

[angVel,filtGonio]=preprocGonio(sData.gonio,1000,40,7,5,2);
subplot(3,1,1)
plot(sData.emg)
grid on
title(['emg grasp [tmp] trial [tmp]'])
xlim([300 length(filtGonio)])
subplot(3,1,2)
plot(sData.gonio*180/pi)
grid on
hold on
plot(filtGonio*180/pi,'r')
title('elbow angle')
xlim([300 length(filtGonio)])
hold off
subplot(3,1,3)
plot(angVel)
grid on
title('angular velocity')
xlim([300 length(filtGonio)])




end