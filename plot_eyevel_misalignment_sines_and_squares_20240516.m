%% plot square wave responses
    
% filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240521 Pearl eeVOR\Cycles';
% 
% filename = 'ExperimentRecords_SquareWaves_20240521.csv';
% 
% metaData = readtable(fullfile(filepath,filename));


filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240417 Pearl eeVOR\Analyzed by KNM 20240516\Cycles';
filename = 'ExperimentRecords_SquareWaves.csv';
metaData = readtable(fullfile(filepath,filename));

expDate = metaData.Date;
stimOffset = metaData.StimOffset;
stimAmp_cathodic = metaData.StimAmplitude1;

eyeVel_anodic = metaData.EyeVel_Magnitude_Anodic_avg_nystagmusCorrected;
eyeVel_anodic_std = metaData.EyeVel_Magnitude_Anodic_std_nystagmusCorrected;
misalignment_anodic = metaData.EyeVel_Misalignment_Anodic_avg_nystagmusCorrected;
misalignment_anodic_std = metaData.EyeVel_Misalignment_Anodic_std_nystagmusCorrected;

eyeVel_cathodic = metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected;
eyeVel_cathodic_std = metaData.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected;
misalignment_cathodic = metaData.EyeVel_Misalignment_Cathodic_avg_nystagmusCorrected;
misalignment_cathodic_std = metaData.EyeVel_Misalignment_Cathodic_std_nystagmusCorrected;

stimOffset = string(metaData.StimOffset);
stimAmp_anodic = metaData.StimAmplitude2;

tested_baselines = unique(stimOffset);
count_anodic = 0;
count_cathodic = 0;
count_pfm = 0;
count_zero = 0;

% make sure eye velocity direction is correct for cathodic data
if any(misalignment_cathodic > 90)
    isOppositeDir = misalignment_cathodic > 90;
    eyeVel_temp = eyeVel_cathodic;
    eyeVel_temp(isOppositeDir) = -eyeVel_temp(isOppositeDir);
    eyeVel_cathodic = eyeVel_temp;
end

data_zeroDCBaseline = [];

for iBaseline = 1:length(tested_baselines)
    baseline_idx = strmatch(tested_baselines{iBaseline},stimOffset);
    thisBaseline = stimOffset{baseline_idx(1)};
    baseline_type = sum([~contains(thisBaseline,'-') && contains(thisBaseline,'uA'),... % check if stim is anodic
        contains(thisBaseline,'uA')]); % check if stim is PFM or iDC
    switch baseline_type
        case 2 % anodic stim
            if strmatch(thisBaseline,'0uA')

                uniqueExpDates = unique(expDate(baseline_idx));

                for iDate = 1:length(uniqueExpDates)
                    date_idx = find(expDate(baseline_idx) == uniqueExpDates(iDate));

                    newPlot_idx = baseline_idx(date_idx);
                    count_zero = count_zero + 1;

                    baselineVal = str2double(extractBefore(thisBaseline,'uA'));
                    currentModulation = [-(stimAmp_anodic(baseline_idx))/max(stimAmp_anodic(baseline_idx));...
                        (stimAmp_cathodic(baseline_idx))/min(stimAmp_cathodic(baseline_idx))...
                        ]*100;

                    data_zeroDCBaseline(:,:,count_zero) = [...
                        currentModulation,...
                        [stimAmp_anodic(baseline_idx)+baselineVal;stimAmp_cathodic(baseline_idx)+baselineVal],...
                        [-eyeVel_anodic(baseline_idx);eyeVel_cathodic(baseline_idx)],...
                        [eyeVel_anodic_std(baseline_idx);eyeVel_cathodic_std(baseline_idx)],...
                        [misalignment_anodic(baseline_idx);misalignment_cathodic(baseline_idx)],...
                        [misalignment_anodic_std(baseline_idx);misalignment_cathodic_std(baseline_idx)],...
                        [metaData.NumCyclesKeep(baseline_idx);metaData.NumCyclesKeep(baseline_idx)],...
                        ];

                    [~,sortIdx] = sort(data_zeroDCBaseline(:,1));
                    data_zeroDCBaseline(:,:) = data_zeroDCBaseline(sortIdx,:);
                    legend_txt_zeroBaselines{count_zero} = [thisBaseline,' (',num2str(uniqueExpDates(iDate)),')'];
                end
            else
                uniqueExpDates = unique(expDate(baseline_idx));

                for iDate = 1:length(uniqueExpDates)
                    date_idx = find(expDate(baseline_idx) == uniqueExpDates(iDate));

                    newPlot_idx = baseline_idx(date_idx);
                    count_anodic = count_anodic + 1;

                    baselineVal = str2double(extractBefore(thisBaseline,'uA'));
                    currentModulation = [-(stimAmp_anodic(baseline_idx))/max(stimAmp_anodic(baseline_idx));...
                        (stimAmp_cathodic(baseline_idx))/min(stimAmp_cathodic(baseline_idx))...
                        ]*100;

                    data_anodicBaselines(:,:,count_anodic) = [...
                        currentModulation,...
                        [stimAmp_anodic(baseline_idx)+baselineVal;stimAmp_cathodic(baseline_idx)+baselineVal],...
                        [-eyeVel_anodic(baseline_idx);eyeVel_cathodic(baseline_idx)],...
                        [eyeVel_anodic_std(baseline_idx);eyeVel_cathodic_std(baseline_idx)],...
                        [misalignment_anodic(baseline_idx);misalignment_cathodic(baseline_idx)],...
                        [misalignment_anodic_std(baseline_idx);misalignment_cathodic_std(baseline_idx)],...
                        [metaData.NumCyclesKeep(baseline_idx);metaData.NumCyclesKeep(baseline_idx)],...
                        ];

                    [~,sortIdx] = sort(data_anodicBaselines(:,1,count_anodic));
                    data_anodicBaselines(:,:,count_anodic) = data_anodicBaselines(sortIdx,:,count_anodic);

                    legend_txt_anodicBaselines{count_anodic} = [thisBaseline,' (',num2str(uniqueExpDates(iDate)),')'];
                end
            end
        case 1 % cathodic stim
            uniqueExpDates = unique(expDate(baseline_idx));

            for iDate = 1:length(uniqueExpDates)
                date_idx = find(expDate(baseline_idx) == uniqueExpDates(iDate));

                newPlot_idx = baseline_idx(date_idx);
                count_cathodic = count_cathodic + 1;

                baselineVal = str2double(extractBefore(thisBaseline,'uA'));
                currentModulation = [-(stimAmp_anodic(newPlot_idx))/max(stimAmp_anodic(newPlot_idx));...
                    (stimAmp_cathodic(newPlot_idx))/min(stimAmp_cathodic(newPlot_idx))...
                    ]*100;

                data_cathodicBaselines(:,:,count_cathodic) = [...
                    currentModulation,...
                    [stimAmp_anodic(newPlot_idx)+baselineVal;stimAmp_cathodic(newPlot_idx)+baselineVal],...
                    [-eyeVel_anodic(newPlot_idx);eyeVel_cathodic(newPlot_idx)],...
                    [eyeVel_anodic_std(newPlot_idx);eyeVel_cathodic_std(newPlot_idx)],...
                    [misalignment_anodic(newPlot_idx);misalignment_cathodic(newPlot_idx)],...
                    [misalignment_anodic_std(newPlot_idx);misalignment_cathodic_std(newPlot_idx)],...
                    [metaData.NumCyclesKeep(baseline_idx);metaData.NumCyclesKeep(baseline_idx)],...
                    ];

                [~,sortIdx] = sort(data_cathodicBaselines(:,1,count_cathodic));
                data_cathodicBaselines(:,:,count_cathodic) = data_cathodicBaselines(sortIdx,:,count_cathodic);

                legend_txt_cathodicBaselines{count_cathodic} = [thisBaseline,' (',num2str(uniqueExpDates(iDate)),')'];
            end
        case 0 % pfm stim

            uniqueExpDates = unique(expDate(baseline_idx));

            baselineVal = str2double(extractBefore(thisBaseline,'pps'));

            for iDate = 1:length(uniqueExpDates)
                date_idx = find(expDate(baseline_idx) == uniqueExpDates(iDate));

                newPlot_idx = baseline_idx(date_idx);

                count_pfm = count_pfm + 1;

                currentModulation = [-(baselineVal - stimAmp_anodic(newPlot_idx))/max(stimAmp_anodic(newPlot_idx));...
                    (stimAmp_cathodic(newPlot_idx)-baselineVal)/max(stimAmp_cathodic(newPlot_idx)-baselineVal)...
                    ]*100;

                data_PFMBaselines(:,:,count_pfm) = [...
                    currentModulation,...
                    [stimAmp_anodic(newPlot_idx);stimAmp_cathodic(newPlot_idx)],...
                    [-eyeVel_anodic(newPlot_idx);eyeVel_cathodic(newPlot_idx)],...
                    [eyeVel_anodic_std(newPlot_idx);eyeVel_cathodic_std(newPlot_idx)],...
                    [misalignment_anodic(newPlot_idx);misalignment_cathodic(newPlot_idx)],...
                    [misalignment_anodic_std(newPlot_idx);misalignment_cathodic_std(newPlot_idx)],...
                    [metaData.NumCyclesKeep(baseline_idx);metaData.NumCyclesKeep(baseline_idx)],...
                    ];

                [~,sortIdx] = sort(data_PFMBaselines(:,1,count_pfm));
                data_PFMBaselines(:,:,count_pfm) = data_PFMBaselines(sortIdx,:,count_pfm);

                legend_txt_PFMBaselines{count_pfm} = [thisBaseline,' (',num2str(uniqueExpDates(iDate)),')'];
            end
    end

end

% put data in order of baseline
[~,cathodicBaselines_sortidx] = sort(abs(str2double(extractBefore(legend_txt_cathodicBaselines,'uA'))),'desc');

data_cathodicBaselines = data_cathodicBaselines(:,:,cathodicBaselines_sortidx);

legend_txt_cathodicBaselines = legend_txt_cathodicBaselines(cathodicBaselines_sortidx);


figure,
tcl = tiledlayout(2,1,'TileSpacing','tight');

title(tcl,'trapezoidal eeVOR','square wave, 500ms plateau, 1500ms between stim')

% plot cathodic iDC baselines
nexttile,
hold on
for icathodicBaseline = 1:length(legend_txt_cathodicBaselines)
    p1(icathodicBaseline) = errorbar(data_cathodicBaselines(:,2,icathodicBaseline), ...
        data_cathodicBaselines(:,3,icathodicBaseline), ...
        data_cathodicBaselines(:,4,icathodicBaseline), ...
        '-','Marker','.','MarkerSize',12);
end
p1(icathodicBaseline + 1) = errorbar(data_zeroDCBaseline(:,2), ...
        data_zeroDCBaseline(:,3), ...
        data_zeroDCBaseline(:,4), ...
        '-','Marker','.','MarkerSize',12);
set(gca, 'ColorOrder', colormap(gray(5)))
xline(0,'-','Color',[0.5 0.5 0.5])
yline(0,'-','Color',[0.5 0.5 0.5])
ylabel('maximum eye velocity (dps)')
title('cathodic iDC','inhibition     excitation')
leg = legend([legend_txt_cathodicBaselines,legend_txt_zeroBaselines],'Location','north');
title(leg,'baselines:')
xticklabels({})
box off

% misalignment cathodic iDC
nexttile,
hold on
for icathodicBaseline = 1:length(legend_txt_cathodicBaselines)
    errorbar(data_cathodicBaselines(:,2,icathodicBaseline), ...
        data_cathodicBaselines(:,5,icathodicBaseline), ...
        data_cathodicBaselines(:,6,icathodicBaseline), ...
        '-','Marker','.','MarkerSize',12)
end
errorbar(data_zeroDCBaseline(:,2), ...
        data_zeroDCBaseline(:,5), ...
        data_zeroDCBaseline(:,6), ...
        '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
yline(90,'--','Color',[0.8 0.8 0.8])
xline(0,'-','Color',[0.5 0.5 0.5])
ylabel('misalignment (degs)')
xlabel('current (uA)')
ylim([0 200])
box off

%% plot sine wave responses

filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240417 Pearl eeVOR\Analyzed by KNM 20240516\Cycles';
filename = 'ExperimentRecords_SineAmplitudeSweep.csv';

metaData = readtable(fullfile(filepath,filename));



is25uAcath = contains(metaData.StimOffset,'-25uA');
is50uAcath = contains(metaData.StimOffset,'-50uA');
is75uAcath = contains(metaData.StimOffset,'-75uA');
is100uAcath = contains(metaData.StimOffset,'-100uA');
is100pps = contains(metaData.StimOffset,'100pps');
is0uAcath = ~is25uAcath & ~is50uAcath & ~is75uAcath & ~is100uAcath & ~is100pps;
is100uAcath = logical(contains(metaData.StimOffset,'-100uA') * 0);


stimAmp = str2double(extractBefore(metaData.StimAmplitude,'uA'));
eyeVel = [metaData.EyeVel_Magnitude_Cathodic_avg metaData.EyeVel_Magnitude_Anodic_avg];
eyeVel_std = [metaData.EyeVel_Magnitude_Cathodic_std metaData.EyeVel_Magnitude_Anodic_std];
misalignment = [metaData.EyeVel_Misalignment_Cathodic_avg metaData.EyeVel_Misalignment_Anodic_avg];
misalignment_std = [metaData.EyeVel_Misalignment_Cathodic_std metaData.EyeVel_Misalignment_Anodic_std];
eyeVel_nystagmusCorrected = [metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected metaData.EyeVel_Magnitude_Anodic_avg_nystagmusCorrected];
eyeVel_std_nystagmusCorrected = [metaData.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected metaData.EyeVel_Magnitude_Anodic_std_nystagmusCorrected];
misalignment_nystagmusCorrected = [metaData.EyeVel_Misalignment_Cathodic_avg_nystagmusCorrected metaData.EyeVel_Misalignment_Anodic_avg_nystagmusCorrected];
misalignment_std_nystagmusCorrected = [metaData.EyeVel_Misalignment_Cathodic_std_nystagmusCorrected metaData.EyeVel_Misalignment_Anodic_std_nystagmusCorrected];
baselines = {'0uA','-25uA','-50uA','-75uA','-100uA'};

cathodicData_amplitude = [stimAmp(is0uAcath) stimAmp(is25uAcath) stimAmp(is50uAcath) stimAmp(is75uAcath) stimAmp(is100uAcath)];
cathodicData_eyeVel = [eyeVel(is0uAcath,:) eyeVel(is25uAcath,:) eyeVel(is50uAcath,:) eyeVel(is75uAcath,:) eyeVel(is100uAcath,:)];
cathodicData_eyeVel_nystagmusCorrected = [eyeVel_nystagmusCorrected(is0uAcath,:) eyeVel_nystagmusCorrected(is25uAcath,:) eyeVel_nystagmusCorrected(is50uAcath,:) eyeVel_nystagmusCorrected(is75uAcath,:) eyeVel_nystagmusCorrected(is100uAcath,:)];
cathodicData_eyeVel_std = [eyeVel_std(is0uAcath,:) eyeVel_std(is25uAcath,:) eyeVel_std(is50uAcath,:) eyeVel_std(is75uAcath,:) eyeVel_std(is100uAcath,:)];
cathodicData_eyeVel_std_nystagmusCorrected = [eyeVel_std_nystagmusCorrected(is0uAcath,:) eyeVel_std_nystagmusCorrected(is25uAcath,:) eyeVel_std_nystagmusCorrected(is50uAcath,:) eyeVel_std_nystagmusCorrected(is75uAcath,:) eyeVel_std_nystagmusCorrected(is100uAcath,:)];
cathodicData_misalignment = [misalignment(is0uAcath,:) misalignment(is25uAcath,:) misalignment(is50uAcath,:) misalignment(is75uAcath,:) misalignment(is100uAcath,:)];
cathodicData_misalignment_nystagmusCorrected = [misalignment_nystagmusCorrected(is0uAcath,:) misalignment_nystagmusCorrected(is25uAcath,:) misalignment_nystagmusCorrected(is50uAcath,:) misalignment_nystagmusCorrected(is75uAcath,:) misalignment_nystagmusCorrected(is100uAcath,:)];
cathodicData_misalignment_std = [misalignment_std(is0uAcath,:) misalignment_std(is25uAcath,:) misalignment_std(is50uAcath,:) misalignment_std(is75uAcath,:) misalignment_std(is100uAcath,:)];
cathodicData_misalignment_std_nystagmusCorrected = [misalignment_std_nystagmusCorrected(is0uAcath,:) misalignment_std_nystagmusCorrected(is25uAcath,:) misalignment_std_nystagmusCorrected(is50uAcath,:) misalignment_std_nystagmusCorrected(is75uAcath,:) misalignment_std_nystagmusCorrected(is100uAcath,:)];

% plot cathodic iDC
nexttile(1),
stim_amps = [flip(cathodicData_amplitude') -cathodicData_amplitude'];
p2 = errorbar(stim_amps, ...
    [flip(-cathodicData_eyeVel_nystagmusCorrected(:,2:2:end)') cathodicData_eyeVel_nystagmusCorrected(:,1:2:end)'], ...
    [flip(cathodicData_eyeVel_std_nystagmusCorrected(:,2:2:end)') cathodicData_eyeVel_std_nystagmusCorrected(:,1:2:end)'],'Color','r');
leg = legend([p1 p2],[legend_txt_cathodicBaselines,legend_txt_zeroBaselines,'0uA sine (20240417)'],'Location','north');
title(leg,'baselines:')

% plot cathodic iDC misalignment
nexttile(2),
stim_amps = [flip(cathodicData_amplitude') -cathodicData_amplitude'];
errorbar(stim_amps, ...
    [flip(cathodicData_misalignment_nystagmusCorrected(:,2:2:end)') cathodicData_misalignment_nystagmusCorrected(:,1:2:end)'], ...
    [flip(cathodicData_misalignment_std_nystagmusCorrected(:,2:2:end)') cathodicData_misalignment_std_nystagmusCorrected(:,1:2:end)'],'Color','r')

%% normalized responses based on 0uA baseline responses
figure, 
hold on
for icathodicBaseline = 1:length(legend_txt_cathodicBaselines)
    data_cathodicBaselines_normalized(:,icathodicBaseline) = data_cathodicBaselines(:,3,icathodicBaseline)./ data_zeroDCBaseline(:,3);

    plot(data_cathodicBaselines(:,2,icathodicBaseline), ...
        data_cathodicBaselines_normalized(:,icathodicBaseline), ...
        '-','Marker','.','MarkerSize',12);
end
set(gca, 'ColorOrder', colormap(gray(5)))
yline(1,'-','Color',[0.5 0.5 0.5])
xline(0,'-','Color',[0.5 0.5 0.5])
ylabel('misalignment (degs)')
xlabel('current (uA)')
ylim([0 2])
box off
