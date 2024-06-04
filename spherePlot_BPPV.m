% goals:
% (1) plot during motion stim (0.1Hz and 0.2Hz) at peak eye velocity
% (2) plot during nystagmus after motion stim
saveFile_bool = 0;

%% load data
% load responses during stim
expType = 'NormalVOR_BPPV';
M = 'P';
[allData, saveLoc_all] = voma_plotting_loadData(expType,M);

% load responses during nystagmus for LARP and RALP
dataLocs.LARP = [saveLoc_all.LARP{end}(1:end-9) '\Cycles After Stim'];
dataLocs.RALP = [saveLoc_all.RALP{end}(1:end-9) '\Cycles After Stim'];

filePattern = fullfile(dataLocs.LARP, '*.mat');
matFiles = dir(filePattern);
nFiles_LARP_nystagmus = length(matFiles);
fileCount = 0;
for iFile = 1:length(matFiles)
    fileCount = fileCount + 1;
    baseFileName = matFiles(iFile).name;
    fullFileName = fullfile(dataLocs.LARP, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    nystagmusData.LARP(fileCount) = load(fullFileName).Results;
end

filePattern = fullfile(dataLocs.RALP, '*.mat');
matFiles = dir(filePattern);
nFiles_RALP_nystagmus = length(matFiles);
fileCount = 0;
for iFile = 1:length(matFiles)
    fileCount = fileCount + 1;
    baseFileName = matFiles(iFile).name;
    fullFileName = fullfile(dataLocs.RALP, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    nystagmusData.RALP(fileCount) = load(fullFileName).Results;
end

saveLoc_nystagmus = [repmat({[saveLoc_all.LARP{end} 'After Stim\']},nFiles_LARP_nystagmus,1);...
    repmat({[saveLoc_all.RALP{end} 'After Stim\']},nFiles_RALP_nystagmus,1)];

%% plot all saved cycles for LARP and RALP, 0.1Hz and 0.2Hz, 100dps
isLowFreq_LARP = (contains({allData.LARP.name},'0p1') ...
    | contains({allData.LARP.name},'0p2')) ...
    & contains({allData.LARP.name},'100dps');

isLowFreq_RALP = (contains({allData.RALP.name},'0p1') ...
    | contains({allData.RALP.name},'0p2')) ...
    & contains({allData.RALP.name},'100dps');

lowFreqData = [allData.LARP(isLowFreq_LARP) allData.RALP(isLowFreq_RALP)];
saveLoc_lowFreq = [saveLoc_all.LARP(isLowFreq_LARP); saveLoc_all.RALP(isLowFreq_RALP)];

if saveFile_bool
    plotAllSavedCyles(lowFreqData,'save',saveLoc_lowFreq)
end

plotAllSavedCyles(allData.LARP(isLowFreq_LARP))
plotAllSavedCyles(allData.RALP(isLowFreq_RALP))

%% plot cycles that will be used for sphere plots
% first cycle
figure,
for iStim = 1:length(lowFreqData)
    cycleLength = length(lowFreqData(iStim).rl_cyc);
    nexttile;
    hold on;
    plot(1:cycleLength,lowFreqData(iStim).stim(1:cycleLength),'k','LineWidth',2)
    plot(1:cycleLength,lowFreqData(iStim).rz_cyc(1,:),'r','LineWidth',2)
    plot(1:cycleLength,lowFreqData(iStim).rl_cyc(1,:),'g','LineWidth',2)
    plot(1:cycleLength,lowFreqData(iStim).rr_cyc(1,:),'b','LineWidth',2)

    splitStr = split(lowFreqData(iStim).name(1:end-4),'-');
    [animal, ~, expDate, animalCond, expType, lightCond, stimAxis, ...
        stimType, stimFreq, stimIntensity] = deal(splitStr{:});
    stimFreq = strrep(stimFreq,'p','.');

    title(strjoin({stimAxis,stimFreq,stimIntensity},', '), ...
        ['Date: ',expDate])
    if iStim == 1
        legend('motion stim','LHRH','LARP','RALP','Location','northeastoutside')
    end
end
sgtitle('First Cycle')

% at plateau/second to last cycle
figure,
for iStim = 1:length(lowFreqData)
    cycleLength = length(lowFreqData(iStim).rl_cyc);
    nexttile;
    hold on;
    plot(1:cycleLength,lowFreqData(iStim).stim(1:cycleLength),'k','LineWidth',2)
    plot(1:cycleLength,lowFreqData(iStim).rz_cyc(end-1,:),'r','LineWidth',2)
    plot(1:cycleLength,lowFreqData(iStim).rl_cyc(end-1,:),'g','LineWidth',2)
    plot(1:cycleLength,lowFreqData(iStim).rr_cyc(end-1,:),'b','LineWidth',2)

    splitStr = split(lowFreqData(iStim).name(1:end-4),'-');
    [animal, ~, expDate, animalCond, expType, lightCond, stimAxis, ...
        stimType, stimFreq, stimIntensity] = deal(splitStr{:});
    stimFreq = strrep(stimFreq,'p','.');

    title(strjoin({stimAxis,stimFreq,stimIntensity},', '), ...
        ['Date: ',expDate])
    if iStim == 1
        legend('motion stim','LHRH','LARP','RALP','Location','northeastoutside')
    end
end
sgtitle('Second to Last Cycle')

%% sphere plots: plot eye velocity vectors during motion stim for peak and trough
vec_first_peak = cell(1,3);
vec_first_trough = cell(1,3);
vec_last_peak = cell(1,3);
vec_last_trough = cell(1,3);

if ~saveFile_bool % plot all on one panel if not saving, plot separately if saving
    figure('units','normalized','outerposition',[0 0 1 1]);
end
for iStim = 1:length(lowFreqData) % for each motion stim

    splitStr = split(lowFreqData(iStim).name(1:end-4),'-');
    [animal, ~, expDate, animalCond, expType, lightCond, stimAxis, ...
        stimType, stimFreq, stimIntensity] = deal(splitStr{:});
    stimFreq = strrep(stimFreq,'p','.');
    dps = str2double(stimIntensity(1:end-3));

    cycleLength = length(lowFreqData(iStim).rl_cyc);
    origin = [0,0,0];

    if stimAxis == char('LARP')
        plotColor = [[0.1,0.9,0.1];[0.5,0.7,0.5]];
    else
        plotColor = [[0.1,0.1,0.9];[0.5,0.5,0.7]];
    end

    % first cycle peak
    [~, peak_idx_temp] = max(lowFreqData(iStim).stim(1:cycleLength)) ;
    LHRH_componenet_first_peak_temp = lowFreqData(iStim).rz_cyc(1,peak_idx_temp);
    LARP_componenet_first_peak_temp = lowFreqData(iStim).rl_cyc(1,peak_idx_temp);
    RALP_component_first_peak_temp = lowFreqData(iStim).rr_cyc(1,peak_idx_temp);

    vec_temp = [LARP_componenet_first_peak_temp,...
        RALP_component_first_peak_temp,...
        LHRH_componenet_first_peak_temp];
    vec_mag_temp = sqrt(vec_temp(1)^2 + vec_temp(2)^2 + vec_temp(3)^2);
    vec_norm_temp = [origin; vec_temp]/vec_mag_temp;
    vec_first_peak{iStim} = (vec_mag_temp/dps + 1) * sign(vec_norm_temp) .* (abs(vec_norm_temp));

    % first cycle trough
    [~, trough_idx_temp] = min(lowFreqData(iStim).stim(1:cycleLength)) ;
    LHRH_componenet_first_trough_temp = lowFreqData(iStim).rz_cyc(1,trough_idx_temp);
    LARP_componenet_first_trough_temp = lowFreqData(iStim).rl_cyc(1,trough_idx_temp);
    RALP_component_first_trough_temp = lowFreqData(iStim).rr_cyc(1,trough_idx_temp);

    vec_temp = [LARP_componenet_first_trough_temp,...
        RALP_component_first_trough_temp,...
        LHRH_componenet_first_trough_temp];
    vec_mag_temp = sqrt(vec_temp(1)^2 + vec_temp(2)^2 + vec_temp(3)^2);
    vec_norm_temp = [origin; vec_temp]/vec_mag_temp;
    vec_first_trough{iStim} = (vec_mag_temp/dps + 1) * sign(vec_norm_temp) .* (abs(vec_norm_temp));

    % plateau cycle peak
    [~, peak_idx_temp] = max(lowFreqData(iStim).stim(end-2*cycleLength:end-cycleLength)); % second to last cycle
    LHRH_componenet_last_peak_temp = lowFreqData(iStim).rz_cyc(end-1,peak_idx_temp);
    LARP_componenet_last_peak_temp = lowFreqData(iStim).rl_cyc(end-1,peak_idx_temp);
    RALP_component_last_peak_temp = lowFreqData(iStim).rr_cyc(end-1,peak_idx_temp);

    vec_temp = [LARP_componenet_last_peak_temp,...
        RALP_component_last_peak_temp,...
        LHRH_componenet_last_peak_temp];
    vec_mag_temp = sqrt(vec_temp(1)^2 + vec_temp(2)^2 + vec_temp(3)^2);
    vec_norm_temp = [origin; vec_temp]/vec_mag_temp;
    vec_last_peak{iStim} = (vec_mag_temp/dps + 1) * sign(vec_norm_temp) .* (abs(vec_norm_temp));

    % plateau cycle trough
    [~, trough_idx_temp] = min(lowFreqData(iStim).stim(end-2*cycleLength:end-cycleLength)); % second to last cycle
    LHRH_componenet_last_trough_temp = lowFreqData(iStim).rz_cyc(end-1,trough_idx_temp);
    LARP_componenet_last_trough_temp = lowFreqData(iStim).rl_cyc(end-1,trough_idx_temp);
    RALP_component_last_trough_temp = lowFreqData(iStim).rr_cyc(end-1,trough_idx_temp);

    vec_temp = [LARP_componenet_last_trough_temp,...
        RALP_component_last_trough_temp,...
        LHRH_componenet_last_trough_temp];
    vec_mag_temp = sqrt(vec_temp(1)^2 + vec_temp(2)^2 + vec_temp(3)^2);
    vec_norm_temp = [origin; vec_temp]/vec_mag_temp;
    vec_last_trough{iStim} = (vec_mag_temp/dps + 1) * sign(vec_norm_temp) .* (abs(vec_norm_temp));

    % set up sphere with normal/expected LARP, RALP, and LHRH vectors
    if saveFile_bool
        f1 = figure('units','normalized','outerposition',[0 0 1 1]);
    else
        nexttile;
    end

    [x,y,z]=sphere();
    h = surf(x,y,z,'HandleVisibility','off');
    set(h,'FaceColor','white')
    if stimAxis == char('LARP') % rotate view of sphere for RALP and LARP
        view(175,-40)
    else
        view(95,-40)
    end
    axis('off')
    hold on;
    LHRH_component_normal = 2;
    LARP_component_normal = 2;
    RALP_component_normal = 2;
    vec_LHRH = [origin; [0,0,LHRH_component_normal]];
    vec_LARP = [origin; [LARP_component_normal,0,0]];
    vec_RALP = [origin; [0,RALP_component_normal,0]];
    plot3(vec_LHRH(:,1),vec_LHRH(:,2),vec_LHRH(:,3), ...
        'Color', [0.6350 0.0780 0.1840],'LineWidth',0.5,'DisplayName',['+LHRH, ',stimIntensity])
    plot3(vec_LARP(:,1),vec_LARP(:,2),vec_LARP(:,3), ...
        'Color', [0.4660 0.6740 0.1880],'LineWidth',0.5,'DisplayName',['+LARP, ',stimIntensity])
    plot3(vec_RALP(:,1),vec_RALP(:,2),vec_RALP(:,3), ...
        'Color', [0 0.4470 0.7410],'LineWidth',0.5,'DisplayName',['+RALP, ',stimIntensity])

    % add vectors for first
    plot3(vec_first_peak{iStim}(:,1),vec_first_peak{iStim}(:,2),vec_first_peak{iStim}(:,3), ...
        '-','Color',plotColor(1,:),'LineWidth',2,'DisplayName','first peak');
    plot3(vec_first_trough{iStim}(:,1),vec_first_trough{iStim}(:,2),vec_first_trough{iStim}(:,3), ...
        ':','Color',plotColor(1,:),'LineWidth',2,'DisplayName','first trough');

    % add vectors for last
    plot3(vec_last_peak{iStim}(:,1),vec_last_peak{iStim}(:,2),vec_last_peak{iStim}(:,3), ...
        '-','Color',plotColor(2,:),'LineWidth',2,'DisplayName','plateau peak');
    plot3(vec_last_trough{iStim}(:,1),vec_last_trough{iStim}(:,2),vec_last_trough{iStim}(:,3), ...
        ':','Color',plotColor(2,:),'LineWidth',2,'DisplayName','plateau trough');


    if saveFile_bool
        title(['Rotational Axes - Sinusoids, ',strjoin({stimAxis,stimFreq,stimIntensity},', ')], ...
            ['Date: ',expDate])
    else
        title(strjoin({stimAxis,stimFreq,stimIntensity},', '), ...
            ['Date: ',expDate])
    end
    legend
    %     legend(p_peak,{'first peak','plateau peak'})
    if saveFile_bool
        saveLoc = saveLoc_lowFreq{iStim};
        saveName = lowFreqData(iStim).name(1:end-4);
        baseFile_idx = find(isstrprop(saveLoc,'digit'));
        baseFilePath =  saveLoc(1:baseFile_idx(end)+1);
        filename = [saveLoc,saveName,'-rotationalAxesDuringSinusoids'];

        % create microtext annotation
        myBox = uicontrol(f1,'style','text');
        myBox.Units = 'normalized';
        myBox.Position = [0 -0.01 1 0.06];
        myBox.HorizontalAlignment = 'left';
        myBox.Max = 5;
        myBox.FontSize = 5.5;
        crtScript = 'Created using: 1. Coil_data_Segmenting.m (VNEL Github\Coil-Analysis\Data Segmenting\), 2. Voma_Processing.m (VNEL Github\Coil-Analysis\Cycle Analysis), 3. spherePlot_BPPV.m (labdata\Mueller\VNEL\)';
        animalTxt = ['   Animal: ',animal];
        dateTxt = ['   Plot created: ',char(datetime)];
        rawDataTxt = ['   Base Raw Files: ',baseFilePath];
        filenameTxt = ['   Figure Saved as: ',filename];
        myBox.String = [crtScript,animalTxt,dateTxt,rawDataTxt,filenameTxt];

        % save figure
        saveas(f1,filename,'png')
        close(f1)
    end
end
sgtitle('Rotational Axes - Sinusoids')

%% plot eye velocity vectors during nystagmus

% find low frequency stim
isLowFreq_nystagmus_LARP = contains({nystagmusData.LARP.name},'0p1Hz') | ...
    contains({nystagmusData.LARP.name},'0p2Hz');
isLowFreq_nystagmus_RALP = contains({nystagmusData.RALP.name},'0p1Hz') | ...
    contains({nystagmusData.RALP.name},'0p2Hz');
% lowFreqData_nystagmus = [nystagmusData.LARP(isLowFreq_nystagmus) nystagmusData.RALP(isLowFreq_nystagmus)];
lowFreqData_nystagmus = [nystagmusData.LARP(isLowFreq_nystagmus_LARP) nystagmusData.RALP(isLowFreq_nystagmus_RALP)];
lowFreqData_nystagmus = [nystagmusData.LARP nystagmusData.RALP];

% plot eye velocity over time
if saveFile_bool
    plotAllSavedCyles(lowFreqData_nystagmus,'save',saveLoc_nystagmus)
end
plotAllSavedCyles(lowFreqData_nystagmus)
% plotAllSavedCyles(nystagmusData.RALP(isLowFreq_nystagmus))

vec_nystagmus = cell(1,3);
if ~saveFile_bool
    figure,
    [x,y,z]=sphere();
    h = surf(x,y,z,'HandleVisibility','off');
    set(h,'FaceColor','white')
    view(225,30)
    axis('off')
    hold on;
    LHRH_component_normal = 2;
    LARP_component_normal = 2;
    RALP_component_normal = 2;
    vec_LHRH = [origin; [0,0,LHRH_component_normal]];
    vec_LARP = [origin; [LARP_component_normal,0,0]];
    vec_RALP = [origin; [0,RALP_component_normal,0]];
    plot3(vec_LHRH(:,1),vec_LHRH(:,2),vec_LHRH(:,3), ...
        'Color', [0.6350 0.0780 0.1840],'LineWidth',0.5,'DisplayName','+LHRH, 50dps')
    plot3(vec_LARP(:,1),vec_LARP(:,2),vec_LARP(:,3), ...
        'Color', [0.4660 0.6740 0.1880],'LineWidth',0.5,'DisplayName','+LARP, 50dps')
    plot3(vec_RALP(:,1),vec_RALP(:,2),vec_RALP(:,3), ...
        'Color', [0 0.4470 0.7410],'LineWidth',0.5,'DisplayName','+RALP, 50dps')
end
for iStim = 1:length(lowFreqData_nystagmus)
    if saveFile_bool
        f2 = figure('units','normalized','outerposition',[0 0 1 1]);
        [x,y,z]=sphere();
        h = surf(x,y,z,'HandleVisibility','off');
        set(h,'FaceColor','white')
        view(225,30)
        axis('off')
        hold on;
        LHRH_component_normal = 2;
        LARP_component_normal = 2;
        RALP_component_normal = 2;
        vec_LHRH = [origin; [0,0,LHRH_component_normal]];
        vec_LARP = [origin; [LARP_component_normal,0,0]];
        vec_RALP = [origin; [0,RALP_component_normal,0]];
        plot3(vec_LHRH(:,1),vec_LHRH(:,2),vec_LHRH(:,3), ...
            'Color', [0.6350 0.0780 0.1840],'LineWidth',0.5,'DisplayName','+LHRH, 50dps')
        plot3(vec_LARP(:,1),vec_LARP(:,2),vec_LARP(:,3), ...
            'Color', [0.4660 0.6740 0.1880],'LineWidth',0.5,'DisplayName','+LARP, 50dps')
        plot3(vec_RALP(:,1),vec_RALP(:,2),vec_RALP(:,3), ...
            'Color', [0 0.4470 0.7410],'LineWidth',0.5,'DisplayName','+RALP, 50dps')
    end

    splitStr = split(lowFreqData_nystagmus(iStim).name(1:end-4),'-');
    [animal, ~, expDate, animalCond, expType, lightCond, stimAxis, ...
        stimType, stimFreq, stimIntensity] = deal(splitStr{:});
    stimFreq = strrep(stimFreq,'p','.');
    %     dps = str2double(stimIntensity(1:end-3));
    dps = 50;

    cycleLength = length(lowFreqData_nystagmus(iStim).rl_cyc);
    origin = [0,0,0];

    plotColor = [[0.1,0.9,0.1];[0.3,0.9,0.3];[0.5,0.9,0.5];[0.7,0.9,0.7];...
        [0.1,0.1,0.9];[0.3,0.3,0.9]];

    if stimAxis == char('LARP')
        [~, peak_idx_temp] = max(abs(lowFreqData_nystagmus(iStim).rl_cyc(1,1000:end)));
        peak_idx_temp = peak_idx_temp + 999;
    else
        [~, peak_idx_temp] = max(abs(lowFreqData_nystagmus(iStim).rr_cyc(1,1000:end)));
        peak_idx_temp = peak_idx_temp + 999;
    end

    % right after stim (first cycle)
    LHRH_componenet_nystagmus_temp = lowFreqData_nystagmus(iStim).rz_cyc(1,peak_idx_temp);
    LARP_componenet_nystagmus_temp  = lowFreqData_nystagmus(iStim).rl_cyc(1,peak_idx_temp);
    RALP_component_nystagmus_temp  = lowFreqData_nystagmus(iStim).rr_cyc(1,peak_idx_temp);

    vec_temp = [LARP_componenet_nystagmus_temp ,...
        RALP_component_nystagmus_temp ,...
        LHRH_componenet_nystagmus_temp ];
    vec_mag_temp = sqrt(vec_temp(1)^2 + vec_temp(2)^2 + vec_temp(3)^2);
    vec_nystagmus_norm = [origin; vec_temp]/vec_mag_temp;

    vec_nystagmus{iStim} = (vec_mag_temp/dps + 1) * sign(vec_nystagmus_norm) .* (abs(vec_nystagmus_norm));

    % add vectors
    plot3(vec_nystagmus{iStim}(:,1),vec_nystagmus{iStim}(:,2),vec_nystagmus{iStim}(:,3), ...
        '-','Color',plotColor(iStim,:),'LineWidth',2,'DisplayName',[stimFreq,', ',stimIntensity,' stim']);

    title(['Rotational Axes - Nystagmus Peak, ',strjoin({stimAxis,stimFreq,stimIntensity},', ')], ...
        ['Date: ',expDate])
    legend

    if saveFile_bool
        saveLoc = saveLoc_nystagmus{iStim};
        saveName = lowFreqData(iStim).name(1:end-4);
        baseFile_idx = find(isstrprop(saveLoc,'digit'));
        baseFilePath =  saveLoc(1:baseFile_idx(end)+1);
        filename = [saveLoc,saveName,'-rotationalAxesDuringNystagmus'];

        % create microtext annotation
        myBox = uicontrol(f2,'style','text');
        myBox.Units = 'normalized';
        myBox.Position = [0 -0.01 1 0.06];
        myBox.HorizontalAlignment = 'left';
        myBox.Max = 5;
        myBox.FontSize = 5.5;
        crtScript = 'Created using: 1. Coil_data_Segmenting.m (VNEL Github\Coil-Analysis\Data Segmenting\), 2. Voma_Processing.m (VNEL Github\Coil-Analysis\Cycle Analysis), 3. spherePlot_BPPV.m (labdata\Mueller\VNEL\)';
        animalTxt = ['   Animal: ',animal];
        dateTxt = ['   Plot created: ',char(datetime)];
        rawDataTxt = ['   Base Raw Files: ',baseFilePath];
        filenameTxt = ['   Figure Saved as: ',filename];
        myBox.String = [crtScript,animalTxt,dateTxt,rawDataTxt,filenameTxt];

        % save figure
        saveas(f2,filename,'png')
        close(f2)
    end
end


%% plot all vectors over time (movie)