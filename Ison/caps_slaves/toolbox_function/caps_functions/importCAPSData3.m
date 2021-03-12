function varargout = importCAPSData3(fileName)
% Import CAPS data into Matlab 
%   [settings, daq]             = importCAPSData(fileName.DAQ)
%   [settings, pvd]             = importCAPSData(fileName.PVD)
%   [settings, daq, pvd]        = importCAPSData
%   [settings, daq, pvd]        = importCAPSData(fileName.DAQ)
%   [settings, daq, pvd]        = importCAPSData(fileName.PVD)
%   [settings, daq, pvd, file]  = importCAPSData(fileName.PVD)
%   [settings, daq, pvd, file, daqUINT16]  = importCAPSData(fileName.DAQ)
%
% The function imports data from any combination of DAQ and PVD files. When
% given a file, it will automatically look for an associated DAQ/PVD file
% and import data from both. When an associated file is not found, data
% from only the provided file is imported into Matlab.
% 
% INPUTS:
%   fileName - CAPS (DAQ/PVD) file to import into Matlab; Optional. When
%              not provided, prompts the user to select a file.
%
% OUTPUTS:
%   settings    - structure containing common setup paramenters
%   daq         - structure containing data contained in the DAQ file
%   pvd         - structure containing data contained in the PVD file
%   file        - filename used for processing data
%   daqUINT16   - structure containing Unsigned Integer data in the DAQ file
%
% Please make sure that the DAQfilemex.mexw32 and the PCEvarfilemex.mexw32
% files are in the MATLAB path. These file is under the EXE folder of your
% CAPS directory.
% 
% This function also expects CAPS generated folder structure:
%   DAQ files in .\DAQ folder and PVD files in .\PVD folder.
%   
%
% See Also:
%   importDaqData, PCEvar_read_function, readVULegData
%

% Created 2012-Jan-17 by Venn Ravichandran 
% Based on importDaqData and PCEvar_read_function
% Modified:
%   2012-03-06 VJR  Added file as an optional 4th output parameter. This
%                   makes life easy when using readVULegData.m
%   2012-02-22 VJR  PVD files can now handle 2D variables better. (Thanks
%                   Annie!)
%   2012-01-18 VJR  Fixed a minor bug where PVD is not set to empty by
%                   default. (Thanks Annie!)
%                   Added varargout as the output to allow for different
%                   outputs depending on the file provided.
%                   Enforces CAPS folder structure.
%                   Collated all the common settings under the new return
%                   value SETTINGS.

%% check for input
% if no input file is provide, ask the user to provide one
if nargin<1 || isempty(fileName)
    [fileName, fPath] = uigetfile({'*.DAQ;*.PVD', 'CAPS files (*.DAQ, *.PVD)';...
        '*.DAQ', 'DAQ files (*.DAQ)';...
        '*.PVD', 'PVD files (*.PVD)'},...
        'Please select your CAPS file');
    assert(any(fileName~=0), 'No file was chosen.'); % confirm the file is valid
    fileName = fullfile(fPath, fileName);
end
assert(logical(exist(fileName,'file')), 'File not found.'); % confirm the file exists
disp(['Processing ' fileName]);

%% default outputs
% set the default outputs to empty
settings = [];
daq = [];
pvd = [];
fileNameOut = [];
daqUINT16 = [];


%% setup for processing both DAQ and PVD files
% create the appropriate file names to process both the DAQ and PVD files,
% when both are available, even when only one of them is provided
[fPath,fileName,ext] = fileparts(fileName);
daqFileName = [];
pvdFileName = [];
fileNameOut = fileName;

switch lower(ext)
    case '.pvd'
        pvdFileName = fullfile(fPath, [fileName ext]);
        if strcmpi(fPath(end-2:end), 'pvd')
            daqFileName = fullfile(fPath(1:end-3), 'DAQ', [fileName '.DAQ']);
        end
    case '.daq'
        daqFileName = fullfile(fPath, [fileName ext]);
        if strcmpi(fPath(end-2:end), 'daq')
            pvdFileName = fullfile(fPath(1:end-3), 'PVD', [fileName '.PVD']);
        end
    otherwise
        error('importCAPSData:BadFile', 'Unsupported file extension.\nPlease input only a DAQ/PVD file... or write your own function :P!');
end

%% import data from the DAQ file
if exist(daqFileName, 'file')
    [daq, settings.DAQ_FRAME, settings.DAQ_FRINC, settings.DAQ_SAMP, settings.numChannels, daqUINT16] = readDAQfile(daqFileName);
end

%% import data from the PVD file
if exist(pvdFileName, 'file')
    try
        % if DAQ file exists...
        pvd = readPVDfile(pvdFileName, settings.DAQ_FRINC, settings.DAQ_FRAME, settings.DAQ_SAMP);  % use DAQ's frame increment
    catch
        % if DAQ file doesn't exist... 
        [pvd, settings.DAQ_FRAME, settings.DAQ_FRINC, settings.DAQ_SAMP] = readPVDfile(pvdFileName); % use the frame increment value in the PVD file
    end
end

%% set the appropriate output(s)
if nargout >= 1
    varargout(1) = {settings};
end
if nargout == 2
    switch lower(ext)
        case '.pvd'
            varargout(2) = {pvd};
        case '.daq'
            varargout(2) = {daq};
    end
end
if nargout >= 3
    varargout(2) = {daq};
    varargout(3) = {pvd};
end
if nargout >=4
    varargout(4) = {fileNameOut};
end
if nargout >=5
    varargout(5) = {daqUINT16};
end

%% HELPER FUNCTIONS
function [daq, DAQ_FRAME, DAQ_FRINC, DAQ_SAMP, numChannels, daqUINT16] = readDAQfile(fileName)
% function to parse through a DAQ file

% open DAQ file and read the header
[DAQ_FRAME, DAQ_FRINC, numChannels, ~, DAQ_SAMP] = DAQfilemex(10, fileName);

% read the first frame
[outData, timepointsRead] = DAQfilemex(12, DAQ_FRAME, numChannels);
A = outData; % store the data from this frame

% read subsequent frames, if they exist
%
% Logic: Each time the DAQfilemex(12, ...) is called, it reads a frame
%        consisting of TIMEPOINTSREAD points of data. FRAMESIZE represents
%        the maximum number of data points one can read.
%        If 0<= TIMEPOINTSREAD < FRAMESIZE, there are no additional
%        frames to read. Since subsequent frames overlap, FRAMEINC is used
%        to represent the number of new points in the new frame.
%
while ( (timepointsRead == DAQ_FRAME) ) % not reached end of file
    % read next frame
    [outData, timepointsRead] = DAQfilemex(12, DAQ_FRAME, numChannels);
    if ( timepointsRead > (DAQ_FRAME-DAQ_FRINC) ) % this frame has additional data
        A = [A outData(:,(DAQ_FRAME-DAQ_FRINC+1):timepointsRead)]; % concatenate
    end
end

% close the DAQ file
DAQfilemex(13);
% if nargout>3
%     daq.rawData = double(A');
% end
daqUINT16 = A';
daq.DAQ_DATA = double(A') / (2^16 - 1) * 10 - 5; % Scale to +/-5 Volts appropriately
daq.t = (0:(size(A,2)-1))'/DAQ_SAMP;

function [pvd, pvdDAQ_FRAME, pvdDAQ_FRINC, pvdDAQ_SAMP] = readPVDfile(fileName, DAQ_FRINC, DAQ_FRAME, DAQ_SAMP)
% function to parse through a PVD file
% if DAQ_FRINC or any of the subsequent inputs are not provided, this
% function obtains them from the first frame

% get the variable names stored in the file
varList = PCEvarfilemex(10, fileName);
dummy = textscan(varList, '%s', 'delimiter', ',');
varList = dummy{1};

% variables to ignore (these variables are repeated for each frame and
% don't need to be stored for each single frame)
% varList = varList(~strcmpi(varList, 'FRAME_CNT')); % ignore FRAME_CNT's
varList = varList(~strcmpi(varList, 'DAQ_FRINC')); % ignore DAQ_FRINC's
varList = varList(~strcmpi(varList, 'DAQ_SAMP')); % ignore DAQ_SAMP's
varList = varList(~strcmpi(varList, 'DAQ_FRAME')); % ignore DAQ_FRAME's
nVars = length(varList);

% process the PVD file frame by frame
status = PCEvarfilemex(12); % check the status of the PCE file
frame = 0; % frame count
while status==0 % while there are more frames to be read
    frame = frame + 1; % increment frame number
    
    if frame==1 % if first frame, then store non-changing variables into the pvd structure
        %pvdFRAME_CNT = PCEvarfilemex(8, 'FRAME_CNT');
        pvdDAQ_FRINC = PCEvarfilemex(8, 'DAQ_FRINC');
        pvdDAQ_SAMP = PCEvarfilemex(8, 'DAQ_SAMP');
        pvdDAQ_FRAME = PCEvarfilemex(8, 'DAQ_FRAME');
        
        if nargin<2 || isempty(DAQ_FRINC)
            DAQ_FRINC = pvdDAQ_FRINC;
        else
            if DAQ_FRINC~=pvdDAQ_FRINC
                warning('importCAPSData:MismatchedFrameIncrement',...
                    ['The frame increments from the DAQ and the PVD are mismatched ('...
                        num2str(DAQ_FRINC) ', ' num2str(pvdDAQ_FRINC) ...
                        ').\nAssuming DAQ''s values and proceeding']);
            end
            if DAQ_FRAME~=pvdDAQ_FRAME || DAQ_FRINC~=pvdDAQ_FRINC || DAQ_SAMP~=pvdDAQ_SAMP
                warning('importCAPSData:MismatchedSettings',...
                    ['DAQ (1st column) and PVD (2nd column) files have mismatched parameters.\n'...
                      'Values from DAQ file are used in settings.']);
                disp(num2str([DAQ_FRAME pvdDAQ_FRAME; DAQ_FRINC pvdFRINC; DAQ_SAMP pvdDAQ_SAMP]));
            end                    
        end
        
    end
    
%     idx2Use = (frame-1)*DAQ_FRINC + (1:DAQ_FRINC); % index to where the data should be stored for this frame

    % variables that change value between frames
    for var = 1:nVars
        dummy = PCEvarfilemex(8, varList{var});
        try
            if size(dummy,1)==1 % row vector or scalar
                pvd.(varList{var})(frame,:)   = dummy; 
            elseif size(dummy,2)==1 % column vector
                pvd.(varList{var})(frame,:)   = dummy'; 
            else
                pvd.(varList{var})(frame, :,:) = dummy; 
            end
        catch
            PCEvarfilemex(13); % close the file to exit clean
            error('importCAPSData:readPVDvar', ['Error in reading PVD variable ' varList{var} '.\nUnknown format.']); % report unknown data format
        end
    end
    status = PCEvarfilemex(12); % attempt to get next frame
end

% close the PVD file
PCEvarfilemex(13);
