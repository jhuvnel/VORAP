
for iFile = 1:4
    
    if iFile == 1
        clear all
        filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240417 Pearl eeVOR\Analyzed by KNM 20240516\Cycles';
        filename = 'ExperimentRecords_SquareWaves.csv';
        iFile = 1;
    elseif iFile == 2
        clear all
        filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240501 Pearl eeVOR\Analyzed by KNM 20240516\Cycles';
        filename = 'ExperimentRecords_SquareWaves.csv';
        iFile = 2;
    elseif iFile == 3
        clear all
        filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240222 Pearl DC and PFM baselines\Cycles';
        filename = 'ExperimentRecords_Trapezoids.csv';
        iFile = 3;
    else
        clear all
        filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240521 Pearl eeVOR\Cycles';
        filename = 'ExperimentRecords_SquareWaves_20240521.csv';
        iFile = 4;
    end



metaData = readtable(fullfile(filepath,filename));
% 
% filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240216 Pearl DC trapz with baseline amphetamines\Cycles';
% filename = 'ExperimentRecords_Trapezoids_20240408.csv';
% metaData = readtable(fullfile(filepath,filename));

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

stimOffset = metaData.StimOffset;
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
    baseline_type = sum([~contains(thisBaseline,'-'),... % check if stim is anodic
        contains(thisBaseline,'uA'),...
        ~contains(thisBaseline,'pps')]); % check if stim is PFM or iDC
    switch baseline_type
        case 3 % anodic stim
            if strmatch(thisBaseline,'0uA')

                uniqueExpDates = unique(expDate(baseline_idx));

                baselineVal = str2double(extractBefore(thisBaseline,'pps'));
%                 baselineVal = 0;

                for iDate = 1:length(uniqueExpDates)
                    date_idx = find(expDate(baseline_idx) == uniqueExpDates(iDate));

                    newPlot_idx = baseline_idx(date_idx);
                    count_zero = count_zero + 1;

                    baselineVal = str2double(extractBefore(thisBaseline,'uA'));
%                     baselineVal = 0;
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

                baselineVal = str2double(extractBefore(thisBaseline,'pps'));
%                 baselineVal = 0;

                for iDate = 1:length(uniqueExpDates)
                    date_idx = find(expDate(baseline_idx) == uniqueExpDates(iDate));

                    newPlot_idx = baseline_idx(date_idx);
                    count_anodic = count_anodic + 1;

                    baselineVal = str2double(extractBefore(thisBaseline,'uA'));
%                     baselineVal = 0;
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
        case 2 % cathodic stim
            uniqueExpDates = unique(expDate(baseline_idx));

            baselineVal = str2double(extractBefore(thisBaseline,'pps'));
%             baselineVal = 0;

            for iDate = 1:length(uniqueExpDates)
                date_idx = find(expDate(baseline_idx) == uniqueExpDates(iDate));

                newPlot_idx = baseline_idx(date_idx);
                count_cathodic = count_cathodic + 1;

                baselineVal = str2double(extractBefore(thisBaseline,'uA'));
%                 baselineVal = 0;
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
        case 1 % pfm stim

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

% put data in order baseline
[~,cathodicBaselines_sortidx] = sort(abs(str2double(extractBefore(legend_txt_cathodicBaselines,'uA'))),'desc');

data_cathodicBaselines = data_cathodicBaselines(:,:,cathodicBaselines_sortidx);

legend_txt_cathodicBaselines = legend_txt_cathodicBaselines(cathodicBaselines_sortidx);


figure,
tcl = tiledlayout(2,1,'TileSpacing','tight');
if iFile == 3
    title(tcl,'trapezoidal eeVOR','250ms stim, 150ms plateau, 750ms between stim')
else
    title(tcl,'trapezoidal eeVOR','square wave, 500ms plateau, 1500ms between stim')
end


% plot cathodic iDC baselines
nexttile,
hold on
for icathodicBaseline = 1:length(legend_txt_cathodicBaselines)
    errorbar(data_cathodicBaselines(:,1,icathodicBaseline), ...
        data_cathodicBaselines(:,3,icathodicBaseline), ...
        data_cathodicBaselines(:,4,icathodicBaseline), ...
        '-','Marker','.','MarkerSize',12)
end
errorbar(data_zeroDCBaseline(:,1), ...
        data_zeroDCBaseline(:,3), ...
        data_zeroDCBaseline(:,4), ...
        '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(size(data_cathodicBaselines,3)+2)))
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
    errorbar(data_cathodicBaselines(:,1,icathodicBaseline), ...
        data_cathodicBaselines(:,5,icathodicBaseline), ...
        data_cathodicBaselines(:,6,icathodicBaseline), ...
        '-','Marker','.','MarkerSize',12)
end
errorbar(data_zeroDCBaseline(:,1), ...
        data_zeroDCBaseline(:,5), ...
        data_zeroDCBaseline(:,6), ...
        '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(size(data_cathodicBaselines,3)+2)))
yline(90,'--','Color',[0.8 0.8 0.8])
xline(0,'-','Color',[0.5 0.5 0.5])
ylabel('misalignment (degs)')
xlabel('modulation (%)')
ylim([0 200])
box off


%%
figure,
tcl2 = tiledlayout(1,1,'TileSpacing','tight');
title(tcl2,'trapezoidal eeVOR','adapted baseline/zero baseline')

nexttile,
hold on
for icathodicBaseline = 1:length(legend_txt_cathodicBaselines)
    [~,idx_unique] = unique(data_cathodicBaselines(:,1,icathodicBaseline));
    data_cathodic = data_cathodicBaselines(idx_unique,:,icathodicBaseline);
    idx_zero = find(round(data_cathodic(:,1)) == 0);
    data_cathodic(idx_zero,:) = [];
    

    data_cathodicBaselines_normalized(:,icathodicBaseline) = data_cathodic(:,3)./ data_zeroDCBaseline(:,3);

    plot(data_cathodic(:,1), ...
        data_cathodicBaselines_normalized(:,icathodicBaseline), ...
        '-','Marker','.','MarkerSize',12);
end
plot(data_zeroDCBaseline(:,1), ...
        data_zeroDCBaseline(:,3)./data_zeroDCBaseline(:,3), ...
        '-','Marker','.','MarkerSize',12);
set(gca, 'ColorOrder', colormap(gray(5)))
yline(1,'-','Color',[0.5 0.5 0.5])
xline(0,'-','Color',[0.5 0.5 0.5])
ylabel('normalized eye velocity')
xlabel('modulation (%)')
box off
title('cathodic iDC','inhibition     excitation')
leg = legend([legend_txt_cathodicBaselines,legend_txt_zeroBaselines],'Location','north');
title(leg,'baselines:')

end