function [A, sRate, t, rawData] = importDaqData(fileName)
% import DAQ data (from CAPS) into Matlab
%
%   [A,sRate,t] = importDaqData(fileName)
%   [A,sRate,rawData] = importDaqData(fileName)
%
% INPUTS:
%   fileName - DAQ file to import into Matlab; Optional. When not provided,
%              prompts the user to select the file.
%
% OUTPUTS:
%   A        - matrix of DAQ data, where columns represent the channels.
%              The values are in +/-5 V range.
%   sRate    - sampling rate (Hz)
%   t        - time vector for the data
%   rawData  - matrix of DAQ data, without scaling to +/-5V; i.e., 16-bit
%              data, as recorded by CAN
%
% Please make sure that the DAQfilemex.mexw32 file is in the Matlab path.
% This file is under the EXE folder of your CAPS directory.
%
% See Also:
%   getRawDaqData
% 

% Modified by Venn Ravichandran from getRawDaqData.m by Annie Simon
%   2011-Nov-17. VJR. Exits cleanly when no file is selected.
%   2011-Sep-01. VJR. Added rawData as an output. This is useful when using
%                     the new digital IMU.
%   2011-Mar-03. VJR. Added a help section and commented out the file for
%                     readability.
%   2011-Mar-02. VJR. Fixed minor bug in scaling of the data from uint16 to
%                     +/- 5V.
%

%% check for input
fPath = '';
% if no input file is provide, ask the user to provide one
if nargin<1 || isempty(fileName)
    [fileName, fPath] = uigetfile('*.DAQ','Please select your DAQ file');
end

A=[]; sRate=[]; t=[]; rawData=[]; % initialize outputs
if fileName~=0 % if file was selected
fileName = fullfile(fPath, fileName);

%% import data

% open DAQ file and read the header
[frameSize, frameInc, numChannels, tmp, sRate] = DAQfilemex(10, fileName);

% read the first frame
[outData, timepointsRead] = DAQfilemex(12, frameSize, numChannels);
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
while ( (timepointsRead == frameSize) ) % not reached end of file
    % read next frame
    [outData, timepointsRead] = DAQfilemex(12, frameSize, numChannels);
    if ( timepointsRead > (frameSize-frameInc) ) % this frame has additional data
        A = [A outData(:,(frameSize-frameInc+1):timepointsRead)]; % concatenate
    end
end

% close the DAQ file
DAQfilemex(13);
if nargout>3
    rawData = double(A');
end
A = double(A') / (2^16 - 1) * 10 - 5; % Scale to +/-5 Volts appropriately
t = (0:(size(A,1)-1))'/sRate;

end