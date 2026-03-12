%% Load PFM vs iDC maximum responses
% To run, workspace should be R:\Vesper, Evan\Monkey DC eeVOR Data
close all

% TabExc = readtable("ExperimentRecords_62K_LA_CC1_Square_MaxiDCvsPFM_all_excitatory.csv");
TabExc = readtable("ExperimentRecords_62K_LP_CC1_Square_MaxiDCvsPFM_all_excitatory.csv");
TabInh = readtable("ExperimentRecords_62K_LA_CC1_Square_MaxiDCvsPFM_all_inhibitory.csv");

% TabExc = sort(TabExc, )

%% Extract data and do stats

dates = unique(TabExc.Date);
nDays = length(dates);

% rows (dim 1) - days
% columns (dim 2) - [iDC, 0 baseline PFM, 100 pps baseline PFM]
% dim 3 - [excitatory, inhibitory]
data = nan(nDays,3, 2);
sd = nan(nDays,3, 2);
n = nan(nDays,3, 2);
err = nan(nDays,3, 2);

for i = 1:nDays
    
    PFM0baseinds = TabExc.Date == dates(i) & TabExc.StimOffset == 0 & TabExc.Phase1Dur == 600 & strcmp(TabExc.StimType, 'PFM');
    data(i,1,1) = TabExc.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected(PFM0baseinds);
    sd(i,1,1) = TabExc.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected(PFM0baseinds);
    n(i,1,1) = TabExc.NumCyclesKeep(PFM0baseinds);
    err(i,1,1) = sd(i,1,1)/sqrt(n(i,1,1)); % SEM = SD/sqrt(n)

    PFM100baseinds = TabExc.Date == dates(i) & TabExc.StimOffset == 100 & TabExc.Phase1Dur == 600 &  strcmp(TabExc.StimType, 'PFM'); 
    data(i,2,1) = TabExc.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected(PFM100baseinds);
    sd(i,2,1) = TabExc.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected(PFM100baseinds);
    n(i,2,1) = TabExc.NumCyclesKeep(PFM100baseinds);
    err(i,2,1) = sd(i,2,1)/sqrt(n(i,2,1)); % SEM = SD/sqrt(n)

    iDCExcinds = TabExc.Date == dates(i) & TabExc.StimAmplitude1 == -800 & strcmp(TabExc.StimType, 'DC');
    data(i,3,1) = TabExc.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected(iDCExcinds);
    sd(i,3,1) = TabExc.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected(iDCExcinds);
    n(i,3,1) = TabExc.NumCyclesKeep(iDCExcinds);
    err(i,3,1) = sd(i,3,1)/sqrt(n(i,3,1)); % SEM = SD/sqrt(n)

    
    PFM0baseinds = TabInh.Date == dates(i) & TabInh.StimOffset == 0 & TabInh.Phase1Dur == 300 &  strcmp(TabInh.StimType, 'PFM');
    data(i,1,2) = TabInh.EyeVel_Magnitude_Anodic_avg_nystagmusCorrected(PFM0baseinds);
    sd(i,1,2) = TabInh.EyeVel_Magnitude_Anodic_std_nystagmusCorrected(PFM0baseinds);
    n(i,1,2) = TabExc.NumCyclesKeep(PFM0baseinds);
    err(i,1,2) = sd(i,1,2)/sqrt(n(i,1,2)); % SEM = SD/sqrt(n)

    PFM100baseinds = TabInh.Date == dates(i) & TabInh.StimOffset == 100 & TabInh.Phase1Dur == 300 & strcmp(TabInh.StimType, 'PFM');
    data(i,2,2) = TabInh.EyeVel_Magnitude_Anodic_avg_nystagmusCorrected(PFM100baseinds);
    sd(i,2,2) = TabInh.EyeVel_Magnitude_Anodic_std_nystagmusCorrected(PFM100baseinds);
    n(i,2,2) = TabExc.NumCyclesKeep(PFM100baseinds);
    err(i,2,2) = sd(i,2,2)/sqrt(n(i,2,2)); % SEM = SD/sqrt(n)

    iDCInhinds = TabInh.Date == dates(i) & strcmp(TabInh.StimType, 'DC');
    data(i,3,2) = TabInh.EyeVel_Magnitude_Anodic_avg_nystagmusCorrected(iDCInhinds);
    sd(i,3,2) = TabInh.EyeVel_Magnitude_Anodic_std_nystagmusCorrected(iDCInhinds);
    n(i,3,2) = TabExc.NumCyclesKeep(iDCInhinds);
    err(i,3,2) = sd(i,3,2)/sqrt(n(i,3,2)); % SEM = SD/sqrt(n)

end

% computing average and SEM across days using propagation of uncertainty
nTot = sum(n,1);
avgData = sum(data.*n,1)./nTot;
sdTot = sqrt(sum((data.^2 + sd.^2).*n,1)./nTot - avgData.^2);
semTot = sdTot./sqrt(nDays);

% Stats
% T test probably isn't valid here because the data is probably not
% normally distributed

% pfm baseline vs DC no baseline
[~, pval1, ci1, stats1] = ttest(data(:,2,1), data(:,3,1));

% pfm no baseline vs DC no baseline
[~, pval2, ci2, stats2] = ttest(data(:,1,1), data(:,3,1));

% pfm no baseline vs pfm baseline
[~, pval3, ci3, stats3] = ttest(data(:,1,1), data(:,2,1));

% inhibitory pfm baseline vs DC baseline
[~, pval4, ci4, stats4] = ttest(data(:,2,2), data(:,3,2));

aovExc = anova(data(:,:,1));
% aovInh = anova(data(:,[2 3],2));


%% Plot
xjitter = rand(nDays,1)*0.4 - 0.2;

f1 = clf(figure(1));
f1.Units = 'inches';
f1.Position = [1 1 5 4];
for i = 1:2
    ax = subplot(2,1,i);
    p1 = errorbar(xjitter + 1, data(:,1,i), err(:,1,i), err(:,1,i), '.', 'Color', [0.7 0.7 0.7], 'MarkerSize', 12);
    hold on
    p2 = errorbar(xjitter + 2, data(:,2,i), err(:,2,i), err(:,2,i), '.', 'Color', [0.5 0.5 0.5], 'MarkerSize', 12);
    p3 = errorbar(xjitter + 3, data(:,3,i), err(:,3,i), err(:,3,i), '.', 'Color', [0 0 0], 'MarkerSize', 12); 
    for j = 1:nDays
        p4 = plot((xjitter(j) + [1 2 3]), data(j,:,i), '--', 'Color', [0.7 0.7 0.7]);
    end

    errorbar(1, avgData(1,1,i), semTot(1,1,i), semTot(1,1,i), '.', 'Color', [0.7 0.7 0.7], 'MarkerSize', 20, 'LineWidth', 2)
    errorbar(2, avgData(1,2,i), semTot(1,2,i), semTot(1,2,i), '.', 'Color', [0.5 0.5 0.5], 'MarkerSize', 20, 'LineWidth', 2)
    errorbar(3, avgData(1,3,i), semTot(1,3,i), semTot(1,3,i), '.', 'Color', [0 0 0], 'MarkerSize', 20, 'LineWidth', 2)
    
    xlim([0.5 3.5])
    xticks([1 2 3])
    xticklabels({'PFM', 'PFM + baseline', 'DC'})
    xtickangle(45)

    ylabel(['Max Eye Velocity [', char(176), '/s]'])

    set(ax, 'FontSize', 8)
    box off

    if i == 1
        title('Excitatory')
        ylim([0 500])
    end
    
    if i == 2
        title('Inhibitory')
        legend(p3, ['Mean ',char(177),' SEM'], 'Location', 'northwest')
        % lgd = legend([p1 p2 p3], {'0 pps', '100 pps', '0 \muA'}, 'Location','west');
        % title(lgd, 'Baseline')
    end
end

savename = [date, '_MaxiDCvsPFM'];
saveloc = 'R:\Vesper, Evan\Monkey DC eeVOR Data\Summary Figures';
saveas(f1, [saveloc,filesep,savename], 'png')
saveas(f1, [saveloc,filesep,savename], 'fig')
saveas(f1, [saveloc,filesep,savename], 'svg')