function coilanalysis_segmenting(varargin)

% defaults
isNystagmus = 0;

switch nargin
    case 0
        filepath = uigetdir('title','Where is the Spike2 Files folder located?');
    otherwise
        for i = 1:nargin
            switch varargin{i}
                case "FilePath"
                    filepath = varargin{i+1};
                case "Nystagmus"
                    isNystagmus = varargin{i+1};
            end
        end

end
filenames = {dir(fullfile(filepath,'Spike2 Files','*.smr')).name}';

stimCount = 0;

for iFile = 1:length(filenames)
    fid = fopen(fullfile(filepath,'Spike2 Files',filenames{iFile}),'r');
    if ~isNystagmus
        [TextMark_raw,~] = SONGetChannel(fid,30);
        stimFlag.String = [char(TextMark_raw.text)]';
        stimFlag.Time = TextMark_raw.timings;
    else % is a nystagmus recording
        stimFlag.String = char('Nystagmus');
        stimFlag.Time = 0.001;
    end

    % if it is a PFM file, there are two flags per stim
    if contains(filenames{iFile},'PFM')
        str = deblank(stimFlag.String(1:2:end,:));
        str2 = deblank(stimFlag.String(2:2:end,:));
        strIdx = strfind(str,' [');
        strIdx2 = strfind(str2,' [');
        stimFlag.String = [str(1:strIdx) str2(1:strIdx2-1)];
        stimFlag.Time = stimFlag.Time(2:2:end);
    end

    fclose(fid);

    % load eye coil field gains
    FieldGainFile = dir(fullfile(filepath,'*Gains*')).name;
    fieldgainname = fullfile(filepath, FieldGainFile);
    delimiter = '\t';
    formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

    fileID = fopen(fieldgainname,'r');

    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, ...
        'EmptyValue' ,NaN, 'ReturnOnError', false);

    fclose(fileID);

    FieldGains = [dataArray{1:end-1}];

    % have no offsets with a test coil
    coilzeros = [0 0 0 0 0 0 0 0 0 0 0 0];
    % use the first data point as a reference position
    ref = 0;
    % Apply a -pi/2 YAW reorientation of the raw data
    data_rot = 2;
    % Lasker Coil System data acquired using ONLY a CED and Spike 2 software
    DAQ_code = 3;
    % output in fick coordinates
    OutputFormat = 1;
    Data_In = [];

    [d] = voma__processeyemovements(fullfile(filepath,'Spike2 Files','\'), ...
        filenames{iFile},FieldGains,coilzeros,ref,data_rot,DAQ_code, ...
        OutputFormat,Data_In);

    Data.segment_code_version = 'iDC_analysis_test_script';
    Data.raw_filename = filenames{iFile};

    nStimFlags = size(stimFlag.String,1);

    for iStimFlag = 1:nStimFlags
        if contains(stimFlag.String(iStimFlag,:),'DCTrap') % stimulation with DC trapezoids

            waveformInfo = strsplit(stimFlag.String(iStimFlag,:), ...
                {' ','/','x','+','*','ms'});
            nCycles = str2double(waveformInfo{8});
            phase1Dur_msec = str2double(waveformInfo{9});
            ipg_msec = str2double(waveformInfo{10});
            phase2Dur_msec = str2double(waveformInfo{11});
            stimGap_msec = str2double(waveformInfo{12});
            nRamps = str2double(waveformInfo{13});
            rampDur = str2double(waveformInfo{14});

            waveformLength = nCycles * (phase1Dur_msec + ipg_msec + phase2Dur_msec ...
                + stimGap_msec + (nRamps * rampDur))/1000;

        elseif contains(stimFlag.String(iStimFlag,:),'PFMRamp')% stimulation with PFM trapezoids

            waveformInfo = strsplit(stimFlag.String(iStimFlag,:), ...
                {' ','/','x','ms','us','pps','uA','Amp',':','Base'});
            nCycles = waveformInfo(10);
            stimInterval = waveformInfo(11);

            waveformLength = nCycles * stimInterval;

        elseif contains(stimFlag.String(iStimFlag,:),{'Nystagmus'}) ||... 
            contains(stimFlag.String(iStimFlag,:),{'Adaptation'}) % is a nystagmus or adaptation recording
            waveformLength = length(d.LE_Pos_X)/1000 - stimFlag.Time(iStimFlag);

        end

        Data.start_t = stimFlag.Time(iStimFlag);
        Data.end_t = Data.start_t + waveformLength;
        startStim = round(Data.start_t * 1000);
        endStim = round(Data.end_t * 1000);
        Data.LE_Position_X = d.LE_Pos_X(startStim:endStim);
        Data.LE_Position_Y = d.LE_Pos_Y(startStim:endStim);
        Data.LE_Position_Z = d.LE_Pos_Z(startStim:endStim);
        Data.LE_Velocity_X = d.LE_Vel_X(startStim:endStim);
        Data.LE_Velocity_Y = d.LE_Vel_Y(startStim:endStim);
        Data.LE_Velocity_LARP = d.LE_Vel_LARP(startStim:endStim);
        Data.LE_Velocity_RALP = d.LE_Vel_RALP(startStim:endStim);
        Data.LE_Velocity_Z = d.LE_Vel_Z(startStim:endStim);
        Data.RE_Position_X = d.RE_Pos_X(startStim:endStim);
        Data.RE_Position_Y = d.RE_Pos_Y(startStim:endStim);
        Data.RE_Position_Z = d.RE_Pos_Z(startStim:endStim);
        Data.RE_Velocity_X = d.RE_Vel_X(startStim:endStim);
        Data.RE_Velocity_Y = d.RE_Vel_Y(startStim:endStim);
        Data.RE_Velocity_LARP = d.RE_Vel_LARP(startStim:endStim);
        Data.RE_Velocity_RALP = d.RE_Vel_RALP(startStim:endStim);
        Data.RE_Velocity_Z = d.RE_Vel_Z(startStim:endStim);
        Data.Fs = d.Fs;
        fullfileLength = length(d.RE_Pos_X);
        timePoints = 1e-6*(Data.start_t + Data.Fs * double(0:(fullfileLength-1))'); % us->s
        Data.Time_Eye = timePoints(startStim:endStim);
        Data.Time_Stim = timePoints(startStim:endStim);
        Data.Stim_Trig = d.ElecStimTrig;
        fileLength = length(d.RE_Pos_X(startStim:endStim));
        Data.HeadMPUVel_X = zeros(fileLength,1);
        Data.HeadMPUVel_Y = zeros(fileLength,1);
        Data.HeadMPUVel_Z = zeros(fileLength,1);
        Data.HeadMPUAccel_X = zeros(fileLength,1);
        Data.HeadMPUAccel_Y = zeros(fileLength,1);
        Data.HeadMPUAccel_Z = zeros(fileLength,1);

        % save segment
        str = stimFlag.String(iStimFlag,:);
        stimFileName = strrep(strrep(strrep(strrep(strrep(str,' ','_'),'/','_'),'*','_'),':','_'),'.','');
        savename = [deblank(stimFileName) '.mat'];
        save(fullfile(filepath,'Segments', savename),'Data')

        stimCount = stimCount + 1;
    end
end

end