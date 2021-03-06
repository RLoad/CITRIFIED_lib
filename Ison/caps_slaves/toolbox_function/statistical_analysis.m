
% choose if the subjects are amputees or or able-bodied
% AMP = amputees
% ABD = able-bodied
sbjType='ABD';



if sbjType=='AMP'
    % load the data
    load('data/subjectsDataTimimgs.mat')
    
    % velocity threshold above which it is considered motion
    velThreshold=[0.1;0.05;0.02;0.05];
else
    % load the data
    load('data/ableBodiedData.mat')
    
    % velocity threshold above which it is considered motion
    velThreshold=[0.1;0.1;0.1;0.1;0.1];
end

% length of the time window
lengthTW=0.150;
overlap=0.100;

% sample frequency
SR=1000;

% cut-off frequency of the low-pass filter for the elbow joint angle
cutoff_LP=50; % Hz

% order of the low-pass filter for the elbow joint angle
order_LP=2;

% cut-off frequency of the low-pass filter for the angular velocity of
% the elbow joint 
velLPCutOffFreq=5; % Hz

% filtering of the EMG
bandPassCuttOffFreq=[50,400];
lowPassCutOffFreq=20;


for sbj=5:5
    
    mvc=calcMVC(sbjData{sbj},[2,3,4,5,6]);
    
    tmpMatrix=struct([]);
    
    
    tmpMatrix{1}=[];
    tmpMatrix{2}=[];
    tmpMatrix{3}=[];
    tmpMatrix{4}=[];
    tmpMatrix{5}=[];
    tmpMatrix{6}=[];
    tmpMatrix{7}=[];
    tmpMatrix{8}=[];
    tmpMatrix{9}=[];
    tmpMatrix{10}=[];
    tmpMatrix{11}=[];
    tmpMatrix{12}=[];
    
    
    pVelMax=[];
    
    for grasp=2:length(sbjData{sbj}.grasp)
        for tr=1:length(sbjData{sbj}.grasp{grasp}.trial)
            
            
            if sbjData{sbj}.grasp{grasp}.trial{tr}.motionOnset~=0
                
                disp([grasp tr])

                [angVel,filtGonio]=preprocGonio(sbjData{sbj}.grasp{grasp}.trial{tr}.gonio,SR,cutoff_LP,order_LP,velLPCutOffFreq,order_LP);

                [motionOnset,motionEnd]=findMotionLimits(angVel,SR,lengthTW,overlap,0.370,velThreshold(sbj));

                tAngVel=angVel(motionOnset:motionOnset+round(1.25*(motionEnd-motionOnset)));

                rAngVel=resample(tAngVel,1250,length(tAngVel));

                EMGSignals=preprocessSignals(sbjData{sbj}.grasp{grasp}.trial{tr}.emg,SR,bandPassCuttOffFreq,lowPassCutOffFreq,true,true,mvc);

                tEMG=EMGSignals(motionOnset:motionOnset+round(1.25*(motionEnd-motionOnset)),:);

                rEMG=resample(tEMG,1250,size(tEMG,1));

                [~,idx]=max(abs(rAngVel));
                pVelMax=[pVelMax;idx];

%                 figure(3)
%                 subplot(2,1,1)
%                 plot(tEMG)
%                 hold on
%     %             vline(150,'g')
%                 vline(motionEnd-motionOnset,{'r'})
%                 title('filtered emg signals')
%                 hold off
%                 
%                 subplot(2,1,2)
%                 plot(angVel(motionOnset:motionOnset+round(1.25*(motionEnd-motionOnset))))
%                 hold on
%     %             vline(150,'g')
%                 vline(motionEnd-motionOnset,{'r'})
%                 title('angular velocity')
%                 hold off
%                 
%                 disp(['grasp: ' num2str(grasp) ' trial: ' num2str(tr)])
%                 
%                 
%                 figure(1)
%                 plot(tEMG)
%                 title('non-resampled emg signals')
%                 xticks([100:100:1200])
%                 vline(motionEnd-motionOnset,{'r'})
%                 
%                 figure(2)
%                 plot(rEMG)
%                 title('resampled emg signals')
%                 xticks([100:100:1200])
%                 vline(1000,'r')
%                 
%                 
%                 figure(4)
%                 plot(rAngVel)
%                 title('resampled angular velocity')
%                 xticks([100:100:1200])
%                 vline(1000,'r')
%                 
%                 pause;

                for i=1:12
                    tmpMatrix{i}=[tmpMatrix{i};rEMG(:,i)'];
                end
                
            end
            
        end
    end
    
    figure(sbj)
    hold on
    plot(mean(tmpMatrix{1}),'Linewidth',5,'Color',[0.6,0.2,0])
    plot(mean(tmpMatrix{10}),'Linewidth',5,'Color',[0,0.447,0.741])
    legend('Upper-arm muscles','Forearm muscles')
    for i=1:7
        plot(mean(tmpMatrix{i}),'Linewidth',5,'Color',[0.6,0.2,0])
    end
    for i=8:12
        plot(mean(tmpMatrix{i}),'Linewidth',5,'Color',[0,0.447,0.741])
    end
    p=patch([mean(pVelMax)-std(pVelMax) mean(pVelMax)+std(pVelMax) mean(pVelMax)+std(pVelMax) mean(pVelMax)-std(pVelMax)],[0,0,0.16,0.16],'k');%''EdgeColor',[0.467,0.188,0.675],'FaceColor',[0.231,0.337,0.443],...
    set(p,'FaceAlpha',0.5,'EdgeColor',[0.467,0.675,0.188],'FaceColor',[0.231,0.443,0.337]);
    vline(mean(pVelMax),{'g','LineWidth',8,'LineStyle','-'})
    vline(1000,{'r','LineWidth',8,'LineStyle','--'})
    grid on
    if sbjType=='AMP'
        title(['TR ' num2str(sbj)])
    else
        title(['able-bodied subject ' num2str(sbj-1)])
    end
    ylabel('EMG activity')
    yticks(0:0.01:0.15)
    xlabel('normalized time [%]')
    xlim([0 1250])
    xticks([100:100:1200])
    xticklabels({'10','20','30','40','50','60','70','80','90','100','110','120'})
    
    set(gca,'FontSize',36,'FontWeight','bold')
    set(gcf, 'Position', [100, 100, 800, 600])
    
end
        






