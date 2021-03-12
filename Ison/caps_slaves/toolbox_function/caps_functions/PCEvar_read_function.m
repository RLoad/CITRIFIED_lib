function [data] = PCEvar_read_function(filename, pathname)
% Annie Simon
% read in PCE variable file recording
% Must add Matlab path C:\CapsV2\EXE. 
% See PCEvarfilemex.doc

cd(pathname);

variableList = PCEvarfilemex(10, filename);  
numvars = findstr(variableList,',');
k = 1;
for i = 1:size(numvars,2)
    var{i,:} = variableList(k:numvars(i)-1);
    k = numvars(i)+1;
end

i = i+1;
var{i,:} = variableList(k:end);

% initialize variables 
k = 0;

status = PCEvarfilemex(12);

while status ==0                % status = 0 if read is successful
                                % status = 9 if end of file was reached (file automatically closes)
                                % status = 143 if there was a read error
        k = k+1;
        
        for i = 1:size(var,1) 	% loop through each variable and append new frame of data
            try            
                eval(['data.' var{i} '(k,:)= PCEvarfilemex(8, var{i});']);
            catch
                eval(['data.' var{i} '(k,:,:)= PCEvarfilemex(8, var{i});']);
            end
        end
        
    status = PCEvarfilemex(12); % check for new status 
end

PCEvarfilemex(13);              % close file





 