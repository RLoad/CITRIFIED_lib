clear all,
close all,

subjects = {'subject_1','subject_2','subject_3','subject_4','subject_5','subject_6','subject_7','subject_8'}; 

raw_data = [];
all_data = [];
av_trial_data = [];

k = 1;
dim = 15;
r = 8;

for l=1:1
    l
    folder_name  =[ 'C:\Users\Sahar\Desktop\Backup_Folder\EPFL_Grasping\EMG_REACH\matlab files\neuroprosthetics_data\EMG_data_TNE\', subjects{l}];

    cd (folder_name);

    load EMG_block

    cd ../../../..
    
    

    for i=1:length( EMG_epoch.Obj)
        av_trial_data{l,i} = zeros(1000, 15);
        for j=1:length(EMG_epoch.Obj{i}.reach)
            
             M = EMG_epoch.Obj{i}.reach{j};
          
             
%              [n,c] = find(M < 0);
%              for m=1:length(c)
%                 M(n(m),c(m)) = 0;
%              end

             M = resample(M, 1000, length(M)) ;
             raw_data{l,i,j} = EMG_epoch.Obj{i}.reach{j};
             
             av_trial_data{l,i} = av_trial_data{l,i} + M;
%             all_data = [all_data EMG_epoch.Obj{i}.reach{j}'];
%             k = k+1;
        end
    end
end


data_pca = [];
for i=1:length( EMG_epoch.Obj)
     for j=1:length(EMG_epoch.Obj{i}.reach)
    	
            data_pca = [data_pca; EMG_epoch.Obj{i}.reach{j} ];
     end
end
size(data_pca)

% %%
% data_pca = [];
% for i=1:length( EMG_epoch.Obj)
%     av_trial_data{l,i} = av_trial_data{l,i}/length(EMG_epoch.Obj{i}.reach);
%     data_pca = [data_pca; av_trial_data{l,i} ];
% end
% 
 
mean_dataPca = mean(data_pca);
[coeff,score,latent] = princomp(data_pca);

 
 lat = latent/sum(latent);
 new_base = coeff(:,1:6)';
 


 
 %%
 
 raw_data_pca = [];
 for i=1:length(EMG_epoch.Obj)
     
     for j=1:length(EMG_epoch.Obj{i}.reach)
         
            mat = raw_data{l,i,j}-repmat(mean_dataPca,length(raw_data{l,i,j}),1);
            raw_data_pca{l,i,j} = new_base*mat';
     end
 end
%       