function coilanalysis_plotrawdata(varargin)

% defaults
isSaved = 0; % don't save plots by default to avoid overwriting figures
saveType = '.png';
isPlotted = 1; % display figures by default
filt_window = 20; % moving mean filter window

switch nargin
    case 0
        filepath = uigetdir('title','Where is the Spike2 Files folder located?');
    otherwise
        for i = 1:nargin
            switch varargin{i}
                case char("FilePath")
                    filepath = varargin{i+1};
                case char("Save")
                    isSaved = varargin{i+1};
                case char("SaveType")
                    saveType = varargin{i+1};
                case char("DisplayFigures")
                    isPlotted = varargin{i+1};
                case char("FilterWindow")
                    filt_window = varargin{i+1};
            end
        end

end

segmentsPath = fullfile(filepath,'Segments');

dataPaths = {dir(fullfile(segmentsPath,'*.mat')).name}';
nFiles = length(dataPaths);

for iFile = 1:nFiles
    data_temp = load(fullfile(segmentsPath,dataPaths{iFile})).Data;

    filtLARP = movmean(data_temp.RE_Velocity_LARP,filt_window);
    filtRALP = movmean(data_temp.RE_Velocity_RALP,filt_window);
    filtZ = movmean(data_temp.RE_Velocity_Z,filt_window);

    if contains(dataPaths{iFile},'DCTrap') % stimulation with DC trapezoids

        waveformInfo = strsplit(dataPaths{iFile},{'_','x','+','ms'});
        nCycles = str2double(waveformInfo{8});
        phase1Dur_msec = str2double(waveformInfo{9});
        ipg_msec = str2double(waveformInfo{10});
        phase2Dur_msec = str2double(waveformInfo{11});
        stimGap_msec = str2double(waveformInfo{12});
        nRamps = str2double(waveformInfo{13});
        rampDur = str2double(waveformInfo{14});

        cycleLength_ms = phase1Dur_msec + ipg_msec + phase2Dur_msec + stimGap_msec + (nRamps * rampDur);

        plotRange_y = [-500 500];

        if nCycles > 40 % this means this is an adaptation file
            nCycles = 1;

            cycleLength_ms = length(filtZ);

            plotRange_y = [-100 100];
        end

    elseif contains(dataPaths{iFile},'PFMRamp')% stimulation with PFM trapezoids

        waveformInfo = strsplit(dataPaths{iFile},{'_','x','ms'});
        nCycles = str2double(waveformInfo{10});
        stimInterval = str2double(waveformInfo{11});

        cycleLength_ms = stimInterval;

        plotRange_y = [-500 500];

    elseif contains(dataPaths{iFile}, 'Adaptation') || ...
            contains(dataPaths{iFile}, 'Nystagmus') || ...
            contains(dataPaths{iFile}, 'Pulse') % PFM adaptation

        % no cycles, plot entire period of recording time
        nCycles = 1;

        cycleLength_ms = length(filtZ);

        plotRange_y = [-100 100];

    end

    eyeVelLARP_cycles = zeros(nCycles,cycleLength_ms);
    eyeVelRALP_cycles = zeros(nCycles,cycleLength_ms);
    eyeVelZ_cycles = zeros(nCycles,cycleLength_ms);

    for i = 1:nCycles
        eyeVelLARP_cycles(i,:) = filtLARP(((i-1)*cycleLength_ms)+1:(i*cycleLength_ms));
        eyeVelRALP_cycles(i,:) = filtRALP(((i-1)*cycleLength_ms)+1:(i*cycleLength_ms));
        eyeVelZ_cycles(i,:) = filtZ(((i-1)*cycleLength_ms)+1:(i*cycleLength_ms));
    end

    if isPlotted
        figure(iFile),
    else
        f = figure('Visible','off');
    end

    hold on

    p1 = plot(eyeVelLARP_cycles','g');
    p2 = plot(eyeVelRALP_cycles','b');
    p3 = plot(eyeVelZ_cycles','r');

    if contains(dataPaths{iFile},'DCTrap') % stimulation with DC trapezoids
        waveformInfo = strsplit(dataPaths{iFile},{'_','Offs','uA'});
        offset = str2double(waveformInfo{7});
        low_amp = offset + str2double(waveformInfo{4});
        high_amp = offset + str2double(waveformInfo{6});

        p4 = plot([interp1([1 50],[offset low_amp],[1:50],'linear'), ...
            repmat(low_amp,1,150), ...
            interp1([201 250],[low_amp offset],[201:250],'linear'), ...
            repmat(offset,1,750), ...
            interp1([1001 1050],[offset high_amp],[1001:1050],'linear'), ...
            repmat(high_amp,1,150), ...
            interp1([1201 1250],[high_amp offset],[1201:1250],'linear') ...
            repmat(offset,1,750), ...
            ],'color',[0.5 0.5 0.5 0.5],'LineWidth',1);
    elseif contains(dataPaths{iFile},'PFMRamp')% stimulation with PFM trapezoids
        if contains(waveformInfo,'Base')
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
    axis([0 cycleLength_ms plotRange_y])

    [~,figname] = fileparts(dataPaths{iFile});

    if isSaved
        % save both png and mat figures
        saveas(gcf,fullfile(filepath,'Figures',[figname,saveType]))
    end

    if ~isPlotted
        close(f)
    end

end

end