%% ploting the activation of the muscles for each subject

load('data/ableBodiedData.mat')

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
muscleSets{1}{1}=[1:3,5,7:12];
muscleSets{1}{2}=8:12;
muscleSets{2}{1}=[1:10,12];
muscleSets{2}{2}=[8:10,12];
muscleSets{3}{1}=1:12;
muscleSets{3}{2}=8:12;
muscleSets{4}{1}=1:12;
muscleSets{4}{2}=8:12;
muscleSets{5}{1}=1:12;
muscleSets{5}{2}=8:12;

trialsExclusion=struct([]);
trialsExclusion{1}=[11,21];
trialsExclusion{2}=[15,29];
trialsExclusion{3}=[];
trialsExclusion{4}=[];
trialsExclusion{5}=[];


rectiFy=true;
extFeatures=true;


div=length(-0.150:0.050:2);


l_TW=lengthTW*SR;
delay_TW=l_TW-overlap*SR;

Singals=struct([]);
SignalsNormTime=struct([]);

%% not normalized time

for sbj=1:3
 
    
    mvc=calcMVC(sbjData{sbj},2:6);
    
    div=54;
    
    if sbj==3
        div=51;
    end
    
    output=struct([]);
            
    countTrials=1;
    
    for i=2:length(sbjData{sbj}.grasp)

        
        
        
        for j=1:length(sbjData{sbj}.grasp{i}.trial)
            
            if sbjData{sbj}.grasp{i}.trial{j}.motionOnset~=0
            
                
                Sgnl=preprocessSignals(sbjData{sbj}.grasp{i}.trial{j}.emg,SR,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc);
            
            
                Sgnl=Sgnl(sbjData{sbj}.grasp{i}.trial{j}.firstSample:min([sbjData{sbj}.grasp{i}.trial{j}.finalSample,size(Sgnl,1)]),:);
            
                countTw=1;
            
                for kk=1:delay_TW:size(Sgnl,1)
    
                        if kk+l_TW>size(Sgnl,1)
                        
                                output{countTrials}{countTw}=exctractFeatures(Sgnl(kk:end,muscleSets{sbj}{1}),[1,2]);
                        
                        else
                       
                            output{countTrials}{countTw}=exctractFeatures(Sgnl(kk:kk+l_TW,muscleSets{sbj}{1}),[1,2]);
                        
                        end

                        countTw=countTw+1;
                end
            
            
                countTrials=countTrials+1;

            end
        end

    end
    
    
    musclesRMS=struct([]);
    musclesAve=struct([]);
    
    for mm=1:length(muscleSets{sbj}{1})
    
        musRMS=[];
        musMEAN=[];

        for i=1:50

            rmsAct=[];
            meanAct=[];

            for kk=1:div-1

                

                rmsAct=[rmsAct,output{i}{kk}(mm)];
                meanAct=[meanAct,output{i}{kk}(mm+length(muscleSets{sbj}{1}))];

            end

            musRMS=[musRMS;rmsAct];
            musMEAN=[musMEAN;meanAct];

        end

        musclesRMS{mm}=musRMS/max(max(musRMS));
        musclesAve{mm}=musMEAN/max(max(musMEAN));
        
        
    end
    
    
    
    
    figure(1500+2*sbj-1)
    hold on
    for mm=1:length(muscleSets{sbj}{1})
        plot(-0.15:0.05:(div-1)*0.05-0.155,mean(musclesRMS{mm}),'Linewidth',3)
    end
    for mm=1:length(muscleSets{sbj}{1})
        errorbar(-0.15:0.05:(div-1)*0.05-0.155,mean(musclesRMS{mm}),std(musclesRMS{mm})/5,'Linewidth',0.5)
    end
    
    title(['ablebodied subject ' num2str(sbj) ' - RMS'])
    ylabel('rms')
    xlabel('time [s]')
    grid on
    xticks(-0.2:0.2:50*0.05-0.155)
    yticks(0:0.1:0.8)
    axis([-.2 50*0.05-0.155 0 0.8])
    set(gca,'fontsize',16)
    set(gcf, 'Position', [100, 100, 800, 600])
    savefig(['/home/jason/Dropbox/LASA/Reports&Papers/paper2/AbleBodied_Activations_sbj_' num2str(sbj) '_RMS'])
    
    figure(500+2*sbj)
    hold on
    for mm=1:length(muscleSets{sbj}{1})
        plot(-0.15:0.05:(div-1)*0.05-0.155,mean(musclesAve{mm}),'Linewidth',3)
    end
    for mm=1:length(muscleSets{sbj}{1})
        errorbar(-0.15:0.05:(div-1)*0.05-0.155,mean(musclesAve{mm}),std(musclesAve{mm})/5,'Linewidth',0.5)
    end
    title(['ablebodied subject ' num2str(sbj) ' - Average activation'])
    ylabel('average activation')
    xlabel('time [s]')
    grid on
    xticks(-0.2:0.2:50*0.05-0.155)
    yticks(0:0.1:0.8)
    axis([-.2 50*0.05-0.155 0 0.8])
    set(gca,'fontsize',16)
    set(gcf, 'Position', [100, 100, 800, 600])
    savefig(['/home/jason/Dropbox/LASA/Reports&Papers/paper2/AbleBodied_Activations_sbj_' num2str(sbj) '_AVE'])
    
    
end




    
    
%% normalized time


for sbj=3:3
    
    mvc=calcMVC(sbjData{sbj},2:6);
    
    
    trialLengths=zeros(length(sbjData{sbj}.grasp{2}.trial),2);


    for i=2:6

        for j=1:length(sbjData{sbj}.grasp{i}.trial)
            trialLengths(j,i-1)=(sbjData{sbj}.grasp{i}.trial{j}.motionEnd-sbjData{sbj}.grasp{i}.trial{j}.motionOnset);
        end
    end
    
    
    output=struct([]);
            
    countTrials=1;
    
    for i=2:length(sbjData{sbj}.grasp)

        
        
        for j=1:length(sbjData{sbj}.grasp{i}.trial)
            
            if sbjData{sbj}.grasp{i}.trial{j}.motionOnset~=0
            
            
    %             if j==13
    %                 
    %                 [i j]
    %             end

                Sgnl=preprocessSignals(sbjData{sbj}.grasp{i}.trial{j}.emg,SR,bandPassCuttOffFreq,lowPassCutOffFreq,normaLize,rectiFy,mvc);


                reSignal=resample(Sgnl(sbjData{sbj}.grasp{2}.trial{i}.motionOnset:sbjData{sbj}.grasp{2}.trial{i}.motionEnd + floor(0.2*(sbjData{sbj}.grasp{i}.trial{j}.motionEnd-sbjData{sbj}.grasp{i}.trial{j}.motionOnset)),:),SR,trialLengths(j,i-1));

                countTw=1;

                for kk=1:delay_TW:size(Sgnl,1)

                        if kk+l_TW>size(Sgnl,1)

                                output{countTrials}{countTw}=exctractFeatures(Sgnl(kk:end,muscleSets{sbj}{1}),[1,2]);

                        else

                                output{countTrials}{countTw}=exctractFeatures(Sgnl(kk:kk+l_TW,muscleSets{sbj}{1}),[1,2]);

                        end

                        countTw=countTw+1;
                end


                countTrials=countTrials+1;

            end
        end


    end
    
    
    musclesRMS=struct([]);
    musclesAve=struct([]);
    
    for mm=1:length(muscleSets{sbj}{1})
    
        musRMS=[];
        musMEAN=[];

        for i=1:149

            rmsAct=[];
            meanAct=[];

            for kk=1:80

                rmsAct=[rmsAct,output{i}{kk}(mm)];
                meanAct=[meanAct,output{i}{kk}(mm+length(muscleSets{sbj}{1}))];

            end

            musRMS=[musRMS;rmsAct];
            musMEAN=[musMEAN;meanAct];

        end

        musclesRMS{mm}=musRMS/max(max(musRMS));
        musclesAve{mm}=musMEAN/max(max(musMEAN));
        
        
    end
    
    figure(700+2*sbj-1)
    hold on
    for mm=1:length(muscleSets{sbj}{1})
        plot((120/80):(120/80):120,mean(musclesRMS{mm}),'Linewidth',3)
    end
    for mm=1:length(muscleSets{sbj}{1})
        errorbar((120/80):(120/80):120,mean(musclesRMS{mm}),std(musclesRMS{mm})/5,'Linewidth',0.5)
    end
    
    title(['ablebodied subject ' num2str(sbj) ' - RMS - normalized time'])
    ylabel('rms')
    xlabel('normalized time [%]')
    grid on
    yticks(0:0.1:0.8)
    axis([0 120 0 0.8])
    set(gca,'fontsize',16)
    set(gcf, 'Position', [100, 100, 800, 600])
    savefig(['/home/jason/Dropbox/LASA/Reports&Papers/paper2/AbleBodied_Activations_sbj_' num2str(sbj) '_RMS_normTime'])
    
    
    figure(700+2*sbj)
    hold on
    for mm=1:length(muscleSets{sbj}{1})
        plot((120/80):(120/80):120,mean(musclesAve{mm}),'Linewidth',3)
    end
    for mm=1:length(muscleSets{sbj}{1})
        errorbar((120/80):(120/80):120,mean(musclesAve{mm}),std(musclesAve{mm})/5,'Linewidth',0.5)
    end
    title(['subject ' num2str(sbj) ' - Average activation - normalized time'])
    ylabel('ablebodied average activation')
    xlabel('normalized time [%]')
    grid on
    yticks(0:0.1:0.8)
    axis([0 120 0 0.8])
    set(gca,'fontsize',16)
    set(gcf, 'Position', [100, 100, 800, 600])
    savefig(['/home/jason/Dropbox/LASA/Reports&Papers/paper2/AbleBodied_Activations_sbj_' num2str(sbj) '_AVE_normTime'])
   
    

end