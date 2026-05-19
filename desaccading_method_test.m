
% this is a test script for removing saccades from coil traces using a "desaccading
% trace" - a component with a smaller response amplitude - to find time
% points where saccades should be removed for all traces

filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20260218 Quin eeVOR\20260218 Quin eeVOR excitatory\Cycles\LA central attenuation';
% filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20260123 Quin eeVOR\20260123 Quin eeVOR excitatory\Cycles\LA central attenuation';
dataPaths = {dir(fullfile(filepath,'*.mat')).name}';

filestoplot = dataPaths(contains(dataPaths,'200_'));
% filestoplot = dataPaths(contains(dataPaths,'_20x500_500_500_500'));

ind_temp = contains(filestoplot, 'K1S1R4_DCTrap-300_0_0_10x200_300_0_0_0_[14_11_43p502]_TrapezoidStim_cycles');
% ind_temp = contains(filestoplot, 'K1S1R4_DCTrap-300_0_0_10x200_300_0_0_0_[13_59_05p782]_TrapezoidStim_cycles');
% ind_temp = contains(filestoplot, 'K1_S1_R4_Pulse550_600_25_600_PFMRamp_10x0_200_50_0_K1_0_300_K2_0_0_False_[12_18_55p773]_TrapezoidStim_cycles');


data_temp = load(fullfile(filepath,filestoplot{ind_temp})).Data;

keepCycles = str2double(data_temp.KeepCycleNums);

lhrh = data_temp.RE_Velocity_Z(1:end-1);
ralp = data_temp.RE_Velocity_RALP(1:end-1);
larp = data_temp.RE_Velocity_LARP(1:end-1);
x = data_temp.RE_Velocity_X(1:end-1);
y = data_temp.RE_Velocity_Y(1:end-1);

% chosenTrace = voma__irlssmooth(larp,10);
chosenTrace = ralp;
stimOnTime = 1;
stimOffTime = 200;
QPlength = 50;
threshold = 8;

time = 1:length(chosenTrace);

trace_irls = voma__irlssmooth(chosenTrace,50);
trace_movmedian = movmedian(chosenTrace, 5);
trace_median = median(reshape(chosenTrace,500,[]),2);
% trace_diff = abs(reshape(chosenTrace,4000,[]) - trace_median);
trace_diff = abs(reshape(trace_movmedian,500,[]) - trace_median);


% alternative derivative-based strategy
trace_I = cat(1,0,diff(movmedian(chosenTrace,5)));
% figure, plot(chosenTrace)
% hold on
% plot(trace_I)

i = 0;
k = 0;
stimOnInds = [];
stimOffInds = [];
while i + 500 < length(chosenTrace)
    stimOnInds = [stimOnInds, [stimOnTime:20] + 500*(k)];
    stimOffInds = [stimOffInds, [stimOffTime:220] + 500*(k)];
    i = stimOnInds(end);
    k = k + 1;
end

trace_QPonly = trace_I;
trace_QPonly([stimOnInds stimOffInds]) = 0;
trace_diff = trace_I;

% figure, plot(chosenTrace)
% hold on
% plot(trace_QPonly)

%%
% figure, 
% plot(larp, 'color', 'g')
% hold on
% plot(ralp, 'color', 'b')
% plot(lhrh,'color','r')
% plot(trace_irls)

QPstart = find(abs(trace_QPonly) >= threshold) - 5;
QPend = QPstart + QPlength;
desacc_inds = [];
for iQP = 1:length(QPstart)
    temp = QPstart(iQP):QPend(iQP);
    desacc_inds = [desacc_inds temp];
end
desacc_inds = unique(desacc_inds);
desacc_inds = desacc_inds(desacc_inds <= length(chosenTrace));
desacc_bool = false(length(chosenTrace),1);
desacc_bool(desacc_inds) = 1;
% desacc_inds = find(trace_diff >= threshold);
% desacc_inds = unique([find(trace_diff >= threshold), find(trace_diff >= threshold) + 1, find(trace_diff >= threshold) - 1]);
% desacc_inds = desacc_inds(desacc_inds > 0 & desacc_inds <= 5000);
% desacc_bool(desacc_bool) = 1;

larp_desacc = larp;
larp_desacc(desacc_bool) = [];

larp_noQPs = nan(size(larp));
larp_noQPs(desacc_bool == 0) = larp_desacc;
% larp_smooth(trace_diff <= threshold) = voma__irlssmooth(larp_desacc,20);
larp_fillmissing = fillmissing(larp_noQPs,'linear');

ralp_desacc = ralp;
ralp_desacc(desacc_inds) = [];

ralp_noQPs = nan(size(ralp));
ralp_noQPs(desacc_bool == 0) = ralp_desacc;
% ralp_smooth(trace_diff <= threshold) = voma__irlssmooth(ralp_desacc,20);
ralp_fillmissing = fillmissing(ralp_noQPs,'linear');

lhrh_desacc = lhrh;
lhrh_desacc(desacc_bool) = [];

lhrh_noQPs = nan(size(lhrh));
lhrh_noQPs(desacc_bool == 0) = lhrh_desacc;
% lhrh_smooth(trace_diff <= threshold) = voma__irlssmooth(lhrh_desacc,20);
lhrh_fillmissing = fillmissing(lhrh_noQPs,'linear');



%%
% tiledlayout("vertical")
figure,
nexttile,
plot(time,lhrh,'r')
hold on
plot(time,ralp,'b')
plot(time,larp,'g')
ylim([-200,200])
xlim([0,5000])

nexttile
plot(time, larp_noQPs,'k')
hold on
plot(time, lhrh_fillmissing,'r')
plot(time, ralp_fillmissing,'b')
plot(time, larp_fillmissing,'g')
ylim([-200,200])
xlim([0,5000])

nexttile
plot(time, lhrh_noQPs,'r')
hold on
plot(time, ralp_noQPs,'b')
plot(time, larp_noQPs,'g')
ylim([-200,200])
xlim([0,5000])

nexttile
plot(reshape(voma__irlssmooth(lhrh(1:end),30),500,[]),'r')
hold on
plot(reshape(voma__irlssmooth(larp(1:end),5),500,[]),'g')
plot(reshape(voma__irlssmooth(ralp(1:end),30),500,[]),'b')

cycles_larp = reshape(larp_fillmissing(1:end),500,[]);
cycles_ralp = reshape(ralp_fillmissing(1:end),500,[]);
cycles_lhrh = reshape(lhrh_fillmissing(1:end),500,[]);
nexttile
plot(cycles_lhrh(:,keepCycles),'r')
hold on
plot(cycles_larp(:,keepCycles),'g')
plot(cycles_ralp(:,keepCycles),'b')


cycles_larp = reshape(larp_noQPs(1:end),500,[]);
cycles_ralp = reshape(ralp_noQPs(1:end),500,[]);
cycles_lhrh = reshape(lhrh_noQPs(1:end),500,[]);
nexttile
plot(cycles_lhrh(:,keepCycles),'r')
hold on
plot(cycles_larp(:,keepCycles),'g')
plot(cycles_ralp(:,keepCycles),'b')

nexttile
plot(voma__irlssmooth(cycles_lhrh(:,keepCycles),30),'r')
hold on
plot(cycles_larp(:,keepCycles),'g')
plot(cycles_ralp(:,keepCycles),'b')
