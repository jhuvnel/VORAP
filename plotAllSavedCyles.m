function plotAllSavedCyles(Data,varargin)

saveFile_bool = 0;
if nargin == 3
    for i = 1:nargin-2
        switch varargin{i}
            case "save"
                saveLoc = varargin{i+1};
                saveFile_bool = 1;
        end
    end
end

if ~saveFile_bool
    f1 = figure;
end

for iStim = 1:length(Data)
    if saveFile_bool
        f1 = figure('units','normalized','outerposition',[0 0 1 1]);
    else
        nexttile;
    end

    if contains(Data(iStim).name,'LHRH') % if LHRH data, the motion stim data needs to be reshaped
        Data(iStim).stim = reshape(Data(iStim).stim',1,[]);
    end

%     t_s = (1:length(Data(iStim).stim))./1000;
    t_s = (1:(size(Data(iStim).stim,1) * size(Data(iStim).stim,2)))./1000;
    
    hold on;
    % plot stim
%     plot(t_s,Data(iStim).stim, 'Color',[0.5 0.5 0.5],'LineWidth',2)
    plot(t_s,reshape(Data(iStim).stim',1,[]), 'Color',[0.5 0.5 0.5],'LineWidth',2)
    % plot data
    plot(t_s,reshape(Data(iStim).rz_cyc',1,[]),'r','LineWidth',2)
    plot(t_s,reshape(Data(iStim).rl_cyc',1,[]),'g','LineWidth',2)
    plot(t_s,reshape(Data(iStim).rr_cyc',1,[]),'b','LineWidth',2)

    splitStr = split(Data(iStim).name(1:end-4),'-');
    [animal, ~, expDate, animalCond, expType, lightCond, stimAxis, ...
        stimType, stimFreq, stimIntensity] = deal(splitStr{:});
    stimFreq = strrep(stimFreq,'p','.');
    
    [~,s] = title(['All Saved Cycles, ',strjoin({stimAxis,stimFreq,stimIntensity},', ')],...
        ['Date: ',strjoin({expDate,animalCond,expType,lightCond,stimType},', ')]);
    s.FontSize = 8;
    s.Color = [0.5 0.5 0.5];
    ylabel('Eye Velocity (dps)')
    xlabel('Time (s)')
    if iStim ==1
        legend('motion stim','LHRH','LARP','RALP','Location','northeastoutside')
    end

    if saveFile_bool
        saveName = Data(iStim).name(1:end-4);
        filename = [saveLoc{iStim},saveName,'_allSavedCycles'];
        baseFile_idx = find(isstrprop(saveLoc{iStim},'digit'));
        baseFilePath =  saveLoc{iStim}(1:baseFile_idx(end)+1);

        % create microtext annotation
        myBox = uicontrol(f1,'style','text');
        myBox.Units = 'normalized';
        myBox.Position = [0 -0.01 1 0.06];
        myBox.HorizontalAlignment = 'left';
        myBox.Max = 5;
        myBox.FontSize = 5.5;
        crtScript = 'Created using: 1. voma.m (VNEL Github\voma\), 2. plotAllSavedCycles.m (labdata\Mueller\VNEL\)';
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
end