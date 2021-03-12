
clear all
close all
clc




addpath('..\toolbox_function')
addpath('..\toolbox_function\caps_functions')
addpath('..\toolbox_function\featureExtraction')

addpath('..\ESN')
addpath('..\ESN\Toolbox_ESN')

addpath('C:\Users\ibatzianoulis\Documents\MATLAB\caps')


%% set the paremeters

% path to the folder of data

datapath='/media/jason/data/MATLAB/CBM/data/';%'C:\CAPS\DEV\USERS\';

% the name of the user in CAPS

nameOfUser='TR45_online';

% the number of classes to train the classifier

nbClasses=4;

classesSets=1:nbClasses;

% the number of trial per grasp in each folder

nbTrials=10;

% length of the time interval to examine

div=length(-0.150:0.050:2.5); 

% muscles to take into account

muscleSets=1:12;    % all the muscleset

% velocity threshold

velThreshold=0.1;

% number of internal units of the ESN

nUn=150;

% the spectral radius of the ESN

alpha=0.7;

% number of time windows to be taken into account in the majority vote

historyTW='8';

% selected features

features={'RMS','WaveFormLength','SlopeChanges'};


%% convert DAQ files to mat

A=extractData2([datapath nameOfUser]);

%% organize the data for the classification

sbjData.grasp=organiseData([datapath nameOfUser '/MAT'],nbClasses,nbTrials,'emg',[1 12],'goniometer',13);%'\DATA\MAT'

[d1,d2,d3,Fd1,Fd2,Fd3,mvc]=createDataSetsOn(sbjData,classesSets,1,'MuscleSet',muscleSets,'Normalization',true,'FeatureExtraction',features);


%% train the classifier

[ESNmodelallmotion,ESNmodelonlylast]=trainESNClassifierOn(d1,d2,d3,historyTW,classesSets,nUn,alpha,1,muscleSets);


%% variables for the online implementation

save(['trainedSystem_' nameOfUser '.mat'],'ESNmodelallmotion','ESNmodelonlylast','mvc','d1','d2','d3','sbjData','historyTW','alpha','nUn','velThreshold','muscleSets','div','nbClasses','classesSets')

