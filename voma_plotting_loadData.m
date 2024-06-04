function [allData, saveLocs] = voma_plotting_loadData(expType,M)

Monkeys = loadMonkeyData;
animalData = getfield(Monkeys, M, expType);

% load LARP data for monkey M, experiment type expType
cyclesFolder_LARP = fullfile(animalData.LARP,'Cycles\');

filePattern = fullfile(cyclesFolder_LARP, '*.mat');
saveLocs.LARP = {};
saveLocs.RALP = {};
saveLocs.LHRH = {};
fileCount = 0;
for i = 1:length(filePattern)
    if ~isfolder(cyclesFolder_LARP{i}) % check to make sure folder exists
        errorMessage = sprintf('Error: The following folder does not exist:\n%s', cyclesFolder_LARP{i});
        uiwait(warndlg(errorMessage));
    end
    matFiles = dir(filePattern{i});
    nFiles = length(matFiles);
    for k = 1:nFiles
        fileCount = fileCount + 1;
        baseFileName = matFiles(k).name;
        fullFileName = fullfile(cyclesFolder_LARP{i}, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        allData.LARP(fileCount) = load(fullFileName).Results;
    end

    % check to make sure there is a figures folder in each file location
    saveLocs.LARP = [saveLocs.LARP; repmat({fullfile(animalData.LARP{i},'Figures\')},nFiles,1)];
    if ~isfolder(saveLocs.LARP{end})
        errorMessage = sprintf('Error: The following folder does not exist:\n%s', saveLocs.LARP);
        uiwait(warndlg(errorMessage));
    end
end


% load RALP data for monkey M, experiment type expType
cyclesFolder_RALP = fullfile(animalData.RALP,'Cycles\');

filePattern = fullfile(cyclesFolder_RALP, '*.mat');
fileCount = 0;
for i = 1:length(filePattern)
    if ~isfolder(cyclesFolder_RALP{i}) % check to make sure folder exists
        errorMessage = sprintf('Error: The following folder does not exist:\n%s', cyclesFolder_RALP{i});
        uiwait(warndlg(errorMessage));
    end
    matFiles = dir(filePattern{i});
    nFiles = length(matFiles);
    for k = 1:nFiles
        fileCount = fileCount + 1;
        baseFileName = matFiles(k).name;
        fullFileName = fullfile(cyclesFolder_RALP{i}, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        allData.RALP(fileCount) = load(fullFileName).Results;
    end

    % check to make sure there is a figures folder in each file location
    saveLocs.RALP = [saveLocs.RALP; repmat({fullfile(animalData.RALP{i},'Figures\')},nFiles,1)];
    if ~isfolder(saveLocs.RALP{end})
        errorMessage = sprintf('Error: The following folder does not exist:\n%s', saveLocs.RALP);
        uiwait(warndlg(errorMessage));
    end
end

% load LHRH data for monkey M, experiment type expType
cyclesFolder_LHRH = fullfile(animalData.LHRH,'Cycles\');

filePattern = fullfile(cyclesFolder_LHRH, '*.mat');
fileCount = 0;
for i = 1:length(filePattern)
    if ~isfolder(cyclesFolder_LHRH{i}) % check to make sure folder exists
        errorMessage = sprintf('Error: The following folder does not exist:\n%s', cyclesFolder_LHRH{i});
        uiwait(warndlg(errorMessage));
    end
    matFiles = dir(filePattern{i});
    nFiles = length(matFiles);
    for k = 1:nFiles
        fileCount = fileCount + 1;
        baseFileName = matFiles(k).name;
        fullFileName = fullfile(cyclesFolder_LHRH{i}, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        allData.LHRH(fileCount) = load(fullFileName).Results;
    end

    % check to make sure there is a figures folder in each file location
    saveLocs.LHRH = [saveLocs.LHRH; repmat({fullfile(animalData.LHRH{i},'Figures\')},nFiles,1)];
    if ~isfolder(saveLocs.LHRH)
        errorMessage = sprintf('Error: The following folder does not exist:\n%s', saveLocs.LHRH);
        uiwait(warndlg(errorMessage));
    end
end

end