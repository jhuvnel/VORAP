% plot central attenuation data

% USER INPUTS
% filepaths = {'R:\Vesper, Evan\Monkey DC eeVOR Data\20260224 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260224'} ;
% filepaths = {'R:\Vesper, Evan\Monkey DC eeVOR Data\20260403 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_PFM_CentralAttenuation_20260403.csv'} ;


%iDC
% filepaths = {'R:\Vesper, Evan\Monkey DC eeVOR Data\20260205 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260205.csv';... 
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260210 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260210.csv';...
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260218 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_CentralAttenuation_20260218.csv';...
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260220 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_CentralAttenuation_20260220.csv';...
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260223 Quin eeVOR + mechanical rotations\ExperimentRecords_62K_LA_CC1_Square_CentralAttenuation_20260223'};

%PFM
% filepaths = {'R:\Vesper, Evan\Monkey DC eeVOR Data\20260113 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_PFM_CentralAttenuation_20260113.csv';... 
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260115 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_PFM_CentralAttenuation_20260115.csv';...
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260121 Quin eeVOR\ExperimentRecords_62K_LA_CC1_CentralAttenuation_20260121.csv';...
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260123 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_PFM_CentralAttenuation_20260123.csv'};

%iDC Control
% filepaths = {'R:\Vesper, Evan\Monkey DC eeVOR Data\20260303 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260303.csv';...
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260227 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260227.csv'};

% %PFM Control
% filepaths = {'R:\Vesper, Evan\Monkey DC eeVOR Data\20260403 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_PFM_CentralAttenuation_20260403.csv';...
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260226 Quin eeVOR + mechanical rotations\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260226.csv';...
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260224 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260224.csv';...
%     'R:\Vesper, Evan\Monkey DC eeVOR Data\20260403 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_PFM_CentralAttenuation_20260403.csv'};

%iDC and PFM Control
filepaths = {'R:\Vesper, Evan\Monkey DC eeVOR Data\20260403 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_PFM_CentralAttenuation_20260403.csv';...
    'R:\Vesper, Evan\Monkey DC eeVOR Data\20260303 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260303.csv';...
    'R:\Vesper, Evan\Monkey DC eeVOR Data\20260227 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260227.csv';...
    'R:\Vesper, Evan\Monkey DC eeVOR Data\20260226 Quin eeVOR + mechanical rotations\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260226.csv';...
    'R:\Vesper, Evan\Monkey DC eeVOR Data\20260224 Quin eeVOR\ExperimentRecords_62K_LA_CC1_Square_iDC_CentralAttenuation_20260224.csv'};

metaData = [];
for iFile = 1:length(filepaths)
    loadData = readtable(filepaths{iFile});
    % if size(loadData,1) > 4
    %     loadData = loadData([1,8,end-8,end],:); % not all of the data are analyzed right now, this just looks at four sparse points
    % end
    if size(loadData,2) > 37
        loadData = loadData(:,1:37); % removing comments on data
    end
    metaData = [metaData; loadData];
end

dates_unique = unique(metaData.Date);
eyeVel = nan(27,length(dates_unique));
eyeVel_std = nan(27,length(dates_unique));
misalignment = nan(27,length(dates_unique));
misalignment_std = nan(27,length(dates_unique));
for iDate = 1:length(dates_unique)
    dataLen = length(metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected(metaData.Date == dates_unique(iDate)));
    eyeVel(1:dataLen,iDate) = metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected(metaData.Date == dates_unique(iDate));
    eyeVel_std(1:dataLen,iDate) = metaData.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected(metaData.Date == dates_unique(iDate));
    misalignment(1:dataLen,iDate) = metaData.EyeVel_Misalignment_Cathodic_avg_nystagmusCorrected(metaData.Date == dates_unique(iDate));
    misalignment_std(1:dataLen,iDate) = metaData.EyeVel_Misalignment_Cathodic_std_nystagmusCorrected(metaData.Date == dates_unique(iDate));
end

% dates_unique = unique(metaData.Date);
% for iDate = 1:length(dates_unique)
%     eyeVel(:,iDate) = metaData.EyeVel_Magnitude_Cathodic_avg(metaData.Date == dates_unique(iDate));
%     eyeVel_std(:,iDate) = metaData.EyeVel_Magnitude_Cathodic_std(metaData.Date == dates_unique(iDate));
%     misalignment(:,iDate) = metaData.EyeVel_Misalignment_Cathodic_avg(metaData.Date == dates_unique(iDate));
%     misalignment_std(:,iDate) = metaData.EyeVel_Misalignment_Cathodic_std(metaData.Date == dates_unique(iDate));
% end

markers = {'o','square','diamond','^','<','>','x','*'};

figure,
nexttile
hold on
for iDate = 1:length(dates_unique)
    errorbar(eyeVel(:,iDate),eyeVel_std(:,iDate),'-k','MarkerSize',7,'Marker',markers{iDate},'LineWidth',1)
end
ylabel('eye velocity (dps)')
title('Response to test stimuli over time - central attenuation experiment')
ylim([-5 400])
xlim([0 length(eyeVel(:,iDate)) + 1])
leg = legend(string(dates_unique),'Location','eastoutside');
title(leg,'Date:')
box off

nexttile
hold on
for iDate = 1:length(dates_unique)
    errorbar(misalignment(:,iDate),misalignment_std(:,iDate),'-k','MarkerSize',7,'Marker',markers{iDate},'LineWidth',1)
end
ylabel('misalignment (degs)')
xlabel('time (amount of activation delivered)')
xlim([0 length(eyeVel(:,iDate)) + 1])
ylim([-5 99])
box off


