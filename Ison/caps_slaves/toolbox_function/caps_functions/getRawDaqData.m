function [A,sampRate] = getRawDaqData(FNAME)

    [frameSize, frameInc, numChannels, chanMatrix, sampRate] ...
        = DAQfilemex(10, FNAME);
    [outData, timepointsRead] ...
        = DAQfilemex(12, frameSize, numChannels);
    numpoi = timepointsRead;
    B = outData;
    count = 0;
    while (timepointsRead == frameSize)
        [timepointsRead > frameSize-frameInc+1];
        [outData, timepointsRead] ...
            = DAQfilemex(12, frameSize, numChannels);
        count = count+1;
        if (timepointsRead < frameSize-frameInc+1); break; end
        B = [B outData(:,frameSize-frameInc+1:timepointsRead)];
        numpoi = numpoi + timepointsRead;
    end
    DAQfilemex(13);
    numpoi;
    A = (double(B')-2^15)/2^16 * 10; % SCALE TO +/-5 VOLTS
