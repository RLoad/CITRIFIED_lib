%% ploting the activation of the muscles for each subject

load('data/subjectsDataTimimgs.mat')

%%
lengthTW=0.150;
overlap=0.100;
SR=1000;
bandPassCuttOffFreq=[50,400];
lowPassCutOffFreq=20;
timeBefore=0.300;
posLPFCutOffFreq=40;
posLPForder=7;
velLPCutOffFreq=5;
velLPorder=2;
velThreshold=0.05;
nbCrossValidationFolders=3;
normaLize=true;


muscleSets=struct([]);
muscleSets{1}{1}=1:12;%[2:11];
muscleSets{1}{2}=1:12;%[8:11];
muscleSets{2}{1}=1:12;%[1:6,8:12];
muscleSets{2}{2}=1:12;%[8:12];
muscleSets{3}{1}=1:12;%[1,4:12];
muscleSets{3}{2}=1:12;%[8:12];
muscleSets{4}{1}=1:12;%[1:12];l;jlhikgh
muscleSets{4}{2}=1:12;%[8:12];
muscleSets{5}{1}=1:12;%[8:12];

rectiFy=true;
extFeatures=true;


l_TW=lengthTW*SR;
delay_TW=l_TW-overlap*SR;

Singals=struct([]);
SignalsNormTime=struct([]);

%% not normalized time
% 
% for sbj=1:length(sbjData)
%     
%     mvc=calcMVC(sbjData{sbj},2:6);
%     
%     div=54;
%     
%     if sbj==3
%         div=51;
%     end
%     
%     output=struct([]);
%             
%     countTrials=1;
%     
%     for i=2:length(sbjData{sbj}.grasp)
% 
%         for j=1:length(sbjData{sbj}.grasp{i}.trial)
%             
%             
%             Sgnl=preprocessSignals(sbjData{sbj}.grasp{i}.trial{j}.emg,SR,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc);
%             
%             
%             Sgnl=Sgnl(sbjData{sbj}.grasp{i}.trial{j}.firstSample:min([sbjData{sbj}.grasp{i}.trial{j}.finalSample,size(Sgnl,1)]),:);
%             
%             countTw=1;
%             
%             for kk=1:delay_TW:size(Sgnl,1)
% 
%                     if kk+l_TW>size(Sgnl,1)
%                         
%                             output{countTrials}{countTw}=exctractFeatures(Sgnl(kk:end,muscleSets{sbj}{1}),[1,2]);
%                         
%                     else
%                        
%                             output{countTrials}{countTw}=exctractFeatures(Sgnl(kk:kk+l_TW,muscleSets{sbj}{1}),[1,2]);
%                         
%                     end
% 
%                     countTw=countTw+1;
%             end
%             
%             
%             countTrials=countTrials+1;
% 
%         end
% 
% 
%     end
%     
%     
%     musclesRMS=struct([]);
%     musclesAve=struct([]);
%     
%     for mm=1:length(muscleSets{sbj}{1})
%     
%         musRMS=[];
%         musMEAN=[];
% 
%         for i=1:150
% 
%             rmsAct=[];
%             meanAct=[];
% 
%             for kk=1:div
% 
% 
%                 rmsAct=[rmsAct,output{i}{kk}(mm)];
%                 meanAct=[meanAct,output{i}{kk}(mm+length(muscleSets{sbj}{1}))];
% 
%             end
% 
%             musRMS=[musRMS;rmsAct];
%             musMEAN=[musMEAN;meanAct];
% 
%         end
% 
%         musclesRMS{mm}=musRMS/max(max(musRMS));
%         musclesAve{mm}=musMEAN/max(max(musMEAN));
%         
%         
%     end
%     
%     
%     
%     
%     figure(100+2*sbj-1)
%     hold on
%     for mm=1:length(muscleSets{sbj}{1})
%         plot(-0.15:0.05:div*0.05-0.155,mean(musclesRMS{mm}),'Linewidth',3)
%     end
%     for mm=1:length(muscleSets{sbj}{1})
%         errorbar(-0.15:0.05:div*0.05-0.155,mean(musclesRMS{mm}),std(musclesRMS{mm})/5,'Linewidth',0.5)
%     end
%     
%     title(['subject ' num2str(sbj) ' - RMS'])
%     ylabel('rms')
%     xlabel('time [s]')
%     grid on
%     xticks(-0.2:0.2:50*0.05-0.155)
%     yticks(0:0.1:0.8)
%     axis([-.2 div*0.05-0.155 0 0.8])
%     set(gca,'fontsize',16)
%     set(gcf, 'Position', [100, 100, 800, 600])
%     savefig(['/home/jason/Dropbox/LASA/Reports&Papers/paper2/Amp_Activations_sbj_' num2str(sbj) '_RMS'])
%     
%     
%     figure(100+2*sbj)
%     hold on
%     for mm=1:length(muscleSets{sbj}{1})
%         plot(-0.15:0.05:div*0.05-0.155,mean(musclesAve{mm}),'Linewidth',3)
%     end
%     for mm=1:length(muscleSets{sbj}{1})
%         errorbar(-0.15:0.05:div*0.05-0.155,mean(musclesAve{mm}),std(musclesAve{mm})/5,'Linewidth',0.5)
%     end
%     title(['subject ' num2str(sbj) ' - Average activation'])
%     ylabel('average activation')
%     xlabel('time [s]')
%     grid on
%     xticks(-0.2:0.2:50*0.05-0.155)
%     yticks(0:0.1:0.8)
%     axis([-.2 div*0.05-0.155 0 0.8])
%     set(gca,'fontsize',16)
%     set(gcf, 'Position', [100, 100, 800, 600])
%     savefig(['/home/jason/Dropbox/LASA/Reports&Papers/paper2/Amp_Activations_sbj_' num2str(sbj) '_AVE'])
%     
% end
% 
% 


    
    
%% normalized time


velTh=[0.1,0.05,0.02,0.05];
% velThreshold=0.01;


% cut-off frequency of the low-pass filter for the elbow joint angle
cutoff_LP=50; % Hz

% order of the low-pass filter for the elbow joint angle
order_LP=2;

% cut-off frequency of the low-pass filter for the angular velocity of
% the elbow joint 
velLPCutOffFreq=5; % Hz




for sbj=1:1%length(sbjData)
    
    mvc=calcMVC(sbjData{sbj},2:6);
    
    
    trialLengths=zeros(length(sbjData{sbj}.grasp{2}.trial),2);

    velThreshold=velTh(sbj);

    for i=2:6
         
                
        for j=1:length(sbjData{sbj}.grasp{i}.trial)
            
            [angVel,filtGonio]=preprocGonio(sbjData{sbj}.grasp{i}.trial{j}.gonio,SR,cutoff_LP,order_LP,velLPCutOffFreq,order_LP);
            [motionOnset,motionEnd]=findMotionLimits(angVel,SR,lengthTW,overlap,0.370,velThreshold);
            
            trialLengths(j,i-1)=(motionEnd-motionOnset);
        end
    end
    
    
    VEls=[];
    
    pVelMax=[];
    
    output=struct([]);
            
    countTrials=1;
    
    for i=2:length(sbjData{sbj}.grasp)

        for j=1:length(sbjData{sbj}.grasp{i}.trial)
            
            if sbjData{sbj}.grasp{i}.trial{j}.motionOnset~=0
            
%             if j==13
%                 [i j]
               
%             end

            [angVel,filtGonio]=preprocGonio(sbjData{sbj}.grasp{i}.trial{j}.gonio,SR,cutoff_LP,order_LP,velLPCutOffFreq,order_LP);
            [motionOnset,motionEnd]=findMotionLimits(angVel,SR,lengthTW,overlap,0.370,velThreshold);
            
            Sgnl=preprocessSignals(sbjData{sbj}.grasp{i}.trial{j}.emg,SR,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc);
            
            
            %reSignal=resample(Sgnl(motionOnset:motionEnd + floor(0.2*(motionEnd-motionOnset)),:),SR,1.2*trialLengths(j,i-1));
            reSignal=resample(Sgnl(motionOnset:motionEnd,:),SR,trialLengths(j,i-1));
            
            resampledVel=resample(angVel(motionOnset:motionEnd ),SR,trialLengths(j,i-1));
    
            countTw=1;
            
            TWvelocity=[];
            
            tTW=[];
            
            for kk=1:delay_TW:size(reSignal,1)
                
                    

                    if kk+l_TW>=size(reSignal,1)
                        
                            output{countTrials}{countTw}=exctractFeatures(reSignal(kk:end,muscleSets{sbj}{1}),[1,2]);
                            TWvelocity=[TWvelocity;mean(abs(resampledVel(kk:end)))];
                            tTW=[tTW;kk+l_TW];
                    else
                       
                            output{countTrials}{countTw}=exctractFeatures(reSignal(kk:kk+l_TW,muscleSets{sbj}{1}),[1,2]);
                            TWvelocity=[TWvelocity;mean(abs(resampledVel(kk:kk+l_TW)))];
                            tTW=[tTW;kk+l_TW];
                            
                    end

                    countTw=countTw+1;
            end
             
            VEls=[VEls;TWvelocity'];
            countTrials=countTrials+1;
            
            [~,idx]=max(TWvelocity);
            pVelMax=[pVelMax;tTW(idx)./tTW(end)];

            end
        end

    end
    
    figure
    errorbar(tTW,mean(VEls),std(VEls))
    title(['subject ' num2str(sbj) ' - angular velocity'])
    xlabel('normalized time')
    
    disp('ok')
    disp(countTrials)
    
    musclesRMS=struct([]);
    musclesAve=struct([]);
    
    for mm=1:length(muscleSets{sbj}{1})
    
        musRMS=[];
        musMEAN=[];

        mm
        
        for i=1:countTrials-1

            
            i
            rmsAct=[];
            meanAct=[];

            for kk=1:length(output{i})


                rmsAct=[rmsAct,output{i}{kk}(mm)];
                meanAct=[meanAct,output{i}{kk}(mm+length(muscleSets{sbj}{1}))];

            end

            musRMS=[musRMS;rmsAct];
            musMEAN=[musMEAN;meanAct];

        end

        musclesRMS{mm}=musRMS;%/max(max(musRMS));
        musclesAve{mm}=musMEAN;%/max(max(musMEAN));
        
        
    end
    
    disp('ok2')
    figure(600+2*sbj-1)
    hold on
    for mm=1:length(muscleSets{sbj}{1})
        plot(1:size(musclesAve{mm},2),mean(musclesRMS{mm}),'Linewidth',3)
    end
    for mm=1:length(muscleSets{sbj}{1})
        errorbar(1:size(musclesAve{mm},2),mean(musclesRMS{mm}),std(musclesRMS{mm})/5,'Linewidth',0.5)
    end
    p=patch([mean(pVelMax)-std(pVelMax) mean(pVelMax)+std(pVelMax) mean(pVelMax)+std(pVelMax) mean(pVelMax)-std(pVelMax)]*100,[0,0,0.16,0.16],'g');
    set(p,'FaceAlpha',0.5); 
    vline(mean(pVelMax)*100,'g')
    
    title(['subject ' num2str(sbj) ' - RMS - normalized time'])
    ylabel('rms')
    xlabel('normalized time')
    grid on
    yticks(0:0.01:0.15)
    xticks(0:10:size(musclesAve{mm},2))
%     axis([0 120 0 0.8])
    set(gca,'fontsize',16)
    set(gcf, 'Position', [100, 100, 800, 600])
%     savefig(['/home/jason/Dropbox/LASA/Reports&Papers/paper2/Amp_Activations_sbj_' num2str(sbj) '_RMS_normTime'])
    
    
    figure(600+2*sbj)
    hold on
    plot(1:size(musclesAve{1},2),mean(musclesAve{1}),'Linewidth',3)
    plot(1:size(musclesAve{10},2),mean(musclesAve{10}),'Linewidth',3)
    legend('Upper arm muscles','forearm muscles')
    for mm=1:length(muscleSets{sbj}{1})
        plot(1:size(musclesAve{mm},2),mean(musclesAve{mm}),'Linewidth',3)
    end
%     for mm=1:length(muscleSets{sbj}{1})
%         errorbar(1:size(musclesAve{mm},2),mean(musclesAve{mm}),std(musclesAve{mm})/5,'Linewidth',0.5)
%     end
    
    p=patch([mean(pVelMax)-std(pVelMax) mean(pVelMax)+std(pVelMax) mean(pVelMax)+std(pVelMax) mean(pVelMax)-std(pVelMax)]*100,[0,0,0.16,0.16],'g');
    set(p,'FaceAlpha',0.5); 
    vline(mean(pVelMax)*100,'g')
    
    
    title(['subject ' num2str(sbj) ' - Average activation - normalized time'])
    ylabel('Average')
    xlabel('normalized time [%]')
    grid on
    yticks(0:0.01:0.15)
    xticks(0:10:size(musclesAve{mm},2))
%     axis([0 120 0 0.8])
    set(gca,'fontsize',16)
    set(gcf, 'Position', [100, 100, 800, 600])
%     savefig(['/home/jason/Dropbox/LASA/Reports&Papers/paper2/Amp_Activations_sbj_' num2str(sbj) '_AVE_normTime'])
   
    

end