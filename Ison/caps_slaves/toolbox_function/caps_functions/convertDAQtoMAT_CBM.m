function MAToutput = CBM_DAQtoMAT(subjectpath)
% Convert .DAQ files into .MAT files
%
% ONLY COMPATIBLE WITH MATLAB 32-BIT
%
% The function converts .DAQ files into .MAT when given a path to a CAPS 
% USER folder. If not given a path in the argument, it will launch a
% window to manually browse for a USER folder (can change starting 
% directory for browser window in line 47). Once a USER is selected, it 
% will automatically look for associated DAQ files to convert into MAT 
% files and save the MAT files in the "MAT" folder. If a MAT folder already
% exists for a USER,it offers the option to save over trials of the same 
% name or only convert and save new trials. If opening a USER folder on the 
% share drive, make sure no other computers/programs are currently using 
% the intended USER folder.
% 
% INPUTS:
%   subjectpath - CAPS USER file (containing DATA folder with DAQ files) to import into Matlab; Optional. When
%                 not provided, prompts the code user to select a file.
%
% OUTPUTS:
%   user_name   - USER folder name
%   setup       - structure containing common setup paramenters
%   daq         - structure containing data contained in the DAQ file
%   pvd         - structure containing data contained in the PVD file
%
% Please make sure that the DAQfilemex.mexw32 and the PCEvarfilemex.mexw32
% files are in the MATLAB path. These files are under the EXE folder of 
% your CAPS directory
%
% Also make sure the MATLAB function importCAPSData3.m is in the MATLAB
% path.
%

% Created 2015-Dec-23 by Emily Seyforth 
% Modified:
%   2016-04-29 EAS  Fixed bug for ensuring files do not get converted and
%                   saved over already converted MAT files unless user 
%                   specifies
%   2016-10-10 EAS  Modified so now will convert DAQ files saved in
%                   subfolders within DATA/DAQ. Minor adjustments to
%                   increase speed as well--Thanks Richard!
%

%% Check for input

start_dir='C:\'; %CAN MODIFY STARTING SEARCH DIRECTORY HERE TO MORE QUICKLY FIND DESIRED USER FOLDER

% if no input file is provide, ask the user to provide one
if nargin<1 || isempty(subjectpath)
%   **IF YOU WOULD LIKE TO SPECIFY A STARTING DIRECTORY TO CHOOSE A USER 
%   FOLDER, UNCOMMENT LINE BELOW- cd('') -AND ADD PATH BETWEEN SINGLE QUOTES**
%   cd('')
    subjectpath = uigetdir(start_dir,'Please Select CAPS USER Folder');
    assert(any(subjectpath~=0), 'No file was chosen.'); % confirm the file is valid
end

DAQpath = [subjectpath '\DATA\DAQ'];
MATpath = [subjectpath '\DATA\MAT'];


if exist(MATpath,'dir')==0 %check if MAT folder exists in user's data folder. If not make one and save all converted files
    mkdir(MATpath);
    save_override_check = 'Yes';
else                        %if folder does exist, check if user wants already converted trials rerun and saved over
    save_override_check= questdlg('A MAT folder already exists for the current user. If a converted DAQ trial already exists in this folder, would you like the current DAQ trial of the same name converted and saved over the original MAT conversion?', 'MAT Trial Save Override','Yes','No', 'Yes');
end

assert(logical(exist(subjectpath,'file')), 'File not found.'); % confirm the file exists
disp(['Retrieving ' subjectpath]);

%% Convert DAQ->MAT files
DAQfilenames = ls(DAQpath); % extract list of filenames from DAQ folder
DAQfilenames(1:2,:) = [];
numfiles = size(DAQfilenames,1);

MATfilenames = ls(MATpath); % extract list of file names in converted MAT file (if it exists)
MATfilenames(1:2,:) = [];

[~, UserName] = fileparts(subjectpath); %extract user name to be saved as variable in converted .mat file
    
for iDAQFile=1:numfiles(1) %Loop through files (or folders) in DATA/DAQ  
clearvars -except DAQfilenames MATfilenames subjectpath DAQpath MATpath save_override_check UserName numfiles iDAQFile;

MAT_file_check= 'No'; %Initialize flag for checking if DAQ file already has corresponding converted MAT file as 'No'

DAQExtensionStart= strfind(DAQfilenames(iDAQFile,:),'.'); %Separate '.DAQ' from DAQ filename list
DAQfilename_Extension= DAQfilenames(iDAQFile,DAQExtensionStart:DAQExtensionStart+3);
DAQfilename_NoExtension= DAQfilenames(iDAQFile,1:DAQExtensionStart-1);

    if strcmp(DAQfilename_Extension,'.DAQ') ==1   % Check file list is in .DAQ format  
        if size(MATfilenames,1)~=0 %Check if there are currently files in MAT folder
            for n=1:size(MATfilenames,1);
                MATExtensionStart= strfind(MATfilenames(n,:),'.'); %Next two lines used to remove '.MAT' from MAT filename list
                MATfilename_NoExtension= MATfilenames(n,1:MATExtensionStart-1);

                if strcmp(DAQfilename_NoExtension, MATfilename_NoExtension)==1 %If current DAQ file already has corresponding converted MAT file, mark as so
                    MAT_file_check= 'Yes';
                end
            end
        end
    
        if strcmp(MAT_file_check,'No')==1 || strcmp(save_override_check,'Yes')== 1 %check if converted MAT file already exists and if user wants all trials converted and saved
            filename= fullfile(DAQpath, DAQfilenames(iDAQFile,:));
            filename = deblank(filename);
            indx = find(filename == '\');
            file = filename(indx(end)+1:end-4);
            [settings, daq, pvd, f, daqUINT16] =  importCAPSData3(filename); %Generates MAT file from DAQ and/or PVD File(s)
            daq.daqUINT16 = daqUINT16;
    
            
            eval([file '.user_name = UserName;']); %Save Username, settings, DAQ data, and PVD data as structure in MAT folder using same name as original DAQ file name
            eval([file '.setup = settings;']);
            eval([file '.daq = daq;']);
            eval([file '.pvd = pvd;']);  
            matfile = fullfile(MATpath, [file '.mat']);
            save(matfile, file);
        
        end
    else % If items in DAQ folder are folders, individually open folder and convert each .DAQ file in that folder
        DAQ_subfolder_path = [DAQpath '\' deblank(DAQfilenames(iDAQFile,:))]; %Create path to DAQ subfolder
        DAQ_subfolder_filenames = ls(DAQ_subfolder_path); % Extract list of filenames from DAQ subfolder
        if strcmp(deblank(DAQ_subfolder_filenames(1,:)),'.')==1 % Remove '.' and '..' rows generated from using 'ls' command
            DAQ_subfolder_filenames(1,:) = [];
        end
        if strcmp(deblank(DAQ_subfolder_filenames(1,:)),'..')==1
            DAQ_subfolder_filenames(1,:) = [];
        end
        numfiles = size(DAQ_subfolder_filenames,1);
        
        MAT_subfolder_path = [MATpath '\' deblank(DAQfilenames(iDAQFile,:))]; %Create path to MAT subfolder using same name as DAQ subfolder
        if exist(MAT_subfolder_path,'dir')==0 
          mkdir(MAT_subfolder_path);
        end
        
        MAT_subfolder_filenames = ls(MAT_subfolder_path); % Extract list of file names in converted MAT subfolder (if it exists)
        if isempty(MAT_subfolder_filenames)~=1 %If not empty, remove '.' and '..' rows generated from using 'ls' command
            if strcmp(deblank(MAT_subfolder_filenames(1,:)),'.')==1
                MAT_subfolder_filenames(1,:) = [];
            end
            if strcmp(deblank(MAT_subfolder_filenames(1,:)),'..')==1
                MAT_subfolder_filenames(1,:) = [];
            end
        end

        for i_DAQSubfolderFile=1:numfiles(1)
            clearvars -except DAQfilenames MATfilenames subjectpath DAQpath MATpath save_override_check UserName numfiles iDAQFile i_DAQSubfolderFile DAQ_subfolder_path MAT_subfolder_path DAQ_subfolder_filenames MAT_subfolder_filenames;
            MAT_file_check= 'No';
    
            DAQExtensionStart= strfind(DAQ_subfolder_filenames(i_DAQSubfolderFile,:),'.'); %Next two lines used to remove '.DAQ' from DAQ filename list
            DAQfilename_NoExtension= DAQ_subfolder_filenames(i_DAQSubfolderFile,1:DAQExtensionStart-1);
    
            if size(MAT_subfolder_filenames,1)~=0 %Check if there are currently files in MAT folder
                for i_MATSubfolderFile=1:size(MAT_subfolder_filenames,1);
                    MATExtensionStart= strfind(MAT_subfolder_filenames(i_MATSubfolderFile,:),'.'); %Next two lines used to remove '.MAT' from MAT filename list
                    MATfilename_NoExtension= MAT_subfolder_filenames(i_MATSubfolderFile,1:MATExtensionStart-1);

                    if strcmp(DAQfilename_NoExtension, MATfilename_NoExtension)==1 %If current DAQ file already has corresponding converted MAT file, mark as so
                        MAT_file_check= 'Yes';
                        break;
                    end
                end
            end
    
            if strcmp(MAT_file_check,'No')==1 || strcmp(save_override_check,'Yes')== 1 %check if converted MAT file already exists and if user wants all trials converted and saved
                filename= fullfile(DAQ_subfolder_path, DAQ_subfolder_filenames(i_DAQSubfolderFile,:));
                filename = deblank(filename);
                indx = find(filename == '\');
                file = filename(indx(end)+1:end-4);
                [settings, daq, pvd, f, daqUINT16] =  importCAPSData3(filename);
                daq.daqUINT16 = daqUINT16;
    
                eval([file '.user_name = UserName;']); %Save Username, settings, DAQ data, and PVD data as structure in MAT subfolder using same filename and corresponding subfolder as original DAQ file
                eval([file '.setup = settings;']);
                eval([file '.daq = daq;']);
                eval([file '.pvd = pvd;']);
                matfile = fullfile(MAT_subfolder_path, [file '.mat']);
                save(matfile, file);
            end
        end
    end
end
end

