function a=writeESNtoYAML(esn, file, nForgetPoints, classNames)
%writeESNtoYAML Save ESN struct to YAML file
%   a = writeESNtoYAML(esn, file, nForgetPoints, classNames) writes the
%   relevant contents of the ESN struct to a YAML file given by the 'file'
%   input parameter (provide a full filename with .yaml extension and
%   path, e.g. './myfile.yaml'). The input 'classNames' should be a cell
%   array of size esn.nOutputUnits and contain the strings corresponding to
%   the output classes.
    function writeMatrix(fid, data, name)
        fprintf(fid, '%s', [name ': [']);
        d=full(data);
        for row=1:size(d,1)-1
            fprintf(fid, '%f, ', d(row,:));
        end
        fprintf(fid, '%f, ', d(end,1:end-1));
        fprintf(fid, '%f', d(end,end));
        fprintf(fid, '%s\n\n', ']');
    end
    function writeVector(fid, data, name)
        fprintf(fid, '%s', [name ': [']);
        d=full(data);
        for row=1:size(d,1)-1
            fprintf(fid, '%f, ', d(row));
        end
        fprintf(fid, '%f', d(end));
        fprintf(fid, '%s\n\n', ']');
    end
    fileID=fopen(file,'w');
    fprintf(fileID, '%s: %i\n\n', 'nForgetPoints', nForgetPoints);
    fprintf(fileID, '%s: %i\n\n', 'nInternalUnits', esn.nInternalUnits);
    fprintf(fileID, '%s: %i\n\n', 'nInputUnits', esn.nInputUnits);
    fprintf(fileID, '%s: %i\n\n', 'nOutputUnits', esn.nOutputUnits);
    fprintf(fileID, '%s', 'classNames: [');
    for name=1:length(classNames)-1
        fprintf(fileID, '%s, ', classNames{name});
    end
    fprintf(fileID, '%s\n\n', [classNames{end} ']']);
    writeMatrix(fileID, esn.internalWeights_UnitSR, 'internalWeights_UnitSR');
    fprintf(fileID, '%s: %i\n\n', 'nTotalUnits', esn.nTotalUnits);
    writeMatrix(fileID, esn.inputWeights, 'inputWeights');
    writeMatrix(fileID, esn.outputWeights, 'outputWeights');
    writeMatrix(fileID, esn.feedbackWeights, 'feedbackWeights');
    writeVector(fileID, esn.inputScaling, 'inputScaling');
    writeVector(fileID, esn.inputShift, 'inputShift');
    writeVector(fileID, esn.teacherScaling, 'teacherScaling');
    writeVector(fileID, esn.teacherShift, 'teacherShift');
    writeVector(fileID, esn.feedbackScaling, 'feedbackScaling');
    writeVector(fileID, esn.timeConstants, 'timeConstants');
    fprintf(fileID, '%s: %i\n\n', 'leakage', esn.leakage);
    writeMatrix(fileID, esn.internalWeights, 'internalWeights');
fclose(fileID);
a=1;
end