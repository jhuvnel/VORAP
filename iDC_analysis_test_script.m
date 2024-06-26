


filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240418 Pearl eeVOR';
% isDC = 1;
% isAdaptation = 0;
% isNystagmus = 0;

%% segment files

expDate = regexp(filepath,'\d{8}','match','once');
foldernames = {dir(fullfile(filepath,'Spike2 Files')).name}';
foldernames(1:2) = [];
for iFolder = 1:length(foldernames)
    filenames = {dir(fullfile(filepath,'Spike2 Files',foldernames{iFolder},'*.smr')).name}';

    % if the animal is Pearl, the implant is on the left side and the eye coil is on the right
    if contains(filepath, 'Pearl') || contains(filepath, 'Long Trapz')
        animal = 'Pearl';
        implantSide = 'Left';
        eyeCoilSide = 'Right';

        expType = 'ElectricalOnly';
        lightCondition = 'Dark';
        stimType = 'Trapezoids';
    end

    if contains(filepath,'DCSine')
        animal = 'Pearl';
        implantSide = 'Left';
        eyeCoilSide = 'Right';

        expType = 'ElectricalOnly';
        lightCondition = 'Dark';
        stimType = 'Sinusoids';
    end

    stimCount = 0;

    for iFile = 1:length(filenames)
        fid = fopen(fullfile(filepath,'Spike2 Files',foldernames{iFolder},filenames{iFile}),'r');
        ChanList = SONChanList(fid);
        TChannel = SONChannelInfo(fid,1);
        [directional_X_raw,directional_X_meta] = SONGetChannel(fid,9);
        [directional_Y_raw,directional_Y_meta] = SONGetChannel(fid,10);
        [directional_Z_raw,directional_Z_meta] = SONGetChannel(fid,11);

        % There are three different stimulation timing markers that have been
        % used. We need to know which type of marker we should use to divide
        % the eye movement signal into trial cycles and potentially correct for
        % timing errors.

        % Note: this process should be used when there is not already a
        % stimulation waveform input to the CED. In that case, the waveform
        % itself should be used to divide the eye movement data.

        % channel 30 is text markers
        % channel 15 is teensy trigger
        % channel 22 is keithley phase marker
        stimFlag.String = [];
        stimFlag.Time = [];
        stimFlag.CycleTiming = [];
        if ~contains(foldernames{iFolder},'nystagmus') && ~contains(foldernames{iFolder},'adaptation')
            [stimTimingChan, stimTimingType] = getTimingMarkerInfo(expDate);
            TimingInfo_raw = [];
            [TextMarkerInfo_raw,h2] = SONGetChannel(fid,30);
            stimFlag.String = [char(TextMarkerInfo_raw.text)]';
            stimFlag.Time = TextMarkerInfo_raw.timings;

            % if it is a PFM file, there are two flags per stim
            if contains(filenames{iFile},'PFM')
                str = deblank(stimFlag.String(1:2:end,:));
                str2 = deblank(stimFlag.String(2:2:end,:));
                strIdx = strfind(str,' [');
                strIdx2 = strfind(str2,' [');
                stimFlag.String = [str(1:strIdx) str2(1:strIdx2-1)];
                stimFlag.Time = stimFlag.Time(2:2:end);
            end

            switch stimTimingType
                case 'TextMarker'
                    % use text markers and the number of cycles to find cycle timing
                    for iFlag = 1:length(stimFlag.Time)
                        cycleInfo = extract(stimFlag.String(iFlag,:), digitsPattern(1,3)+'x'+wildcardPattern(2,30)+'ms');
                        nCycles = str2double(extractBefore(cycleInfo, 'x'));
                        cycleLength = str2double(extractBetween(cycleInfo,'x','ms'))/1000;
                        waveformLength = nCycles*(cycleLength); % in s
                        startStim_t = stimFlag.Time(iFlag);
                        endStim_t = stimFlag.Time(iFlag) + waveformLength;
                        stimFlag.CycleTiming{iFlag,1} = [startStim_t:cycleLength:endStim_t-cycleLength]' - startStim_t;
                    end

                case 'TeensyTrig'

                case 'PhaseMarker'
                    [TimingInfo_raw,~] = SONGetChannel(fid,stimTimingChan);

                    flagsToBeRemoved = [];

                    % use keithley phase markers to find cycle timing
                    for iFlag = 1:length(stimFlag.Time)
                        closest_start_t = interp1([0 TimingInfo_raw'],[0 TimingInfo_raw'],stimFlag.Time(iFlag),'nearest'); % need to add 0 here to interpolate values below TimingInfo_raw(1)
                        startStim_idx = find(TimingInfo_raw == closest_start_t);
                        cycleInfo = extract(stimFlag.String(iFlag,:), digitsPattern(1,3)+'x'+wildcardPattern(2,30)+'ms');
                        nCycles = str2double(extractBefore(cycleInfo, 'x'));
                        cycleLengthInfo = str2double(split(extractBetween(cycleInfo,'x','ms'),{'/','+','*'}));
                        if contains(cycleInfo, '/') && contains(cycleInfo, '+')
                            cycleLengthInfo = vertcat(cycleLengthInfo(1:end-2),prod(cycleLengthInfo(end-1:end)));
                        elseif contains(cycleInfo, '/')
                            cycleLengthInfo = vertcat(4*cycleLengthInfo(1),2*cycleLengthInfo(2),2*cycleLengthInfo(3));;
                        end
                        cycleLength = sum(cycleLengthInfo)/1000;
                        waveformLength(iFlag) = nCycles*(cycleLength); % in s
                        % sometimes the spike2 file cuts off before
                        % stimulation is finished, so we will remove these
                        % files, otherwise stimFlag will be updated with
                        % the timing from the phase marker
                        if isempty(startStim_idx) || startStim_idx + nCycles - 1 > length(TimingInfo_raw)
                            flagsToBeRemoved = [flagsToBeRemoved iFlag];
                            stimFlag.CycleTiming{iFlag,1} = [];
                        else
                            stimFlag.CycleTiming{iFlag,1} = TimingInfo_raw(startStim_idx:startStim_idx + nCycles-1) - TimingInfo_raw(startStim_idx);
                            stimFlag.Time(iFlag) = closest_start_t;
                        end
                    end

                    stimFlag.String(flagsToBeRemoved,:) = [];
                    stimFlag.Time(flagsToBeRemoved) = [];
                    stimFlag.CycleTiming(flagsToBeRemoved) = [];
                    waveformLength(flagsToBeRemoved) = [];
            end

        else % is a nystagmus recording
            stimFlag.String = char('Nystagmus');
            stimFlag.Time = 0.001;
            stimFlag.CycleTiming{1} = [];
        end


        fclose(fid);

        % load eye coil field gains
        FieldGainFile = dir(fullfile(filepath,'*Gains*')).name;
        fieldgainname = fullfile(filepath, FieldGainFile);
        delimiter = '\t';
        formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

        fileID = fopen(fieldgainname,'r');

        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

        fclose(fileID);

        FieldGains = [dataArray{1:end-1}];

        % have no offsets with a test coil.
        coilzeros = [0 0 0 0 0 0 0 0 0 0 0 0];
        % This will use the first data point as a reference position
        ref = 0;
        % Apply a -pi/2 YAW reorientation of the raw data
        data_rot = 2;
        % Lasker Coil System data acquired using ONLY a CED and Spike 2 software
        DAQ_code = 3;
        OutputFormat = 1;
        Data_In = [];

        [d] = voma__processeyemovements(fullfile(filepath,'Spike2 Files',foldernames{iFolder},'\'),filenames{iFile},FieldGains,coilzeros,ref,data_rot,DAQ_code,OutputFormat,Data_In);

        Data.segment_code_version = 'iDC_analysis_test_script';
        Data.raw_filename = filenames{iFile};
        expRecords = struct([]);

        nStimFlags = size(stimFlag.String,1);

        for iStimFlag = 1:nStimFlags
            %         if contains(stimFlag.String(iStimFlag,:),'DCTrap') % stimulation with DC trapezoids
            %             stimType = 'DCTrap';
            %
            %             waveformInfo = strsplit(stimFlag.String(iStimFlag,:),{' ','/','x','+','*','ms'});
            %
            %             phase1Amp = str2num(waveformInfo{4});
            %             phase2Amp = str2num(waveformInfo{6});
            %             offset = str2num(waveformInfo{7}(5));
            %             nCycles = str2double(waveformInfo{8});
            %             phase1Dur_msec = str2double(waveformInfo{9});
            %             ipg_msec = str2double(waveformInfo{10});
            %             phase2Dur_msec = str2double(waveformInfo{11});
            %             stimGap_msec = str2double(waveformInfo{12});
            %             nRamps = str2double(waveformInfo{13});
            %             rampDur = str2double(waveformInfo{14});
            %
            %             waveformLength = nCycles * (phase1Dur_msec + ipg_msec + phase2Dur_msec ...
            %                 + stimGap_msec + (nRamps * rampDur))/1000;
            %
            %         elseif contains(stimFlag.String(iStimFlag,:),'DCSine')% stimulation with PFM trapezoids
            %             waveformInfo = strsplit(stimFlag.String(iStimFlag,:),{' ','Hz','x','uA','Amp','Offs','ms'});
            %
            %             frequency = str2double(waveformInfo{9});
            %             cycleLength = str2double(waveformInfo{8});
            %             sineAmp = str2double(waveformInfo{5});
            %             offset = str2double(waveformInfo{6});
            %             nCycles = str2double(waveformInfo{7});
            %
            %             waveformLength = nCycles * cycleLength/1000; % in s
            %
            %         elseif contains(stimFlag.String(iStimFlag,:),'PFMSine')% stimulation with PFM sines
            %             waveformInfo = strsplit(stimFlag.String(iStimFlag,:),{' ','Hz','x','uA','Amp','Offs','ms','Freq','Delta','pps'});
            %
            %             frequency = str2double(waveformInfo{10});
            %             cycleLength = str2double(waveformInfo{9});
            %             sineAmp = str2double(waveformInfo{5});
            %             offset = str2double(waveformInfo{11});
            %             nCycles = str2double(waveformInfo{8});
            %
            %             waveformLength = nCycles * cycleLength/1000; % in s
            %
            %         elseif contains(stimFlag.String(iStimFlag,:),{'PFMRamp','Pulse'})% stimulation with PFM trapezoids
            %             stimType = 'PFMTrap';
            %
            %             waveformInfo = strsplit(stimFlag.String(iStimFlag,:),{' ','/','x','ms','us','pps','uA','Amp',':','Base'});
            %             %             offset = str2num(waveformInfo{12});
            %             %             low_pps = waveformInfo{14};
            %             %             high_pps = waveformInfo{15};
            %
            %             %             if contains(stimFlag.String(iStimFlag,:),'SwpFalse') % upmodulation first
            %             %                 phase1Amp = str2num(waveformInfo{17});
            %             %                 phase2Amp = str2num(waveformInfo{16});
            %             %             else
            %             %                 phase1Amp = str2num(waveformInfo{16});
            %             %                 phase2Amp = str2num(waveformInfo{17});
            %             %             end
            %             %             offset = str2num(waveformInfo{14});
            %             %             nCycles = str2double(waveformInfo{12});
            %             %             phase1Dur_msec = str2double(waveformInfo{6});
            %             %             ipg_msec = str2double(waveformInfo{7});
            %             %             phase2Dur_msec = str2double(waveformInfo{8});
            %             %             stimGap_msec = str2double(waveformInfo{12});
            % %             nRamps = str2double(waveformInfo{13});
            % %             rampDur = str2double(waveformInfo{14});
            % %
            % %             waveformLength = nCycles * (phase1Dur_msec + ipg_msec + phase2Dur_msec ...
            % %                 + stimGap_msec + (nRamps * rampDur))/1000;
            %             if isAdaptation
            %                 waveformLength = length(d.LE_Pos_X)/1000 - stimFlag.Time(iStimFlag);
            %             else
            %                 waveformLength = 20*2;
            %             end
            %
            %         elseif contains(stimFlag.String(iStimFlag,:),{'Nystagmus'}) % is a nystagmus recording
            %             waveformLength = length(d.LE_Pos_X)/1000 - stimFlag.Time(iStimFlag);
            %         end


            Data.start_t = stimFlag.Time(iStimFlag) * 1000; % in ms
            Data.end_t = Data.start_t + (waveformLength(iStimFlag) * 1000); % in ms
            startStim = round(Data.start_t);
            endStim = round(Data.end_t);
            if endStim > length(d.LE_Pos_X)
                endStim = length(d.LE_Pos_X);
            end
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
            Data.CycleTiming = stimFlag.CycleTiming{iStimFlag};

            % save segment
            str = stimFlag.String(iStimFlag,:);
            stimFileName = strrep(strrep(strrep(strrep(strrep(str,' ','_'),'/','_'),'*','_'),':','_'),'.','p');
            
            % we do not want to accidentally rewrite the segment name if
            % there is no timestamp in the flag string, so give it a number
            if ~contains(stimFileName,'[') 
                savename = [deblank(stimFileName) '(1).mat'];
            else
                savename = [deblank(stimFileName) '.mat'];
            end
            fileCount = 1;
            while exist(fullfile(filepath,'Segments',foldernames{iFolder},savename),'file') == 2
                fileCount = fileCount + 1;
                savename = [deblank(stimFileName), '(', num2str(fileCount), ')', '.mat'];
            end

            % make a Segments folder if it doesn't already exist
            if ~isdir(fullfile(filepath,'Segments',foldernames{iFolder}))
                mkdir(fullfile(filepath,'Segments',foldernames{iFolder}))
            end

            % save the data
            save(fullfile(filepath,'Segments',foldernames{iFolder},savename),'Data')

            % experimental records
            stimE = str2double(stimFlag.String(iStimFlag,4));
            refE = str2double(stimFlag.String(iStimFlag,6));
            switch stimE
                case 1
                    if contains(animal,'P')
                        stimAxis = "LARP";
                    end
                case 2
                    if contains(animal,'P')
                        stimAxis = "LHRH";
                    end
                case 3
                    if contains(animal,'P')
                        stimAxis = "RALP";
                    end
                case 4 | 5
                    if contains(animal,'P')
                        stimAxis = "other";
                    end
            end
            switch refE
                case 4
                    refEType = 'CC';
                case 5
                    refEType = 'Distant';
            end

            %         expRecords(stimCount).File_Name = stimFileName;
            %         expRecords(stimCount).Date = expDate;
            %         expRecords(stimCount).Subject = animal;
            %         expRecords(stimCount).Implant = implantSide;
            %         expRecords(stimCount).Eye_Recorded = eyeCoilSide;
            %         expRecords(stimCount).Compression = [];
            %         expRecords(stimCount).Max_PR_pps = [];
            %         expRecords(stimCount).Baseline_pps = [];
            %         expRecords(stimCount).Function = strjoin({expType,lightCondition,stimType},'-');
            %         expRecords(stimCount).Mod_Canal = stimAxis;
            %         expRecords(stimCount).Mapping_Type = [];
            %         expRecords(stimCount).Frequency_Hz = 1/(waveformLength/nCycles);
            %         expRecords(stimCount).Max_Velocity_dps = [];
            %         expRecords(stimCount).Phase_degrees = [];
            %         expRecords(stimCount).Cycles = [];
            %         expRecords(stimCount).Phase_Direction = [];
            %         expRecords(stimCount).Notes = [];

            stimCount = stimCount + 1;
        end
    end
end
% expRecords_table = struct2table(expRecords);
% expRecordsName = input('please enter an experimental record name\n','s');
% selectedDir = uigetdir();
% save(fullfile(selectedDir, expRecordsName),'expRecords_table')

%%
segmentsPath = fullfile(filepath,'Segments');

dataPaths = {dir(fullfile(segmentsPath,'*.mat')).name}';
nFiles = length(dataPaths);

filt_window = 20;
close all
for iFile = 1:nFiles
    data_temp = load(fullfile(segmentsPath,dataPaths{iFile})).Data;

    filtLARP = movmean(data_temp.RE_Velocity_LARP,filt_window);
    filtRALP = movmean(data_temp.RE_Velocity_RALP,filt_window);
    filtZ = movmean(data_temp.RE_Velocity_Z,filt_window);

    waveformLength_ms = 150 + 750 + 150 ...
        + 750 + (4 * 50);

    for i = 1:20
        eyeVelLARP_cycles(i,:) = filtLARP(((i-1)*waveformLength_ms)+1:(i*waveformLength_ms));
        eyeVelRALP_cycles(i,:) = filtRALP(((i-1)*waveformLength_ms)+1:(i*waveformLength_ms));
        eyeVelZ_cycles(i,:) = filtZ(((i-1)*waveformLength_ms)+1:(i*waveformLength_ms));
    end

    %     figure,
    %     hold on
    %     plot(filtZ,'r')
    %     plot(filtLARP,'g')
    %     plot(filtRALP,'b')
    %     grid on
    if isAdaptation
        filt_window = 100;

        figure(iFile),
        hold on
        p1 = plot(filtLARP,'Color',[0 1 0 0.2],'LineWidth',0.5);
        p2 = plot(filtRALP,'Color',[0 0 1 0.2],'LineWidth',0.5);
        p3 = plot(filtZ,'Color',[1 0 0 0.2],'LineWidth',0.5);
        plot([0 length(filtZ)],[0 0],'--k')

        title_str = strrep(dataPaths{iFile}(1:end-4),'_',' ');
        title(title_str)
        ylabel('Eye Velocity (dps)')
        xlabel('time(ms)')
        legend({'LARP','RALP','Z','stim'})
        box off
        axis([0 length(filtZ) -100 100])

        [~,figname] = fileparts(dataPaths{iFile});

        % save both png and mat figures
        saveas(gcf,fullfile(filepath,'Figures',[figname,'.png']))
        saveas(gcf,fullfile(filepath,'Figures',figname))

    else
        figure(iFile),
        hold on

        p1 = plot(eyeVelLARP_cycles','g');
        p2 = plot(eyeVelRALP_cycles','b');
        p3 = plot(eyeVelZ_cycles','r');

        %     p1 = plot(eyeVelLARP_cycles','Color',[0 1 0 0.2],'LineWidth',0.5);
        %     p2 = plot(eyeVelRALP_cycles','Color',[0 0 1 0.2],'LineWidth',0.5);
        %     p3 = plot(eyeVelZ_cycles','Color',[1 0 0 0.2],'LineWidth',0.5);
        %
        %     plot(median(eyeVelLARP_cycles),'g','LineWidth',3);
        %     plot(median(eyeVelRALP_cycles),'b','LineWidth',3);
        %     plot(median(eyeVelZ_cycles),'r','LineWidth',3);


        if isDC
            waveformInfo = strsplit(dataPaths{iFile},{'_','Offs','uA'});
            offset = str2double(waveformInfo{7});
            low_amp = offset + str2double(waveformInfo{4});
            high_amp = offset + str2double(waveformInfo{6});
            waveform = [interp1([1 50],[offset low_amp],[1:50],'linear'), ...
                repmat(low_amp,1,150), ...
                interp1([201 250],[low_amp offset],[201:250],'linear'), ...
                repmat(offset,1,750), ...
                interp1([1001 1050],[offset high_amp],[1001:1050],'linear'), ...
                repmat(high_amp,1,150), ...
                interp1([1201 1250],[high_amp offset],[1201:1250],'linear') ...
                repmat(offset,1,750), ...
                ];

            p4 = plot(waveform,'color',[0.5 0.5 0.5 0.5],'LineWidth',1);
        else % is PFM

            if contains(dataPaths{iFile},'Base')
                waveformInfo = strsplit(dataPaths{iFile},{'_','pps','Base'});
                offset = str2double(waveformInfo{11});
                low_pps = str2double(waveformInfo{13});
                high_pps = str2double(waveformInfo{14});
            else
                offset = 0;
                low_pps = 0;
                high_pps = 420;
            end

            p4 = plot([interp1([1 50],[offset high_pps],[1:50],'linear'), ...
                repmat(high_pps,1,150), ...
                interp1([201 250],[high_pps offset],[201:250],'linear'), ...
                repmat(offset,1,750), ...
                interp1([1001 1050],[offset low_pps],[1001:1050],'linear'), ...
                repmat(low_pps,1,150), ...
                interp1([1201 1250],[low_pps offset],[1201:1250],'linear') ...
                repmat(offset,1,750), ...
                ],'color',[0.5 0.5 0.5 0.5],'LineWidth',1);
        end
        title_str = strrep(dataPaths{iFile}(1:end-4),'_',' ');
        title(title_str)
        ylabel('Eye Velocity (dps)')
        xlabel('time(ms)')
        legend([p1(1) p2(1) p3(1) p4],{'LARP','RALP','Z','stim'})
        box off
        %     axes([0 waveformLength_ms -500 500])

        [~,figname] = fileparts(dataPaths{iFile});

        % save both png and mat figures
        %     saveas(gcf,fullfile(filepath,'Figures',[figname,'.png']))
        %     saveas(gcf,fullfile(filepath,'Figures',figname))
    end
end

%% kmeans clustering



%%
x=double(d.RE_Vel_LARP)/(2^16/10)*directional_X_meta.scale+directional_X_meta.offset;
n=length(x);
t=Data.Time_Stim;
figure,
hold on
plot(stimFlag.Time,repmat(2000,1,length(stimFlag.Time)),'r*')
plot(t,Data.RE_Vel_LARP, 'g')
plot(t,Data.RE_Vel_RALP, 'b')
plot(t,Data.RE_Vel_Z, 'r')

t_start = round(stimFlag.Time(14)*1000);
t_end = round(stimFlag.Time(15)*1000);
figure,
hold on
plot(t(t_start:t_end),Data.RE_Vel_LARP(t_start:t_end), 'g')
plot(t(t_start:t_end),Data.RE_Vel_RALP(t_start:t_end), 'b')
plot(t(t_start:t_end),Data.RE_Vel_Z(t_start:t_end), 'r')

figure, plot(t(2:end), directional_X_raw)
hold on;
plot(stimFlag.Time,repmat(2000,1,length(stimFlag.Time)),'r*')


x=double(x_raw)/(2^16/10)*h.scale+h.offset;
n=length(x);
t=1e-6*(h.start+h.sampleinterval*double(0:(n-1))');  % us->s


% #cycles x P1D(ms) \ IPG(ms) \ P2D(ms) \ stim gap(ms) + #ramps * ramp duration(ms)