%%/*++%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	Name: divideBy2.m
%  
%	Description: This file contains a test script to be run as a 
%                slave process in the PCE for purely illustrative purposes
%
%                It should be placed as an "ADDAFTER" slave to the
%                BP_FILTER PCE step.
%
%                It takes the BP_DATA output frame data matrix and divides
%                even channels by 2, then replaces it in the PCE.  This should
%                produce a visible decrease in those channels' signal strength.
%
%                Because it is a script (and not a function), any required 
%                inputs are expected to exist already in the Matlab command
%                environment.  This is accomplished by adding them to the 
%                list of inputs to this process in the CAPS Slave Editor.
%
%                Variables created in this script that are to passed to later
%                PCE steps should be included as outputs from this process in
%                the CAPS Slave Editor.
%
%          NOTE: In addition to any additional inputs or outputs, proper 
%                execution requires the assignment of the following variables:
%                   - SLAVE_STATUS: where a non-0 value indicates and error has
%                                   occured, stopping the PCE.
%                   - SLAVE_MSG: where a non-empty string will be logged by 
%                                by the PCE.
%
%	Revision History:
%	Date	 Who Comments	
%	------- --- ---------------------------------------------------------------
%	090114  RLP Created
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--*/

% Default good return status to PCE

SLAVE_MSG = '';
SLAVE_STATUS = 0;

% Expected Input Variable BP_DATA

try
    BP_DATA(:,2) = BP_DATA(:,2) / 2;              % Attenuate Chan 2 Signal by half
    BP_DATA(:,4) = BP_DATA(:,4) / 2;              % Attenuate Chan 4 Signal by half
    BP_DATA(:,6) = BP_DATA(:,6) / 2;              % Attenuate Chan 6 Signal by half
catch
    SLAVE_STATUS = 1;                             % variable not there!  stop PCE looping.
    SLAVE_MSG = 'Unknown Slave input: BP_DATA';   % this will appear in the PCE log
end
