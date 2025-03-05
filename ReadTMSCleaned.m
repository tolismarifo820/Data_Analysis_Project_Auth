% Marifoglou Apostolos 10879
% Isidoros Tsaousis 10042

function [data] = ReadTMSCleaned()
    data = readtable('TMS.xlsx');

    data.Stimuli = str2double(data.Stimuli);
    data.Intensity = str2double(data.Intensity);
    data.Spike = str2double(data.Spike);
    data.Frequency = str2double(data.Frequency);
    data.CoilCode = str2double(data.CoilCode);
end

% Comments:Makes the data double type.