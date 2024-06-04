% user input
input_DPS = {'100'}; %dps to plot
myFolder = 'R:\Mueller\Monkey Data\Pearl\20231117\'; % Define your working folder

% load results
saveLoc = [myFolder, 'Figures\'];
cyclesFolder = [myFolder 'Cycles\'];
if ~isfolder(cyclesFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', cyclesFolder);
    uiwait(warndlg(errorMessage));
    return;
end
if ~isfolder(saveLoc)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', saveLoc);
    uiwait(warndlg(errorMessage));
    return;
end

allData = voma_plotting_loadData(cyclesFolder);

isDark = contains({allData(:).name},'Dark');
isLight = ~isDark;
lightCondition = {isDark};

for iDPS = 1:length(input_DPS)
    for iLightCond = 1:length(lightCondition)
        % plot cycle average, dark condition
        f1 = figure;
        f1.Position = [100   558   1700   420];
        t = tiledlayout(1,5);
        f2 = figure;
        f2.Position = [680   0   560   1000];
        t_allCycles = tiledlayout(5,1);
        idxFiles = 1:nFiles;
        for iFile = idxFiles(lightCondition{iLightCond})
            metaData = split(allData(iFile).name,'-'); % get exp conditions from file name
            metaData{9} = strrep(metaData{9},'p','.'); % replace p with . (written as 0p2Hz in file name)
            metaData{10} = metaData{10}(1:end-4); % remove ".mat"

            isSpecifiedDPS = contains(metaData{10},input_DPS(iDPS));

            if isSpecifiedDPS
                ax1 = nexttile(t);

                hold on
                allData(iFile).stim = reshape(allData(iFile).stim',1,[]) ;
                t_ms = 1:length(allData(iFile).rz_cycavg);
                shadedErrorBar(t_ms,allData(iFile).rz_cycavg,allData(iFile).rz_cycstd,'lineprops',{'r','LineWidth',2})
                shadedErrorBar(t_ms,allData(iFile).rl_cycavg,allData(iFile).rl_cycstd,'lineprops',{'g:','LineWidth',2})
                shadedErrorBar(t_ms,allData(iFile).rr_cycavg,allData(iFile).rr_cycstd,'lineprops',{'b--','LineWidth',2})
                plot(allData(iFile).stim(t_ms),'k','LineWidth',2)
                plot(allData(iFile).rz_cyc','Color',[1 0 0 0.3],'LineWidth',0.5)
                plot(allData(iFile).rl_cyc','Color',[0 1 0 0.3],'LineWidth',0.5)
                plot(allData(iFile).rr_cyc','Color',[0 0 1 0.3],'LineWidth',0.5)

                nCycles = mat2str(length(allData(iFile).cyclist));
                title([metaData{9}, ', n = ',nCycles])

                if tilenum(ax1) == 3
                    xlabel('Time (ms)')
                    legend({'','','','LHRH' ...
                        '','','','LARP' ...
                        '','','','RALP' ...
                        'Motion'},'Location','northoutside','Orientation','horizontal')
                end
                if tilenum(ax1) == 1
                    ylabel('Avg. Eye Velocity (dps)')
                end

                % plot all cycles
                ax2 = nexttile(t_allCycles);
                hold on 
                t_s = (1:length(allData(iFile).stim))./1000;
                plot(t_s,reshape(allData(iFile).rz_cyc',1,[]),'r','LineWidth',2)
                plot(t_s,reshape(allData(iFile).rl_cyc',1,[]),'g--','LineWidth',2)
                plot(t_s,reshape(allData(iFile).rr_cyc',1,[]),'b--','LineWidth',2)
                plot(t_s,allData(iFile).stim,'k','LineWidth',2)

                if tilenum(ax2) == 5
                    xlabel('Time (s)')
                end
                if tilenum(ax2) == 3
                    ylabel('Avg. Eye Velocity (dps)')
                end
                if tilenum(ax2) == 1
                    legend('Horizontal','LARP','RALP','Motion','Location','northoutside','Orientation','horizontal')
                end

                title([metaData{9}, ', n = ',nCycles])
            end
        end
    figureName = [metaData{4},' ',metaData{5},', ',metaData{6},', ',metaData{7},' ',metaData{8},', ',input_DPS{iDPS},'dps'];
    saveName = strrep(figureName,', ','-');
    saveName = strrep(saveName,' ','-');
    
    title(t,"Cycle Average",[metaData{4},' ',metaData{5},', ',metaData{6},' ,',metaData{7},' ',metaData{8},', ',input_DPS{iDPS},'dps'])
    filename = [saveLoc,saveName,'_cycleAverage'];
    saveas(f1,filename,'png')
    close(f1)

    title(t_allCycles,"All Saved Cycles",[metaData{4},' ',metaData{5},', ',metaData{6},' ,',metaData{7},' ',metaData{8},', ',input_DPS{iDPS},'dps'])
    filename = [saveLoc,saveName,'_allSavedCycles'];
    saveas(f2,filename,'png')
    close(f2)
    end
end

