%% goals
% (1) plot all cycles for a given set of normal VOR data
% (2) plot cycle average for a given set of normal VOR data

%% user input
saveFile_bool = 1;
input_DPS = {'100'}; %dps to plot
lightConditions = {'Dark'};
expType = 'NormalVOR';
M = 'P';

%% (1) plot all saved cycles
[data, saveLocs] = voma_plotting_loadData(expType,M);
data_all = [data.LARP data.RALP data.LHRH];
saveLoc_all = [saveLocs.LARP; saveLocs.RALP; saveLocs.LHRH];

nFiles = length(data_all);
for iDPS = 1:length(input_DPS)
    for iLightCond = 1:length(lightConditions)
        for stimAxis = ['LARP';'RALP';'LHRH']'
            isToBePlotted = false(1,nFiles);
            isToBePlotted = contains({data_all.name},lightConditions{iLightCond}) ...
                & contains({data_all.name},[input_DPS{iDPS},'dps']) ...
                & contains({data_all.name},string(stimAxis'));
            if saveFile_bool
                plotAllSavedCyles(data_all(isToBePlotted),'save',saveLoc_all(isToBePlotted))
            end
            plotAllSavedCyles(data_all(isToBePlotted))
        end
    end
end

%% (2) plot cycle averages

for iDPS = 1:length(input_DPS)
    for iLightCond = 1:length(lightConditions)
        for stimAxis = ['LARP';'RALP';'LHRH']'
            isToBePlotted = contains({data_all.name},lightConditions{iLightCond}) ...
                & contains({data_all.name},[input_DPS{iDPS},'dps']) ...
                & contains({data_all.name},string(stimAxis'));
            if saveFile_bool
                plotCycleAverage(data_all(isToBePlotted),'save',saveLoc_all(isToBePlotted))
            end
            plotCycleAverage(data_all(isToBePlotted))
        end
    end
end
