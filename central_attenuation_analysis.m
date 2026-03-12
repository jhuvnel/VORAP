%% Load and plot central attenuation data
close all

TabPulseCA = readtable('R:\Vesper, Evan\Monkey DC eeVOR Data\ExperimentRecords_62K_LH_PulseCentralAttenuation.csv');
TabPulseCARepeat = readtable('R:\Vesper, Evan\Monkey DC eeVOR Data\ExperimentRecords_62K_LH_PulseCentralAttenuationRepeat.csv');

TabiDCCA = readtable('R:\Vesper, Evan\Monkey DC eeVOR Data\ExperimentRecords_62K_LH_iDCCentralAttenuation.csv');
TabiDCCARepeat = readtable('R:\Vesper, Evan\Monkey DC eeVOR Data\ExperimentRecords_62K_LH_iDCCentralAttenuationRepeat.csv');

%% plot

TabOut = getCAData(TabPulseCA);
f1 = plotCAData(TabOut,1);
sgtitle('Pulse Activation')

TabOut = getCAData(TabiDCCA);
f2 = plotCAData(TabOut,1);
sgtitle('Cathodic iDC Activation')

TabOut = getCAData(TabPulseCARepeat);
f3 = plotCAData(TabOut,1);
sgtitle('Pulse Activation repeats')

TabOut = getCAData(TabiDCCARepeat);
f4 = plotCAData(TabOut,1);
sgtitle('Cathodic iDC Activation repeats')

% plot normalized data
TabOut = getCAData(TabPulseCA);
f5 = plotCAData(TabOut,2);
sgtitle('Pulse Activation')

TabOut = getCAData(TabiDCCA);
f6 = plotCAData(TabOut,2);
sgtitle('Cathodic iDC Activation')

TabOut = getCAData(TabPulseCARepeat);
f7 = plotCAData(TabOut,2);
sgtitle('Pulse Activation repeats')

TabOut = getCAData(TabiDCCARepeat);
f8 = plotCAData(TabOut,2);
sgtitle('Cathodic iDC Activation repeats')
%% function definitions

function fig = plotCAData(DataTab,PlotOpt)

    dates = unique(DataTab.Date);
    timepoints = {'30 min pre','20 min pre','10 min pre','pre-activation',...
        'post-activation','10 min post','20 min post','30 min post',...
        '40 min post','50 min post','60 min post'};

    x = 1:length(timepoints);

    fig = figure;
    
    for i = 1:length(dates)
        ax1 = subplot(2,1,1);
        inds = DataTab.Date == dates(i) & matches(DataTab.StimType, 'DC');
        switch PlotOpt
            case 1 % plot max eye vel
                errorbar(x,DataTab.EyeVel_Magnitude_Cathodic_avg(inds),DataTab.EyeVel_Magnitude_Cathodic_std(inds),DataTab.EyeVel_Magnitude_Cathodic_std(inds));

            case 2 % normalize by pre-act response
                preAct = DataTab.EyeVel_Magnitude_Cathodic_avg(DataTab.Date == dates(i) & matches(DataTab.StimType, 'DC') & matches(DataTab.Timepoint,'pre-activation'));
                errorbar(x,DataTab.EyeVel_Magnitude_Cathodic_avg(inds)/preAct,DataTab.EyeVel_Magnitude_Cathodic_std(inds)/preAct,DataTab.EyeVel_Magnitude_Cathodic_std(inds)/preAct);
        end
        hold on

        ax2 = subplot(2,1,2);
        inds = DataTab.Date == dates(i) & matches(DataTab.StimType, 'PFM');
        % errorbar(x,DataTab.EyeVel_Magnitude_Cathodic_avg(inds),DataTab.EyeVel_Magnitude_Cathodic_std(inds),DataTab.EyeVel_Magnitude_Cathodic_std(inds));

        switch PlotOpt
            case 1 % plot max eye vel
                errorbar(x,DataTab.EyeVel_Magnitude_Cathodic_avg(inds),DataTab.EyeVel_Magnitude_Cathodic_std(inds),DataTab.EyeVel_Magnitude_Cathodic_std(inds));

            case 2 % normalize by pre-act response
                preAct = DataTab.EyeVel_Magnitude_Cathodic_avg(DataTab.Date == dates(i) & matches(DataTab.StimType, 'PFM') & matches(DataTab.Timepoint,'pre-activation'));
                errorbar(x,DataTab.EyeVel_Magnitude_Cathodic_avg(inds)/preAct,DataTab.EyeVel_Magnitude_Cathodic_std(inds)/preAct,DataTab.EyeVel_Magnitude_Cathodic_std(inds)/preAct);
        end
        hold on
        
    end
    

    
    subplot(2,1,1)
    xline(4.5,'k--')
    xticklabels(timepoints)
    title('iDC Test')
    legend(num2str(dates),'Location','southwest')

    subplot(2,1,2)
    xline(4.5,'k--')
    xticklabels(timepoints)
    
    title('Pulse Test')

    switch PlotOpt
        case 1
            ylim([ax1 ax2], [0 80])
            ylabel([ax1 ax2], 'Max Eye Vel. (dps)')
        case 2
            ylim([ax1 ax2], [0 1.5])
            ylabel([ax1 ax2], 'Normalized Max Eye Vel.')
    end

end

function TabOut = getCAData(TabIn)
    dates = unique(TabIn.Date);
    timepoints = {'30 min pre','20 min pre','10 min pre','pre-activation',...
        'post-activation','10 min post','20 min post','30 min post',...
        '40 min post','50 min post','60 min post'};
    varNames = {'Timepoint','Date','StimAxis','StimType',...
        'StimAmplitude1','StimAmplitude2','StimRate1',...
        'EyeVel_Magnitude_Cathodic_avg','EyeVel_Magnitude_Cathodic_std',...
        'EyeVel_Misalignment_Cathodic_avg','EyeVel_Misalignment_Cathodic_std'};
    
    TabOut = table('Size',[length(dates)*length(timepoints)*2, 11], ...
        'VariableTypes', {'char','double','char','char','double','double','double','double','double','double','double'} , ...
        'VariableNames', varNames);

    % TabOut = TabIn(1,:);
    % TabOut(1,:) = [];

    for i = 1:length(dates)
        for j = 1:length(timepoints)
            toInsert = TabIn(TabIn.Date == dates(i) & matches(TabIn.Timepoint,timepoints{j}) & matches(TabIn.StimType,'DC'),varNames);
            toInsert.Timepoint{1} = timepoints{j};
            toInsert.Date(1) = dates(i);
            toInsert.StimType{1} = 'DC';
            TabOut((i-1)*length(timepoints)+j,:) = toInsert;

        end
    end
    for i = 1:length(dates)
        for j = 1:length(timepoints)
            toInsert = TabIn(TabIn.Date == dates(i) & matches(TabIn.Timepoint,timepoints{j}) & matches(TabIn.StimType,'PFM'),varNames);
            toInsert.Timepoint{1} = timepoints{j};
            toInsert.Date(1) = dates(i);
            toInsert.StimType{1} = 'PFM';
            TabOut(length(dates)*length(timepoints)+(i-1)*length(timepoints)+j,:) = toInsert;

        end
    end
end