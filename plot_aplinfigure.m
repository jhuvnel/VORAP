
%% plot PAM sweep 0-700uA

filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240318 Pearl PFM Thresholding and DC Sines\Cycles';
filename = 'ExperimentRecords_PAM.csv';
metaData = readtable(fullfile(filepath,filename));

stimAmp = [100 200 300 400 500 600 700];

eyeVel_cathodic_nystagmusCorrected = [stimAmp' metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected];
eyeVel_cathodic_nystagmusCorrected_std = metaData.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected;

misalignment_cathodic_nystagmusCorrected = [stimAmp' metaData.EyeVel_Misalignment_Cathodic_avg_nystagmusCorrected];
misalignment_cathodic_nystagmusCorrected_std = metaData.EyeVel_Misalignment_Cathodic_std_nystagmusCorrected;

eyeVel_anodic_nystagmusCorrected = [metaData.StimAmplitude2 metaData.EyeVel_Magnitude_Anodic_avg_nystagmusCorrected];
eyeVel_anodic_nystagmusCorrected_std = metaData.EyeVel_Magnitude_Anodic_std_nystagmusCorrected;

misalignment_anodic_nystagmusCorrected = [metaData.StimAmplitude2 metaData.EyeVel_Misalignment_Anodic_avg_nystagmusCorrected];
misalignment_anodic_nystagmusCorrected_std = metaData.EyeVel_Misalignment_Anodic_std_nystagmusCorrected;


eyeVel_cathodic = [stimAmp' metaData.EyeVel_Magnitude_Cathodic_avg];
eyeVel_cathodic_std = metaData.EyeVel_Magnitude_Cathodic_std;

misalignment_cathodic = [stimAmp' metaData.EyeVel_Misalignment_Cathodic_avg];
misalignment_cathodic_std = metaData.EyeVel_Misalignment_Cathodic_std;

eyeVel_anodic = [metaData.StimAmplitude2 metaData.EyeVel_Magnitude_Anodic_avg];
eyeVel_anodic_std = metaData.EyeVel_Magnitude_Anodic_std;

misalignment_anodic = [metaData.StimAmplitude2 metaData.EyeVel_Misalignment_Anodic_avg];
misalignment_anodic_std = metaData.EyeVel_Misalignment_Anodic_std;


% nystagmus corrected
figure,
nexttile;
errorbar(eyeVel_cathodic_nystagmusCorrected(:,1),eyeVel_cathodic_nystagmusCorrected(:,2),eyeVel_cathodic_nystagmusCorrected_std,'.-','MarkerSize',15)
hold on
errorbar(eyeVel_anodic_nystagmusCorrected(:,1),eyeVel_anodic_nystagmusCorrected(:,2),eyeVel_anodic_nystagmusCorrected_std,'.-','MarkerSize',15)
ylabel('eye velocity (dps)')
title('PAM sweep','250us trapezoids, nystagmus corrected')
nexttile;
errorbar(misalignment_cathodic_nystagmusCorrected(:,1),misalignment_cathodic_nystagmusCorrected(:,2),misalignment_cathodic_nystagmusCorrected_std,'.-','MarkerSize',15)
hold on
errorbar(misalignment_anodic_nystagmusCorrected(:,1),misalignment_anodic_nystagmusCorrected(:,2),misalignment_anodic_nystagmusCorrected_std,'.-','MarkerSize',15)
ylabel('misalignment (degs)')
xlabel('current (uA)')

% not nystagmus corrected
figure,
nexttile;
errorbar(eyeVel_cathodic(:,1),eyeVel_cathodic(:,2),eyeVel_cathodic_std,'.-','MarkerSize',15)
hold on
errorbar(eyeVel_anodic(:,1),eyeVel_anodic(:,2),eyeVel_anodic_std,'.-','MarkerSize',15)
ylabel('eye velocity (dps)')
title('PAM sweep','250us trapezoids, not nystagmus corrected')
nexttile;
errorbar(misalignment_cathodic(:,1),misalignment_cathodic(:,2),misalignment_cathodic_std,'.-','MarkerSize',15)
hold on
errorbar(misalignment_anodic(:,1),misalignment_anodic(:,2),misalignment_anodic_std,'.-','MarkerSize',15)
ylabel('misalignment (degs)')
xlabel('current (uA)')

%% plot PFM sweep 0-1000Hz

filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240320 Pearl PFM Thresholding\Cycles';
filename = 'ExperimentRecords_PFM_Sweep.csv';
metaData = readtable(fullfile(filepath,filename));


amps = str2double(extractBefore(metaData.StimAmplitude1,'pps'));
is300 = contains(metaData.CycleName,'Amp300');


figure,
nexttile,
errorbar(amps(is300),metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected(is300),metaData.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected(is300),'.-','MarkerSize',10)
ylabel('eye velocity (dps)')
title('300uA')
xticklabels([])
nexttile,
errorbar(amps(is300),metaData.EyeVel_Misalignment_Cathodic_avg_nystagmusCorrected(is300),metaData.EyeVel_Misalignment_Cathodic_std_nystagmusCorrected(is300),'.-','MarkerSize',10)
xlabel('pulse frequency (Hz)')
ylabel('misalignment (degs)')
title('misalignment')


figure,
nexttile,
errorbar(amps(~is300),metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected(~is300),metaData.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected(~is300),'.-','MarkerSize',10)
ylabel('eye velocity (dps)')
title('600uA')
xticklabels([])
nexttile,
errorbar(amps(~is300),metaData.EyeVel_Misalignment_Cathodic_avg_nystagmusCorrected(~is300),metaData.EyeVel_Misalignment_Cathodic_std_nystagmusCorrected(~is300),'.-','MarkerSize',10)
xlabel('pulse frequency (Hz)')
ylabel('misalignment (degs)')
title('misalignment')

%% plot sines: amplitude sweep, 1Hz
filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240319 Pearl DC Sines Baselines\Cycles';
filename = 'ExperimentRecords_AmplitudeSweep_Sines.csv';

% filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240417 Pearl eeVOR\Cycles';
% filename = 'ExperimentRecords_SineAmplitudeSweep.csv';

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
figure,
t = tiledlayout(2,1);
title(t,'PFM')
nexttile,
errorbar(cathodicData_amplitude/550 * 100,cathodicData_eyeVel_nystagmusCorrected(:,1:2:end),cathodicData_eyeVel_std_nystagmusCorrected(:,1:2:end))
legend(baselines,'Location','northoutside','NumColumns',5)
ylabel('excitatory eye velocity (dps)')
set(gca, 'ColorOrder', colormap(gray(6)))
box off
nexttile,
errorbar(-cathodicData_amplitude/550 * 100,-cathodicData_eyeVel_nystagmusCorrected(:,2:2:end),cathodicData_eyeVel_std_nystagmusCorrected(:,2:2:end))
set(gca, 'ColorOrder', colormap(gray(6)))
ylabel('inhibatory eye velocity (dps)')
xlabel('current modulation (%)')
box off

title(t,'cathodic iDC')
% t.TileSpacing = "compact";


stimAmp = str2double(extractBefore(metaData.StimAmplitude,'pps'));
cathodicData_amplitude = [stimAmp(is100pps)];
cathodicData_eyeVel = [eyeVel(is100pps,:)];
cathodicData_eyeVel_nystagmusCorrected = [eyeVel_nystagmusCorrected(is100pps,:)];
cathodicData_eyeVel_std = [eyeVel_std(is100pps,:)];
cathodicData_eyeVel_std_nystagmusCorrected = [eyeVel_std_nystagmusCorrected(is100pps,:)];
cathodicData_misalignment = [misalignment(is100pps,:)];
cathodicData_misalignment_nystagmusCorrected = [misalignment_nystagmusCorrected(is100pps,:)];
cathodicData_misalignment_std = [misalignment_std(is100pps,:)];
cathodicData_misalignment_std_nystagmusCorrected = [misalignment_std_nystagmusCorrected(is100pps,:)];



% plot PFM
baselines = {'100uA'};
figure,
t = tiledlayout(2,1);
nexttile,
errorbar(cathodicData_amplitude/100 * 100,cathodicData_eyeVel_nystagmusCorrected(:,1:2:end),cathodicData_eyeVel_std_nystagmusCorrected(:,1:2:end))
legend(baselines,'Location','northoutside','NumColumns',5)
ylabel('excitatory eye velocity (dps)')
set(gca, 'ColorOrder', colormap(gray(6)))
box off
nexttile,
errorbar(-cathodicData_amplitude/100 * 100,-cathodicData_eyeVel_nystagmusCorrected(:,2:2:end),cathodicData_eyeVel_std_nystagmusCorrected(:,2:2:end))
set(gca, 'ColorOrder', colormap(gray(6)))
ylabel('inhibatory eye velocity (dps)')
xlabel('pulse frequency modulation (%)')
box off

% misalignment


%% plot sines: frequency sweep
filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240319 Pearl DC Sines Baselines\Cycles';
filename = 'ExperimentRecords_FrequencySweep_Sines.csv';
metaData = readtable(fullfile(filepath,filename));


% frequency = str2double(extractBefore(metaData.Frequency,'Hz'));
% eyeVel_cathodic = metaData.EyeVel_Magnitude_Cathodic_avg;
% eyeVel_anodic = metaData.EyeVel_Magnitude_Anodic_avg;
% eyeVel_cathodic_std = metaData.EyeVel_Magnitude_Cathodic_std;
% eyeVel_anodic_std = metaData.EyeVel_Magnitude_Anodic_std;

frequency = str2double(extractBefore(metaData.Frequency,'Hz'));
eyeVel_cathodic = metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected;
eyeVel_anodic = metaData.EyeVel_Magnitude_Anodic_avg_nystagmusCorrected;
eyeVel_cathodic_std = metaData.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected;
eyeVel_anodic_std = metaData.EyeVel_Magnitude_Anodic_std_nystagmusCorrected;
% phaseShift = metaData.PhaseShift;

isPFM = contains(metaData.StimType,'PFM');
isDC100cathodic = contains(metaData.StimType,'DC') & contains(metaData.StimOffset,'100uA');
isZero = contains(metaData.StimType,'DC') & ~contains(metaData.StimOffset,'100uA');


% plot phase shift
% figure,
% plot(frequency(isPFM), phaseShift(isPFM),'o')
% hold on
% plot(frequency(isZero), phaseShift(isZero),'o')
% plot(frequency(isDC100cathodic), phaseShift(isDC100cathodic),'o')

% plot amplitude: cathodic
dataPFM = sortrows([frequency(isPFM) eyeVel_cathodic(isPFM) eyeVel_cathodic_std(isPFM)],1);
dataZero = sortrows([frequency(isZero) eyeVel_cathodic(isZero) eyeVel_cathodic_std(isZero)],1);
dataDC100cathodic = sortrows([frequency(isDC100cathodic) eyeVel_cathodic(isDC100cathodic) eyeVel_cathodic_std(isDC100cathodic)],1);

figure, 
errorbar([dataPFM(:,1) dataZero(:,1) dataDC100cathodic(:,1)], ...
    [dataPFM(:,2) dataZero(:,2) dataDC100cathodic(:,2)], ...
    [dataPFM(:,3) dataZero(:,3) dataDC100cathodic(:,3)],'.-')
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlabel('frequency (Hz)')
ylabel('eye velocity (dps)')
title('VOR response to cathodic/excitatory half of sinusoid')
legend('100pps','0uA','-100uA')

% plot amplitude: anodic
dataPFM = sortrows([frequency(isPFM) eyeVel_anodic(isPFM) eyeVel_anodic_std(isPFM)],1);
dataZero = sortrows([frequency(isZero) eyeVel_anodic(isZero) eyeVel_anodic_std(isZero)],1);
dataDC100cathodic = sortrows([frequency(isDC100cathodic) eyeVel_anodic(isDC100cathodic) eyeVel_anodic_std(isDC100cathodic)],1);

figure, 
errorbar([dataPFM(:,1) dataZero(:,1) dataDC100cathodic(:,1)], ...
    [dataPFM(:,2) dataZero(:,2) dataDC100cathodic(:,2)], ...
    [dataPFM(:,3) dataZero(:,3) dataDC100cathodic(:,3)],'.-')
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlabel('frequency (Hz)')
ylabel('eye velocity (dps)')
title('VOR response to anodic/inhibitory half of sinusoid')
legend('100pps','0uA','100uA')




%% plot long pulses

filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240313 Long Trapz\Cycles';
filename = 'ExperimentRecords_LongTrapezoids.csv';

metaData = readtable(fullfile(filepath,filename));

eyeVel_cathodic_nystagmusCorrected = [metaData.StimAmplitude1 metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected];
eyeVel_cathodic_nystagmusCorrected_std = metaData.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected;

misalignment_cathodic_nystagmusCorrected = [metaData.StimAmplitude1 metaData.EyeVel_Misalignment_Cathodic_avg_nystagmusCorrected];
misalignment_cathodic_nystagmusCorrected_std = metaData.EyeVel_Misalignment_Cathodic_std_nystagmusCorrected;

eyeVel_anodic_nystagmusCorrected = [metaData.StimAmplitude2 metaData.EyeVel_Magnitude_Anodic_avg_nystagmusCorrected];
eyeVel_anodic_nystagmusCorrected_std = metaData.EyeVel_Magnitude_Anodic_std_nystagmusCorrected;

misalignment_anodic_nystagmusCorrected = [metaData.StimAmplitude2 metaData.EyeVel_Misalignment_Anodic_avg_nystagmusCorrected];
misalignment_anodic_nystagmusCorrected_std = metaData.EyeVel_Misalignment_Anodic_std_nystagmusCorrected;


eyeVel_cathodic = [metaData.StimAmplitude1 metaData.EyeVel_Magnitude_Cathodic_avg];
eyeVel_cathodic_std = metaData.EyeVel_Magnitude_Cathodic_std;

misalignment_cathodic = [metaData.StimAmplitude1 metaData.EyeVel_Misalignment_Cathodic_avg];
misalignment_cathodic_std = metaData.EyeVel_Misalignment_Cathodic_std;

eyeVel_anodic = [metaData.StimAmplitude2 metaData.EyeVel_Magnitude_Anodic_avg];
eyeVel_anodic_std = metaData.EyeVel_Magnitude_Anodic_std;

misalignment_anodic = [metaData.StimAmplitude2 metaData.EyeVel_Misalignment_Anodic_avg];
misalignment_anodic_std = metaData.EyeVel_Misalignment_Anodic_std;


% nystagmus corrected
figure,
nexttile;
errorbar(eyeVel_cathodic_nystagmusCorrected(:,1),eyeVel_cathodic_nystagmusCorrected(:,2),eyeVel_cathodic_nystagmusCorrected_std,'.','MarkerSize',15)
hold on
errorbar(eyeVel_anodic_nystagmusCorrected(:,1),eyeVel_anodic_nystagmusCorrected(:,2),eyeVel_anodic_nystagmusCorrected_std,'.','MarkerSize',15)
ylabel('eye velocity (dps)')
title('eye velocity and misalignment','long trapezoids, nystagmus corrected')
nexttile;
errorbar(misalignment_cathodic_nystagmusCorrected(:,1),misalignment_cathodic_nystagmusCorrected(:,2),misalignment_cathodic_nystagmusCorrected_std,'.','MarkerSize',15)
hold on
errorbar(misalignment_anodic_nystagmusCorrected(:,1),misalignment_anodic_nystagmusCorrected(:,2),misalignment_anodic_nystagmusCorrected_std,'.','MarkerSize',15)
ylabel('misalignment (degs)')
xlabel('current (uA)')

% not nystagmus corrected
figure,
nexttile;
errorbar(eyeVel_cathodic(:,1),eyeVel_cathodic(:,2),eyeVel_cathodic_std,'.','MarkerSize',15)
hold on
errorbar(eyeVel_anodic(:,1),eyeVel_anodic(:,2),eyeVel_anodic_std,'.','MarkerSize',15)
ylabel('eye velocity (dps)')
title('eye velocity and misalignment','long trapezoids, not nystagmus corrected')
nexttile;
errorbar(misalignment_cathodic(:,1),misalignment_cathodic(:,2),misalignment_cathodic_std,'.','MarkerSize',15)
hold on
errorbar(misalignment_anodic(:,1),misalignment_anodic(:,2),misalignment_anodic_std,'.','MarkerSize',15)
ylabel('misalignment (degs)')
xlabel('current (uA)')


%% aplin figure: plot eye velocity for each stim amplitude for a given stim baseline
clear all 

filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240222 Pearl DC and PFM baselines\Cycles';
filename = 'ExperimentRecords_Trapezoids.csv';

% filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240418 Pearl eeVOR\Cycles';
% filename = 'ExperimentRecords_SquareWaves_20240418.csv';

% filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240216 Pearl DC trapz with baseline amphetamines\Cycles';
% filename = 'ExperimentRecords_Trapezoids_20240408';

metaData = readtable(fullfile(filepath,filename));

expDate = metaData.Date;
stimOffset = metaData.StimOffset;
stimAmp_cathodic = metaData.StimAmplitude1;

eyeVel_cathodic = metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected;
eyeVel_cathodic_std = metaData.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected;
misalignment_cathodic = metaData.EyeVel_Misalignment_Cathodic_avg_nystagmusCorrected;
misalignment_cathodic_std = metaData.EyeVel_Misalignment_Cathodic_std_nystagmusCorrected;

eyeVel_anodic = metaData.EyeVel_Magnitude_Anodic_avg_nystagmusCorrected;
eyeVel_anodic_std = metaData.EyeVel_Magnitude_Anodic_std_nystagmusCorrected;
misalignment_anodic = metaData.EyeVel_Misalignment_Anodic_avg_nystagmusCorrected;
misalignment_anodic_std = metaData.EyeVel_Misalignment_Anodic_std_nystagmusCorrected;

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

% make sure eye velocity direction is correct for anodic data
if any(misalignment_anodic > 90)
    isOppositeDir = misalignment_anodic > 90;
    eyeVel_temp = eyeVel_anodic;
    eyeVel_temp(isOppositeDir) = -eyeVel_temp(isOppositeDir);
    eyeVel_anodic = eyeVel_temp;
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

                baselineVal = str2double(extractBefore(thisBaseline,'pps'));

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

                baselineVal = str2double(extractBefore(thisBaseline,'pps'));

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

            baselineVal = str2double(extractBefore(thisBaseline,'pps'));

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
                    [metaData.NumCyclesKeep(newPlot_idx);metaData.NumCyclesKeep(newPlot_idx)],...
                    ];

                [~,sortIdx] = sort(data_cathodicBaselines(:,1,count_cathodic));
                data_cathodicBaselines(:,:,count_cathodic) = data_cathodicBaselines(sortIdx,:,count_cathodic);

                legend_txt_cathodicBaselines{count_cathodic} = [thisBaseline,' (',num2str(uniqueExpDates(iDate)),')'];
            end
        case 0 % pfm stim

            uniqueExpDates = unique(expDate(baseline_idx));

            if contains(thisBaseline,'pps')
                baselineVal = str2double(extractBefore(thisBaseline,'pps'));
            else
                baselineVal = str2double(thisBaseline);
            end

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
                    [metaData.NumCyclesKeep(newPlot_idx);metaData.NumCyclesKeep(newPlot_idx)],...
                    ];

                [~,sortIdx] = sort(data_PFMBaselines(:,1,count_pfm));
                data_PFMBaselines(:,:,count_pfm) = data_PFMBaselines(sortIdx,:,count_pfm);

                legend_txt_PFMBaselines{count_pfm} = [num2str(baselineVal),'pps (',num2str(uniqueExpDates(iDate)),')'];
            end
    end

end

% put data in order baseline
[~,anodicBaselines_sortidx] = sort(abs(str2double(extractBefore(legend_txt_anodicBaselines,'uA'))),'desc');
[~,cathodicBaselines_sortidx] = sort(abs(str2double(extractBefore(legend_txt_cathodicBaselines,'uA'))),'desc');
[~,PFMBaselines_sortidx] = sort(abs(str2double(extractBefore(legend_txt_PFMBaselines,'pps'))),'desc');

data_anodicBaselines = data_anodicBaselines(:,:,anodicBaselines_sortidx);
data_cathodicBaselines = data_cathodicBaselines(:,:,cathodicBaselines_sortidx);
data_PFMBaselines = data_PFMBaselines(:,:,PFMBaselines_sortidx);

legend_txt_anodicBaselines = legend_txt_anodicBaselines(anodicBaselines_sortidx);
legend_txt_cathodicBaselines = legend_txt_cathodicBaselines(cathodicBaselines_sortidx);
legend_txt_PFMBaselines = legend_txt_PFMBaselines(PFMBaselines_sortidx);


figure,
tcl = tiledlayout(2,3,'TileSpacing','tight');
title(tcl,'trapezoidal eeVOR','250ms stim, 150ms plateau, 750ms between stim')

% plot PFM baselines
nexttile,
hold on
for iPFMBaseline = 1:length(legend_txt_PFMBaselines)
    errorbar(data_PFMBaselines(:,1,iPFMBaseline), ...
        data_PFMBaselines(:,3,iPFMBaseline), ...
        data_PFMBaselines(:,4,iPFMBaseline), ...
        '-','Marker','.','MarkerSize',12)
end
set(gca, 'ColorOrder', colormap(gray(5)))
xline(0,'-','Color',[0.5 0.5 0.5])
yline(0,'-','Color',[0.5 0.5 0.5])
title('PFM','inhibition     excitation')
ylabel('maximum eye velocity (dps)')
xticklabels({})
leg = legend(legend_txt_PFMBaselines,'Location','north');
title(leg,'baselines:')
xlim([-100 100])
ylim([-150 250])
xticklabels({})
box off

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
set(gca, 'ColorOrder', colormap(gray(5)))
xline(0,'-','Color',[0.5 0.5 0.5])
yline(0,'-','Color',[0.5 0.5 0.5])
title('cathodic iDC','inhibition     excitation')
leg = legend([legend_txt_cathodicBaselines,legend_txt_zeroBaselines],'Location','north');
title(leg,'baselines:')
ylim([-150 250])
xticklabels({})
yticklabels({})
box off

% plot anodic iDC baselines
nexttile,
hold on
for ianodicBaseline = 1:length(legend_txt_anodicBaselines)
    errorbar(data_anodicBaselines(:,1,ianodicBaseline), ...
        data_anodicBaselines(:,3,ianodicBaseline), ...
        data_anodicBaselines(:,4,ianodicBaseline), ...
        '-','Marker','.','MarkerSize',12)
end
errorbar(data_zeroDCBaseline(:,1), ...
        data_zeroDCBaseline(:,3), ...
        data_zeroDCBaseline(:,4), ...
        '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
xline(0,'-','Color',[0.5 0.5 0.5])
yline(0,'-','Color',[0.5 0.5 0.5])
title('anodic iDC','inhibition     excitation')
leg = legend([legend_txt_anodicBaselines, legend_txt_zeroBaselines],'Location','north');
title(leg,'baselines:')
ylim([-150 250])
xticklabels({})
yticklabels({})
box off

% misalignment PFM
nexttile,
hold on
for iPFMBaseline = 1:length(legend_txt_PFMBaselines)
    errorbar(data_PFMBaselines(:,1,iPFMBaseline), ...
        data_PFMBaselines(:,5,iPFMBaseline), ...
        data_PFMBaselines(:,6,iPFMBaseline), ...
        '-','Marker','.','MarkerSize',12)
end
set(gca, 'ColorOrder', colormap(gray(5)))
yline(90,'--','Color',[0.8 0.8 0.8])
xline(0,'-','Color',[0.5 0.5 0.5])
xlabel('pulse frequency modulation (%)')
ylabel('misalignment (degs)')
xlim([-100 100])
ylim([0 200])
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
set(gca, 'ColorOrder', colormap(gray(5)))
yline(90,'--','Color',[0.8 0.8 0.8])
xline(0,'-','Color',[0.5 0.5 0.5])
xlabel('current modulation (%)')
ylim([0 200])
yticklabels({})
box off

% misalignment anodic iDC
nexttile,
hold on
for ianodicBaseline = 1:length(legend_txt_anodicBaselines)
    errorbar(data_anodicBaselines(:,1,ianodicBaseline), ...
        data_anodicBaselines(:,5,ianodicBaseline), ...
        data_anodicBaselines(:,6,ianodicBaseline), ...
        '-','Marker','.','MarkerSize',12)
end
errorbar(data_zeroDCBaseline(:,1), ...
        data_zeroDCBaseline(:,5), ...
        data_zeroDCBaseline(:,6), ...
        '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
yline(90,'--','Color',[0.8 0.8 0.8])
xline(0,'-','Color',[0.5 0.5 0.5])
xlabel('current modulation (%)')
ylim([0 200])
yticklabels({})
box off




% calculate effect of cathodic vs anodic DC on inhibition and excitation

% cathodic DC
anodic100_idx = contains(legend_txt_anodicBaselines,'100uA');
cathodic100_idx = contains(legend_txt_cathodicBaselines,'-100uA');

[zeroBaseline_maxExciatation, zeroBaseline_maxExcitation_idx] = max(data_zeroDCBaseline(:,3));

mod_idx = find(data_cathodicBaselines(:,1,cathodic100_idx) == data_zeroDCBaseline(zeroBaseline_maxExcitation_idx,1));
modulation = [num2str(data_zeroDCBaseline(zeroBaseline_maxExcitation_idx,1)),...
    '% modulation (',...
    num2str(data_zeroDCBaseline(zeroBaseline_maxExcitation_idx,2)),'uA)'] ;
baselineEffect = max(data_cathodicBaselines(:,3,cathodic100_idx)) / zeroBaseline_maxExciatation;

if baselineEffect >= 1
    inc_dec = 'increases';
else
    inc_dec = 'decreases';
end

disp(['A cathodic DC baseline of -100uA ', inc_dec, ' the excitatory range by ', num2str(abs(baselineEffect - 1)*100), '% compared to a 0uA baseline at ',modulation,' from the baseline'])

[zeroBaseline_maxInhibition, zeroBaseline_maxInhibition_idx] = min(data_zeroDCBaseline(:,3));
mod_idx = find(data_cathodicBaselines(:,1,cathodic100_idx) == data_zeroDCBaseline(zeroBaseline_maxInhibition_idx,1));
modulation = [num2str(data_zeroDCBaseline(zeroBaseline_maxInhibition_idx,1)),...
    '% modulation (',...
    num2str(data_zeroDCBaseline(zeroBaseline_maxInhibition_idx,2)),'uA)'] ;
baselineEffect = min(data_cathodicBaselines(:,3,cathodic100_idx)) / zeroBaseline_maxInhibition;

if baselineEffect >= 1
    inc_dec = 'increases';
else
    inc_dec = 'decreases';
end

disp(['A cathodic DC baseline of -100uA ', inc_dec, ' the inhibitory range by ', num2str(abs(baselineEffect - 1)*100), '% compared to a 0uA baseline at ',modulation,' from the baseline'])


% anodic DC
mod_idx = find(data_anodicBaselines(:,1,anodic100_idx) == data_zeroDCBaseline(zeroBaseline_maxExcitation_idx,1));
modulation = [num2str(data_zeroDCBaseline(zeroBaseline_maxExcitation_idx,1)),...
    '% modulation (',...
    num2str(data_zeroDCBaseline(zeroBaseline_maxExcitation_idx,2)),'uA)'] ;
baselineEffect = max(data_anodicBaselines(:,3,anodic100_idx)) / zeroBaseline_maxExciatation;

if baselineEffect >= 1
    inc_dec = 'increases';
else
    inc_dec = 'decreases';
end

disp(['An anodic DC baseline of 100uA ', inc_dec, ' the excitatory range by ', num2str(abs(baselineEffect - 1)*100), '% compared to a 0uA baseline at ',modulation,' from the baseline'])

mod_idx = find(data_anodicBaselines(:,1,anodic100_idx) == data_zeroDCBaseline(zeroBaseline_maxInhibition_idx,1));
modulation = [num2str(data_zeroDCBaseline(zeroBaseline_maxInhibition_idx,1)),...
    '% modulation (',...
    num2str(data_zeroDCBaseline(zeroBaseline_maxInhibition_idx,2)),'uA)'] ;
% baselineEffect = min(data_anodicBaselines(:,3,anodic100_idx)) / zeroBaseline_maxInhibition;
if any(abs(data_anodicBaselines(:,4,anodic100_idx)) > abs(data_anodicBaselines(:,3,anodic100_idx)))
    idx = find(abs(data_anodicBaselines(:,4,anodic100_idx)) > abs(data_anodicBaselines(:,3,anodic100_idx)));
    data_anodicBaselines(idx,:,anodic100_idx) = NaN;
end
baselineEffect = min(data_anodicBaselines(:,3,anodic100_idx)) / zeroBaseline_maxInhibition;

if baselineEffect >= 1
    inc_dec = 'increases';
else
    inc_dec = 'decreases';
end

disp(['An anodic DC baseline of 100uA ', inc_dec, ' the inhibitory range by ', num2str(abs(baselineEffect - 1)*100), '% compared to a 0uA baseline at ',modulation,' from the baseline'])

s1 = data_anodicBaselines(mod_idx,4,anodic100_idx)^2;
s2 = data_zeroDCBaseline(zeroBaseline_maxInhibition_idx,4)^2;
n1 = data_anodicBaselines(mod_idx,7);
n2 = data_zeroDCBaseline(zeroBaseline_maxInhibition_idx,7);

% sqrt( ...
%     ((n1 - 1)*s1^2 + (n2-1)*s2^2)/...
%     (n1 + n2 - 2))
% 
% sqrt ( ( n1^2*s1 + n2^2*s2 - n1*var1 - n1*s2 - n2*s1 - ...
%     n2*s2 + n1*n2*s1 + n1*n2*s2 + n1*n2*(mean1 - mean2)^2 ) / ( (n1+n2-1)*(n1+n2) ) )
% 
% (n1*data_anodicBaselines(mod_idx,3,anodic100_idx) + n2*data_zeroDCBaseline(zeroBaseline_maxInhibition_idx,3))/...
%     (n1 + n2)





%% plot baseline vs eye vel




%% OLD aplin figure: plot eye velocity for each stim amplitude for a given stim baseline
filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240222 Pearl DC and PFM baselines\Cycles';
filename = 'ExperimentRecords_Trapezoids.csv';
metaData = readtable(fullfile(filepath,filename));

stimOffset = metaData.StimOffset;
stimAmp_cathodic = metaData.StimAmplitude1;

eyeVel_cathodic = metaData.EyeVel_Magnitude_Cathodic_avg_nystagmusCorrected;
eyeVel_cathodic_std = metaData.EyeVel_Magnitude_Cathodic_std_nystagmusCorrected;
misalignment_cathodic = metaData.EyeVel_Misalignment_Cathodic_avg_nystagmusCorrected;
misalignment_cathodic_std = metaData.EyeVel_Misalignment_Cathodic_std_nystagmusCorrected;

eyeVel_anodic = metaData.EyeVel_Magnitude_Anodic_avg_nystagmusCorrected;
eyeVel_anodic_std = metaData.EyeVel_Magnitude_Anodic_std_nystagmusCorrected;
misalignment_anodic = metaData.EyeVel_Misalignment_Anodic_avg_nystagmusCorrected;
misalignment_anodic_std = metaData.EyeVel_Misalignment_Anodic_std_nystagmusCorrected;

stimOffset = metaData.StimOffset;
stimAmp_anodic = metaData.StimAmplitude2;

figure,
tcl = tiledlayout(2,3,'TileSpacing','tight');
title(tcl,'trapezoidal eeVOR','250ms stim, 150ms plateau, 750ms between stim')

% PFM stim: plot eye velocity for each stim amplitude for a given stim baseline

isPFM100 = contains(stimOffset,'100') & contains(stimOffset,'pps');
isPFM200 = contains(stimOffset,'200') & contains(stimOffset,'pps');
isPFM300 = contains(stimOffset,'300') & contains(stimOffset,'pps');
isPFM0 = contains(stimOffset,'0') & ~isPFM100 & ~isPFM200 & ~isPFM300 & contains(stimOffset,'pps');


data_PFM0_excitatory = [(stimAmp_cathodic(isPFM0))...
    eyeVel_cathodic(isPFM0)...
    eyeVel_cathodic_std(isPFM0)...
    misalignment_cathodic(isPFM0)...
    misalignment_cathodic_std(isPFM0)...
    ];

data_PFM100_excitatory = [(stimAmp_cathodic(isPFM100)-100)...
    eyeVel_cathodic(isPFM100)...
    eyeVel_cathodic_std(isPFM100)...
    misalignment_cathodic(isPFM100)...
    misalignment_cathodic_std(isPFM100)...
    ];

data_PFM200_excitatory = [(stimAmp_cathodic(isPFM200)-200)...
    eyeVel_cathodic(isPFM200)...
    eyeVel_cathodic_std(isPFM200)...
    misalignment_cathodic(isPFM200)...
    misalignment_cathodic_std(isPFM200)...
    ];

data_PFM300_excitatory = [(stimAmp_cathodic(isPFM300)-300)...
    eyeVel_cathodic(isPFM300)...
    eyeVel_cathodic_std(isPFM300)...
    misalignment_cathodic(isPFM300)...
    misalignment_cathodic_std(isPFM300)...
    ];

data_PFM0_excitatory = sortrows(data_PFM0_excitatory);
maxModulation = max(data_PFM0_excitatory(:,1));
data_PFM0_excitatory(:,1) = (data_PFM0_excitatory(:,1)/maxModulation) * 100;

data_PFM100_excitatory = sortrows(data_PFM100_excitatory);
maxModulation = max(data_PFM100_excitatory(:,1));
data_PFM100_excitatory(:,1) = (data_PFM100_excitatory(:,1)/maxModulation) * 100;

data_PFM200_excitatory = sortrows(data_PFM200_excitatory);
maxModulation = max(data_PFM200_excitatory(:,1));
data_PFM200_excitatory(:,1) = (data_PFM200_excitatory(:,1)/maxModulation) * 100;

data_PFM300_excitatory = sortrows(data_PFM300_excitatory);
maxModulation = max(data_PFM300_excitatory(:,1));
data_PFM300_excitatory(:,1) = (data_PFM300_excitatory(:,1)/maxModulation) * 100;

data_PFM0_inhibitory = [stimAmp_anodic(isPFM0)...
    eyeVel_anodic(isPFM0)...
    eyeVel_anodic_std(isPFM0)...
    misalignment_anodic(isPFM0)...
    misalignment_anodic_std(isPFM0)...
    ];
% make sure eye velocity direction is correct
if any(data_PFM0_inhibitory(:,4) > 90)
    idx = data_PFM0_inhibitory(:,4) > 90;
    data_PFM0_inhibitory(idx,2) = -data_PFM0_inhibitory(idx,2);
end

data_PFM100_inhibitory = [100-stimAmp_anodic(isPFM100)...
    eyeVel_anodic(isPFM100)...
    eyeVel_anodic_std(isPFM100)...
    misalignment_anodic(isPFM100)...
    misalignment_anodic_std(isPFM100)...
    ];
% make sure eye velocity direction is correct
if any(data_PFM100_inhibitory(:,4) > 90)
    idx = data_PFM100_inhibitory(:,4) > 90;
    data_PFM100_inhibitory(idx,2) = -data_PFM100_inhibitory(idx,2);
end

data_PFM200_inhibitory = [200-stimAmp_anodic(isPFM200)...
    eyeVel_anodic(isPFM200)...
    eyeVel_anodic_std(isPFM200)...
    misalignment_anodic(isPFM200)...
    misalignment_anodic_std(isPFM200)...
    ];
% make sure eye velocity direction is correct
if any(data_PFM200_inhibitory(:,4) > 90)
    idx = data_PFM200_inhibitory(:,4) > 90;
    data_PFM200_inhibitory(idx,2) = -data_PFM200_inhibitory(idx,2);
end

data_PFM300_inhibitory = [300-stimAmp_anodic(isPFM300)...
    eyeVel_anodic(isPFM300)...
    eyeVel_anodic_std(isPFM300)...
    misalignment_anodic(isPFM300)...
    misalignment_anodic_std(isPFM300)...
    ];
% make sure eye velocity direction is correct
if any(data_PFM300_inhibitory(:,4) > 90)
    idx = data_PFM300_inhibitory(:,4) > 90;
    data_PFM300_inhibitory(idx,2) = -data_PFM300_inhibitory(idx,2);
end

data_PFM0_inhibitory = sortrows(data_PFM0_inhibitory);
maxModulation = max(data_PFM0_inhibitory(:,1));
data_PFM0_inhibitory(:,1) = (data_PFM0_inhibitory(:,1)/maxModulation) * 100;

data_PFM100_inhibitory = sortrows(data_PFM100_inhibitory);
maxModulation = max(data_PFM100_inhibitory(:,1));
data_PFM100_inhibitory(:,1) = (data_PFM100_inhibitory(:,1)/maxModulation) * 100;

data_PFM200_inhibitory = sortrows(data_PFM200_inhibitory);
maxModulation = max(data_PFM200_inhibitory(:,1));
data_PFM200_inhibitory(:,1) = (data_PFM200_inhibitory(:,1)/maxModulation) * 100;

data_PFM300_inhibitory = sortrows(data_PFM300_inhibitory);
maxModulation = max(data_PFM300_inhibitory(:,1));
data_PFM300_inhibitory(:,1) = (data_PFM300_inhibitory(:,1)/maxModulation) * 100;

nexttile,
errorbar([data_PFM300_excitatory(:,1); -data_PFM300_inhibitory(:,1)], ...
    [data_PFM300_excitatory(:,2); -data_PFM300_inhibitory(:,2)], ...
    [data_PFM300_excitatory(:,3); data_PFM300_inhibitory(:,3)], ...
    '-','Marker','.','MarkerSize',12)
hold on
errorbar([data_PFM200_excitatory(:,1); -data_PFM200_inhibitory(:,1)], ...
    [data_PFM200_excitatory(:,2); -data_PFM200_inhibitory(:,2)], ...
    [data_PFM200_excitatory(:,3); data_PFM200_inhibitory(:,3)], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_PFM100_excitatory(:,1); -data_PFM100_inhibitory(:,1)], ...
    [data_PFM100_excitatory(:,2); -data_PFM100_inhibitory(:,2)], ...
    [data_PFM100_excitatory(:,3); data_PFM100_inhibitory(:,3) ], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_PFM0_excitatory(:,1); -data_PFM0_inhibitory(:,1)], ...
    [data_PFM0_excitatory(:,2); -data_PFM0_inhibitory(:,2)], ...
    [data_PFM0_excitatory(:,3); data_PFM0_inhibitory(:,3) ], ...
    '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
xline(0,'-','Color',[0.5 0.5 0.5])
yline(0,'-','Color',[0.5 0.5 0.5])
title('PFM','inhibition     excitation')
ylabel('maximum eye velocity (dps)')
xticklabels({})
leg = legend('300pps','200pps','100pps','0pps','Location','northwest');
title(leg,'baselines:')
ylim([-150 250])
box off


% cathodic stim: plot eye velocity for each stim amplitude for a given stim baseline


isCathodic100 = contains(stimOffset,'-100')  & contains(stimOffset,'uA');
isCathodic50 = contains(stimOffset,'-50')  & contains(stimOffset,'uA');
isCathodic25 = contains(stimOffset,'-25')  & contains(stimOffset,'uA');
isCathodic0 = contains(stimOffset,'0') & ~contains(stimOffset,'50') & ~contains(stimOffset,'100') & contains(stimOffset,'uA') ;

data_cathodic100_cathodic = [stimAmp_cathodic(isCathodic100)...
    eyeVel_cathodic(isCathodic100)...
    eyeVel_cathodic_std(isCathodic100)...
    misalignment_cathodic(isCathodic100)...
    misalignment_cathodic_std(isCathodic100)...
    ];

data_cathodic50_cathodic = [stimAmp_cathodic(isCathodic50)...
    eyeVel_cathodic(isCathodic50)...
    eyeVel_cathodic_std(isCathodic50)...
    misalignment_cathodic(isCathodic50)...
    misalignment_cathodic_std(isCathodic50)...
    ];

data_cathodic25_cathodic = [stimAmp_cathodic(isCathodic25)...
    eyeVel_cathodic(isCathodic25)...
    eyeVel_cathodic_std(isCathodic25)...
    misalignment_cathodic(isCathodic25)...
    misalignment_cathodic_std(isCathodic25)...
    ];

data_cathodic0_cathodic = [stimAmp_cathodic(isCathodic0)...
    eyeVel_cathodic(isCathodic0)...
    eyeVel_cathodic_std(isCathodic0)...
    misalignment_cathodic(isCathodic0)...
    misalignment_cathodic_std(isCathodic0)...
    ];

data_cathodic0_cathodic = sortrows(data_cathodic0_cathodic);
maxModulation = min(data_cathodic0_cathodic(:,1));
data_cathodic0_cathodic(:,1) = (data_cathodic0_cathodic(:,1)/maxModulation) * 100;

data_cathodic25_cathodic = sortrows(data_cathodic25_cathodic);
maxModulation = min(data_cathodic25_cathodic(:,1));
data_cathodic25_cathodic(:,1) = (data_cathodic25_cathodic(:,1)/maxModulation) * 100;

data_cathodic50_cathodic = sortrows(data_cathodic50_cathodic);
maxModulation = min(data_cathodic50_cathodic(:,1));
data_cathodic50_cathodic(:,1) = (data_cathodic50_cathodic(:,1)/maxModulation) * 100;

data_cathodic100_cathodic = sortrows(data_cathodic100_cathodic);
maxModulation = min(data_cathodic100_cathodic(:,1));
data_cathodic100_cathodic(:,1) = (data_cathodic100_cathodic(:,1)/maxModulation) * 100;



data_cathodic100_anodic = [stimAmp_anodic(isCathodic100)...
    eyeVel_anodic(isCathodic100)...
    eyeVel_anodic_std(isCathodic100)...
    misalignment_anodic(isCathodic100)...
    misalignment_anodic_std(isCathodic100)...
    ];
% make sure eye velocity direction is correct
if any(data_cathodic100_anodic(:,4) > 90)
    idx = data_cathodic100_anodic(:,4) > 90;
    data_cathodic100_anodic(idx,2) = -data_cathodic100_anodic(idx,2);
end

data_cathodic50_anodic = [stimAmp_anodic(isCathodic50)...
    eyeVel_anodic(isCathodic50)...
    eyeVel_anodic_std(isCathodic50)...
    misalignment_anodic(isCathodic50)...
    misalignment_anodic_std(isCathodic50)...
    ];
% make sure eye velocity direction is correct
if any(data_cathodic50_anodic(:,4) > 90)
    idx = data_cathodic50_anodic(:,4) > 90;
    data_cathodic50_anodic(idx,2) = -data_cathodic50_anodic(idx,2);
end

data_cathodic25_anodic = [stimAmp_anodic(isCathodic25)...
    eyeVel_anodic(isCathodic25)...
    eyeVel_anodic_std(isCathodic25)...
    misalignment_anodic(isCathodic25)...
    misalignment_anodic_std(isCathodic25)...
    ];
% make sure eye velocity direction is correct
if any(data_cathodic25_anodic(:,4) > 90)
    idx = data_cathodic25_anodic(:,4) > 90;
    data_cathodic25_anodic(idx,2) = -data_cathodic25_anodic(idx,2);
end

data_cathodic0_anodic = [stimAmp_anodic(isCathodic0)...
    eyeVel_anodic(isCathodic0)...
    eyeVel_anodic_std(isCathodic0)...
    misalignment_anodic(isCathodic0)...
    misalignment_anodic_std(isCathodic0)...
    ];
% make sure eye velocity direction is correct
if any(data_cathodic0_anodic(:,4) > 90)
    idx = data_cathodic0_anodic(:,4) > 90;
    data_cathodic0_anodic(idx,2) = -data_cathodic0_anodic(idx,2);
end

data_cathodic100_anodic = sortrows(data_cathodic100_anodic);
maxModulation = max(data_cathodic100_anodic(:,1));
data_cathodic100_anodic(:,1) = (data_cathodic100_anodic(:,1)/maxModulation) * 100;

data_cathodic50_anodic = sortrows(data_cathodic50_anodic);
maxModulation = max(data_cathodic50_anodic(:,1));
data_cathodic50_anodic(:,1) = (data_cathodic50_anodic(:,1)/maxModulation) * 100;

data_cathodic25_anodic = sortrows(data_cathodic25_anodic);
maxModulation = max(data_cathodic25_anodic(:,1));
data_cathodic25_anodic(:,1) = (data_cathodic25_anodic(:,1)/maxModulation) * 100;

data_cathodic0_anodic = sortrows(data_cathodic0_anodic);
maxModulation = max(data_cathodic0_anodic(:,1));
data_cathodic0_anodic(:,1) = (data_cathodic0_anodic(:,1)/maxModulation) * 100;

nexttile,
errorbar([data_cathodic100_cathodic(:,1); -data_cathodic100_anodic(:,1)], ...
    [data_cathodic100_cathodic(:,2); -data_cathodic100_anodic(:,2)], ...
    [data_cathodic100_cathodic(:,3); data_cathodic100_anodic(:,3) ], ...
    '-','Marker','.','MarkerSize',12)
hold on
errorbar([data_cathodic50_cathodic(:,1); -data_cathodic50_anodic(:,1)], ...
    [data_cathodic50_cathodic(:,2); -data_cathodic50_anodic(:,2)], ...
    [data_cathodic50_cathodic(:,3); data_cathodic50_anodic(:,3) ], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_cathodic25_cathodic(:,1); -data_cathodic25_anodic(:,1)], ...
    [data_cathodic25_cathodic(:,2); -data_cathodic25_anodic(:,2)], ...
    [data_cathodic25_cathodic(:,3); data_cathodic25_anodic(:,3) ], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_cathodic0_cathodic(:,1); -data_cathodic0_anodic(:,1)], ...
    [data_cathodic0_cathodic(:,2); -data_cathodic0_anodic(:,2)], ...
    [data_cathodic0_cathodic(:,3); data_cathodic0_anodic(:,3) ], ...
    '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
xline(0,'-','Color',[0.5 0.5 0.5])
yline(0,'-','Color',[0.5 0.5 0.5])
xticklabels({})
yticklabels({})
title('cathodic iDC','inhibition     excitation')
leg = legend('-100uA','-50uA','-25uA','0uA','Location','northwest');
title(leg,'baselines:')
ylim([-150 250])
box off


% anodic stim: plot eye velocity for each stim amplitude for a given stim baseline

isAnodic25 = contains(stimOffset,'25') & ~contains(stimOffset,'-25') & contains(stimOffset,'uA');
isAnodic50 = contains(stimOffset,'50') & ~contains(stimOffset,'-50') & contains(stimOffset,'uA');
isAnodic100 = contains(stimOffset,'100') & ~contains(stimOffset,'-100') & contains(stimOffset,'uA');

data_anodic25_cathodic = [stimAmp_cathodic(isAnodic25)...
    eyeVel_cathodic(isAnodic25)...
    eyeVel_cathodic_std(isAnodic25)...
    misalignment_cathodic(isAnodic25)...
    misalignment_cathodic_std(isAnodic25)...
    ];

data_anodic50_cathodic = [stimAmp_cathodic(isAnodic50)...
    eyeVel_cathodic(isAnodic50)...
    eyeVel_cathodic_std(isAnodic50)...
    misalignment_cathodic(isAnodic50)...
    misalignment_cathodic_std(isAnodic50)...
    ];

data_anodic100_cathodic = [stimAmp_cathodic(isAnodic100)...
    eyeVel_cathodic(isAnodic100)...
    eyeVel_cathodic_std(isAnodic100)...
    misalignment_cathodic(isAnodic100)...
    misalignment_cathodic_std(isAnodic100)...
    ];

data_anodic25_cathodic = sortrows(data_anodic25_cathodic);
maxModulation = min(data_anodic25_cathodic(:,1));
data_anodic25_cathodic(:,1) = (data_anodic25_cathodic(:,1)/maxModulation) * 100;

data_anodic50_cathodic = sortrows(data_anodic50_cathodic);
maxModulation = min(data_anodic50_cathodic(:,1));
data_anodic50_cathodic(:,1) = (data_anodic50_cathodic(:,1)/maxModulation) * 100;

data_anodic100_cathodic = sortrows(data_anodic100_cathodic);
maxModulation = min(data_anodic100_cathodic(:,1));
data_anodic100_cathodic(:,1) = (data_anodic100_cathodic(:,1)/maxModulation) * 100;

data_anodic25_anodic = [stimAmp_anodic(isAnodic25)...
    eyeVel_anodic(isAnodic25)...
    eyeVel_anodic_std(isAnodic25)...
    misalignment_anodic(isAnodic25)...
    misalignment_anodic_std(isAnodic25)...
    ];
% make sure eye velocity direction is correct
if any(data_anodic25_anodic(:,4) > 90)
    idx = data_anodic25_anodic(:,4) > 90;
    data_anodic25_anodic(idx,2) = -data_anodic25_anodic(idx,2);
end

data_anodic50_anodic = [stimAmp_anodic(isAnodic50)...
    eyeVel_anodic(isAnodic50)...
    eyeVel_anodic_std(isAnodic50)...
    misalignment_anodic(isAnodic50)...
    misalignment_anodic_std(isAnodic50)...
    ];
% make sure eye velocity direction is correct
if any(data_anodic50_anodic(:,4) > 90)
    idx = data_anodic50_anodic(:,4) > 90;
    data_anodic50_anodic(idx,2) = -data_anodic50_anodic(idx,2);
end

data_anodic100_anodic = [stimAmp_anodic(isAnodic100)...
    eyeVel_anodic(isAnodic100)...
    eyeVel_anodic_std(isAnodic100)...
    misalignment_anodic(isAnodic100)...
    misalignment_anodic_std(isAnodic100)...
    ];
% make sure eye velocity direction is correct
if any(data_anodic100_anodic(:,4) > 90)
    idx = data_anodic100_anodic(:,4) > 90;
    data_anodic100_anodic(idx,2) = -data_anodic100_anodic(idx,2);
end

data_anodic25_anodic = sortrows(data_anodic25_anodic);
maxModulation = max(data_anodic25_anodic(:,1));
data_anodic25_anodic(:,1) = (data_anodic25_anodic(:,1)/maxModulation) * 100;

data_anodic50_anodic = sortrows(data_anodic50_anodic);
maxModulation = max(data_anodic50_anodic(:,1));
data_anodic50_anodic(:,1) = (data_anodic50_anodic(:,1)/maxModulation) * 100;

data_anodic100_anodic = sortrows(data_anodic100_anodic);
maxModulation = max(data_anodic100_anodic(:,1));
data_anodic100_anodic(:,1) = (data_anodic100_anodic(:,1)/maxModulation) * 100;

nexttile,
errorbar([data_anodic100_cathodic(:,1); -data_anodic100_anodic(:,1)], ...
    [data_anodic100_cathodic(:,2); -data_anodic100_anodic(:,2)], ...
    [data_anodic100_cathodic(:,3); data_anodic100_anodic(:,3) ], ...
    '-','Marker','.','MarkerSize',12)
hold on
errorbar([data_anodic50_cathodic(:,1); -data_anodic50_anodic(:,1)], ...
    [data_anodic50_cathodic(:,2); -data_anodic50_anodic(:,2)], ...
    [data_anodic50_cathodic(:,3); data_anodic50_anodic(:,3) ], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_anodic25_cathodic(:,1); -data_anodic25_anodic(:,1)], ...
    [data_anodic25_cathodic(:,2); -data_anodic25_anodic(:,2)], ...
    [data_anodic25_cathodic(:,3); data_anodic25_anodic(:,3) ], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_cathodic0_cathodic(:,1); -data_cathodic0_anodic(:,1)], ...
    [data_cathodic0_cathodic(:,2); -data_cathodic0_anodic(:,2)], ...
    [data_cathodic0_cathodic(:,3); data_cathodic0_anodic(:,3) ], ...
    '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
xline(0,'-','Color',[0.5 0.5 0.5])
yline(0,'-','Color',[0.5 0.5 0.5])
title('anodic iDC','inhibition     excitation')
% ylabel('maximum eye velocity (dps)')
xticklabels({})
yticklabels({})
leg = legend('100uA','50uA','25uA','0uA','Location','northwest');
title(leg,'baselines:')
ylim([-150 250])
box off



% misalignment
nexttile,
errorbar([data_PFM300_excitatory(:,1); -data_PFM300_inhibitory(:,1)], ...
    [data_PFM300_excitatory(:,4); data_PFM300_inhibitory(:,4)], ...
    [data_PFM300_excitatory(:,5); data_PFM300_inhibitory(:,5)], ...
    '-','Marker','.','MarkerSize',12)
hold on
errorbar([data_PFM200_excitatory(:,1); -data_PFM200_inhibitory(:,1)], ...
    [data_PFM200_excitatory(:,4); data_PFM200_inhibitory(:,4)], ...
    [data_PFM200_excitatory(:,5); data_PFM200_inhibitory(:,5)], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_PFM100_excitatory(:,1); -data_PFM100_inhibitory(:,1)], ...
    [data_PFM100_excitatory(:,4); data_PFM100_inhibitory(:,4)], ...
    [data_PFM100_excitatory(:,5); data_PFM100_inhibitory(:,5)], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_PFM0_excitatory(:,1); -data_PFM0_inhibitory(:,1)], ...
    [data_PFM0_excitatory(:,4); data_PFM0_inhibitory(:,4)], ...
    [data_PFM0_excitatory(:,5); data_PFM0_inhibitory(:,5)], ...
    '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
yline(90,'--','Color',[0.8 0.8 0.8])
xline(0,'-','Color',[0.5 0.5 0.5])
xlabel('pulse frequency modulation (%)')
ylabel('misalignment (degs)')
ylim([0 200])
box off

nexttile,
errorbar([data_cathodic100_cathodic(:,1); -data_cathodic100_anodic(:,1)], ...
    [data_cathodic100_cathodic(:,4); data_cathodic100_anodic(:,4)], ...
    [data_cathodic100_cathodic(:,5); data_cathodic100_anodic(:,5) ], ...
    '-','Marker','.','MarkerSize',12)
hold on
errorbar([data_cathodic50_cathodic(:,1); -data_cathodic50_anodic(:,1)], ...
    [data_cathodic50_cathodic(:,4); data_cathodic50_anodic(:,4)], ...
    [data_cathodic50_cathodic(:,5); data_cathodic50_anodic(:,5) ], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_cathodic25_cathodic(:,1); -data_cathodic25_anodic(:,1)], ...
    [data_cathodic25_cathodic(:,4); data_cathodic25_anodic(:,4)], ...
    [data_cathodic25_cathodic(:,5); data_cathodic25_anodic(:,5) ], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_cathodic0_cathodic(:,1); -data_cathodic0_anodic(:,1)], ...
    [data_cathodic0_cathodic(:,4); data_cathodic0_anodic(:,4)], ...
    [data_cathodic0_cathodic(:,5); data_cathodic0_anodic(:,5) ], ...
    '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
yline(90,'--','Color',[0.8 0.8 0.8])
xline(0,'-','Color',[0.5 0.5 0.5])
xlabel('current modulation (%)')
ylim([0 200])
yticklabels({})
box off

nexttile,
errorbar([data_anodic100_cathodic(:,1); -data_anodic100_anodic(:,1)], ...
    [data_anodic100_cathodic(:,4); data_anodic100_anodic(:,4)], ...
    [data_anodic100_cathodic(:,5); data_anodic100_anodic(:,5) ], ...
    '-','Marker','.','MarkerSize',12)
hold on
errorbar([data_anodic50_cathodic(:,1); -data_anodic50_anodic(:,1)], ...
    [data_anodic50_cathodic(:,4); data_anodic50_anodic(:,4)], ...
    [data_anodic50_cathodic(:,5); data_anodic50_anodic(:,5) ], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_anodic25_cathodic(:,1); -data_anodic25_anodic(:,1)], ...
    [data_anodic25_cathodic(:,4); data_anodic25_anodic(:,4)], ...
    [data_anodic25_cathodic(:,5); data_anodic25_anodic(:,5) ], ...
    '-','Marker','.','MarkerSize',12)
errorbar([data_cathodic0_cathodic(:,1); -data_cathodic0_anodic(:,1)], ...
    [data_cathodic0_cathodic(:,4); data_cathodic0_anodic(:,4)], ...
    [data_cathodic0_cathodic(:,5); data_cathodic0_anodic(:,5) ], ...
    '-','Marker','.','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
yline(90,'--','Color',[0.8 0.8 0.8])
xline(0,'-','Color',[0.5 0.5 0.5])
xlabel('current modulation (%)')
ylim([0 200])
yticklabels({})
box off


%% plot ratio between excitation and inhibition
figure,
tcl = tiledlayout(1,3,'TileSpacing','tight');
title(tcl,'inhibition/excitation ratio','trapezoidal eeVOR,250ms stim, 150ms plateau, 750ms between stim')

% PFM
nexttile,
plot(data_PFM300_inhibitory(:,1),data_PFM300_inhibitory(:,2)./flip(data_PFM300_excitatory(:,2)),'.-','MarkerSize',12)
hold on
plot(data_PFM200_inhibitory(:,1),data_PFM200_inhibitory(:,2)./flip(data_PFM200_excitatory(:,2)),'.-','MarkerSize',12)
plot(data_PFM100_inhibitory(:,1),data_PFM100_inhibitory(:,2)./flip(data_PFM100_excitatory(:,2)),'.-','MarkerSize',12)
plot(data_PFM0_inhibitory(:,1),data_PFM0_inhibitory(:,2)./flip(data_PFM0_excitatory(:,2)),'.-','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
xlabel('current modulation (%)')
title('PFM')
leg = legend('-100uA','-50uA','-25uA','0uA','Location','northwest');
title(leg,'baselines:')
box off

% cathodic iDC
nexttile,
plot(data_cathodic100_anodic(:,1),data_cathodic100_anodic(:,2)./flip(data_cathodic100_cathodic(:,2)),'.-','MarkerSize',12)
hold on
plot(data_cathodic50_anodic(:,1),data_cathodic50_anodic(:,2)./flip(data_cathodic50_cathodic(:,2)),'.-','MarkerSize',12)
plot(data_cathodic25_anodic(:,1),data_cathodic25_anodic(:,2)./flip(data_cathodic25_cathodic(:,2)),'.-','MarkerSize',12)
plot(data_cathodic0_anodic(:,1),data_cathodic0_anodic(:,2)./flip(data_cathodic0_cathodic(:,2)),'.-','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
xlabel('current modulation (%)')
title('cathodic iDC')
leg = legend('-100uA','-50uA','-25uA','0uA','Location','northeast');
title(leg,'baselines:')
box off

% anodic iDC
nexttile,
plot(data_anodic100_anodic(:,1),data_anodic100_anodic(:,2)./flip(data_anodic100_cathodic(:,2)),'.-','MarkerSize',12)
hold on
plot(data_anodic50_anodic(:,1),data_anodic50_anodic(:,2)./flip(data_anodic50_cathodic(:,2)),'.-','MarkerSize',12)
plot(data_anodic25_anodic(:,1),data_anodic25_anodic(:,2)./flip(data_anodic25_cathodic(:,2)),'.-','MarkerSize',12)
plot(data_cathodic0_anodic(:,1),data_cathodic0_anodic(:,2)./flip(data_cathodic0_cathodic(:,2)),'.-','MarkerSize',12)
set(gca, 'ColorOrder', colormap(gray(5)))
xlabel('current modulation (%)')
title('anodic iDC')
leg = legend('-100uA','-50uA','-25uA','0uA','Location','northeast');
title(leg,'baselines:')
box off



%% plot cycle averages

dataPaths = {dir(fullfile(filepath,'*.mat')).name}';

filestoplot = dataPaths(contains(dataPaths,'Amp1_-25_Amp2_25'));

for iCycle = 1:length(filestoplot)
    data_temp = load(fullfile(filepath,filestoplot{iCycle})).Data;

    keepCycles = str2double(data_temp.KeepCycleNums);

    yaxis_min = -50;%floor(min([data_temp.RE_LARP_cycavg' data_temp.RE_RALP_cycavg' data_temp.RE_Z_cycavg'])/100)*100;
    yaxis_max = 50;%ceil(max([data_temp.RE_LARP_cycavg' data_temp.RE_RALP_cycavg' data_temp.RE_Z_cycavg'])/100)*100;

    yaxis_min_stim = floor(min(data_temp.Waveform)/100)*100;
    yaxis_max_stim = ceil(max(data_temp.Waveform)/100)*100;

    figure("Position",[700 300 350 500])
    tcl = tiledlayout(4,10,'TileSpacing','none');


    nexttile([1 5]);
    trace_color = [0.4660 0.6740 0.1880];
    yline(0,'--','Color',[0.5 0.5 0.5])
    hold on
    plot(data_temp.RE_Velocity_LARP_Cycles(1:399,keepCycles),'Color',[0.4660 0.6740 0.1880 0.3])
    plot(data_temp.RE_LARP_cycavg(1:399),'Color',trace_color,'LineWidth',2)
    p = shadedErrorBar([1:399],data_temp.RE_LARP_cycavg(1:399),data_temp.RE_LARP_cycstd(1:399),'lineprops',...
        {'r-','MarkerFaceColor',trace_color});
    set(p.edge,'LineWidth',1,'color',[0.4660 0.6740 0.1880 0.5])
    set(p.patch,'facecolor',trace_color)
    set(p.mainLine,'color',trace_color)
    set(p.mainLine,'LineWidth',2)
    set(p.edge,'LineStyle','-')
    set(p.mainLine,'LineStyle','-')
    xticklabels({})
    yticks(yaxis_min:100:yaxis_max)
    ylim([yaxis_min-40 yaxis_max+40])
    box off
    xlim([1 399])
    title('excitatiory (cathodic)')


    nexttile([1 5]);
    yline(0,'--','Color',[0.5 0.5 0.5])
    hold on
    plot([1000:1399],data_temp.RE_Velocity_LARP_Cycles(1000:1399,keepCycles),'Color',[0.4660 0.6740 0.1880 0.3])
    plot([1000:1399],data_temp.RE_LARP_cycavg(1000:1399),'Color',trace_color,'LineWidth',2)
    p = shadedErrorBar([1000:1399],data_temp.RE_LARP_cycavg(1000:1399),data_temp.RE_LARP_cycstd(1000:1399),'lineprops',...
        {'r-','MarkerFaceColor',trace_color});
    set(p.edge,'LineWidth',1,'color',[0.4660 0.6740 0.1880 0.5])
    set(p.patch,'facecolor',trace_color)
    set(p.mainLine,'color',trace_color)
    set(p.mainLine,'LineWidth',2)
    set(p.edge,'LineStyle','-')
    set(p.mainLine,'LineStyle','-')
    yticklabels({})
    xticklabels({})
    yticks([])
    ylim([yaxis_min-40 yaxis_max+40])
    box off
    xlim([1000 1399])
    title('inhibitory (anodic)')
    yline(0,'--','Color',[0.5 0.5 0.5])


    nexttile([1 5]);
    trace_color = [0 0.4470 0.7410];
    yline(0,'--','Color',[0.5 0.5 0.5])
    hold on
    plot(data_temp.RE_Velocity_RALP_Cycles(1:399,keepCycles),'Color',[0 0.4470 0.7410 0.3])
    plot(data_temp.RE_RALP_cycavg(1:399),'Color',trace_color,'LineWidth',2)
    p = shadedErrorBar([1:399],data_temp.RE_RALP_cycavg(1:399),data_temp.RE_RALP_cycstd(1:399),'lineprops',...
        {'r-','MarkerFaceColor',trace_color});
    set(p.edge,'LineWidth',1,'color',[0 0.4470 0.7410 0.5])
    set(p.patch,'facecolor',trace_color)
    set(p.mainLine,'color',trace_color)
    set(p.mainLine,'LineWidth',2)
    set(p.edge,'LineStyle','-')
    set(p.mainLine,'LineStyle','-')
    ylabel('eye velocity (dps)')
    xticklabels({})
    ylim([yaxis_min-40 yaxis_max+40])
    yticks(yaxis_min:100:yaxis_max)
    xlim([1 399])

    nexttile([1 5]);
    yline(0,'--','Color',[0.5 0.5 0.5])
    hold on
    plot([1000:1399],data_temp.RE_Velocity_RALP_Cycles(1000:1399,keepCycles),'Color',[0 0.4470 0.7410 0.3])
    plot([1000:1399],data_temp.RE_RALP_cycavg(1000:1399),'Color',trace_color,'LineWidth',2)
    p = shadedErrorBar([1000:1399],data_temp.RE_RALP_cycavg(1000:1399),data_temp.RE_RALP_cycstd(1000:1399),'lineprops',...
        {'r-','MarkerFaceColor',trace_color});
    set(p.edge,'LineWidth',1,'color',[0 0.4470 0.7410 0.5])
    set(p.patch,'facecolor',trace_color)
    set(p.mainLine,'color',trace_color)
    set(p.mainLine,'LineWidth',2)
    set(p.edge,'LineStyle','-')
    set(p.mainLine,'LineStyle','-')
    yticklabels({})
    xticklabels({})
    ylim([yaxis_min-40 yaxis_max+40])
    yticks([])
    xlim([1000 1399])


    nexttile([1 5]);
    trace_color = [0.6350 0.0780 0.1840];
    yline(0,'--','Color',[0.5 0.5 0.5])
    hold on
    plot(data_temp.RE_Velocity_Z_Cycles(1:399,keepCycles),'Color',[0.6350 0.0780 0.1840 0.3])
    plot(data_temp.RE_Z_cycavg(1:399),'Color',trace_color,'LineWidth',2)
    p = shadedErrorBar([1:399],data_temp.RE_Z_cycavg(1:399),data_temp.RE_Z_cycstd(1:399),'lineprops',...
        {'r-','MarkerFaceColor',trace_color});
    set(p.edge,'LineWidth',1,'color',[0.6350 0.0780 0.1840 0.5])
    set(p.patch,'facecolor',trace_color)
    set(p.mainLine,'color',trace_color)
    set(p.mainLine,'LineWidth',2)
    set(p.edge,'LineStyle','-')
    set(p.mainLine,'LineStyle','-')
    ylim([yaxis_min yaxis_max])
    ylim([yaxis_min-40 yaxis_max+40])
    xticklabels({})
    xlim([1 399])

    nexttile([1 5]);
    yline(0,'--','Color',[0.5 0.5 0.5])
    hold on
    plot([1000:1399],data_temp.RE_Velocity_Z_Cycles(1000:1399,keepCycles),'Color',[0.6350 0.0780 0.1840 0.3])
    plot([1000:1399],data_temp.RE_Z_cycavg(1000:1399),'Color',trace_color,'LineWidth',2)
    p = shadedErrorBar([1000:1399],data_temp.RE_Z_cycavg(1000:1399),data_temp.RE_Z_cycstd(1000:1399),'lineprops',...
        {'r-','MarkerFaceColor',trace_color});
    set(p.edge,'LineWidth',1,'color',[0.6350 0.0780 0.1840 0.5])
    set(p.patch,'facecolor',trace_color)
    set(p.mainLine,'color',trace_color)
    set(p.mainLine,'LineWidth',2)
    set(p.edge,'LineStyle','-')
    set(p.mainLine,'LineStyle','-')
    ylim([yaxis_min-40 yaxis_max+40])
    yticks([])
    xticklabels({})
    xlim([1000 1399])

    nexttile([1 5]);
    plot([1:399],data_temp.Waveform(1:399),'k','LineWidth',2)
    ylabel('current (uA)')
    xlabel('time(ms)')
    ylim([yaxis_min_stim-40 yaxis_max_stim+40])
    xlim([0 399])
    yticks(yaxis_min_stim:150:yaxis_max_stim)

    nexttile([1 5]);
    plot([1000:1399],data_temp.Waveform(1000:1399),'k','LineWidth',2)
    xlabel('time(ms)')
    ylim([yaxis_min_stim-40 yaxis_max_stim+40])
    xlim([1000 1399])
    yticks([])


    if contains(filestoplot{iCycle},'-100uA')
        title(tcl,'-100uA baseline +/- 200uA')
    elseif contains(filestoplot{iCycle},'100uA')
        title(tcl,'100uA baseline +/- 200uA')
    else
        title(tcl,'0uA baseline +/- 25uA')
    end
end

%%

dataPaths = {dir(fullfile(cyclesPath,'*.mat')).name}';

filestoplot = dataPaths(contains(dataPaths,'Amp1_-25_Amp2_25'));

for iCycle = 1:length(filestoplot)
    data_temp = load(fullfile(cyclesPath,filestoplot{iCycle})).Data;

    keepCycles = str2double(data_temp.KeepCycleNums);

    yaxis_min = -200;%floor(min([data_temp.RE_LARP_cycavg' data_temp.RE_RALP_cycavg' data_temp.RE_Z_cycavg'])/100)*100;
    yaxis_max = 100;%ceil(max([data_temp.RE_LARP_cycavg' data_temp.RE_RALP_cycavg' data_temp.RE_Z_cycavg'])/100)*100;

    yaxis_min_stim = floor(min(data_temp.Waveform)/100)*100;
    yaxis_max_stim = ceil(max(data_temp.Waveform)/100)*100;

    figure,
    tcl = tiledlayout(4,9,'TileSpacing','none');


    nexttile([1 9]);
    trace_color = [0.4660 0.6740 0.1880];
    plot(data_temp.RE_Velocity_LARP_Cycles(:,keepCycles),'Color',[0.4660 0.6740 0.1880 0.3])
    hold on
    plot(data_temp.RE_LARP_cycavg,'Color',trace_color,'LineWidth',2)
    p = shadedErrorBar([1:2000],data_temp.RE_LARP_cycavg,data_temp.RE_LARP_cycstd,'lineprops',...
        {'r-','MarkerFaceColor',trace_color});
    set(p.edge,'LineWidth',1,'color',[0.4660 0.6740 0.1880 0.5])
    set(p.patch,'facecolor',trace_color)
    set(p.mainLine,'color',trace_color)
    set(p.mainLine,'LineWidth',2)
    set(p.edge,'LineStyle','-')
    set(p.mainLine,'LineStyle','-')
    xticklabels({})
    yticks(yaxis_min:100:yaxis_max)
    ylim([yaxis_min-40 yaxis_max+40])
    box off
    title('excitatiory (cathodic) stimulus')



    nexttile([1 9]);
    trace_color = [0 0.4470 0.7410];
    plot(data_temp.RE_Velocity_RALP_Cycles(:,keepCycles),'Color',[0 0.4470 0.7410 0.3])
    hold on
    plot(data_temp.RE_RALP_cycavg,'Color',trace_color,'LineWidth',2)
    p = shadedErrorBar([1:2000],data_temp.RE_RALP_cycavg,data_temp.RE_RALP_cycstd,'lineprops',...
        {'r-','MarkerFaceColor',trace_color});
    set(p.edge,'LineWidth',1,'color',[0 0.4470 0.7410 0.5])
    set(p.patch,'facecolor',trace_color)
    set(p.mainLine,'color',trace_color)
    set(p.mainLine,'LineWidth',2)
    set(p.edge,'LineStyle','-')
    set(p.mainLine,'LineStyle','-')
    xticklabels({})
    yticks(yaxis_min:100:yaxis_max)
    ylim([yaxis_min-40 yaxis_max+40])




    nexttile([1 9]);
    trace_color = [0.6350 0.0780 0.1840];
    plot(data_temp.RE_Velocity_Z_Cycles(:,keepCycles),'Color',[0.6350 0.0780 0.1840 0.3])
    hold on
    plot(data_temp.RE_Z_cycavg,'Color',trace_color,'LineWidth',2)
    p = shadedErrorBar([1:2000],data_temp.RE_Z_cycavg,data_temp.RE_Z_cycstd,'lineprops',...
        {'r-','MarkerFaceColor',trace_color});
    set(p.edge,'LineWidth',1,'color',[0.6350 0.0780 0.1840 0.5])
    set(p.patch,'facecolor',trace_color)
    set(p.mainLine,'color',trace_color)
    set(p.mainLine,'LineWidth',2)
    set(p.edge,'LineStyle','-')
    set(p.mainLine,'LineStyle','-')
    ylim([yaxis_min-40 yaxis_max+40])
    yticks(yaxis_min:100:yaxis_max)
    xticklabels({})

    nexttile([1 9]);
    plot(data_temp.Waveform,'k','LineWidth',2)
    ylabel('current (uA)')
    xlabel('time(ms)')
    ylim([yaxis_min_stim-40 yaxis_max_stim+40])
    yticks(yaxis_min_stim:100:yaxis_max_stim)

    if contains(filestoplot{iCycle},'-100uA')
        title(tcl,'-100uA baseline +/- 200uA')
    elseif contains(filestoplot{iCycle},'100uA')
        title(tcl,'100uA baseline +/- 200uA')
    else
        title(tcl,'0uA baseline +/- 200uA')
    end
end


%%
data_temp = load(fullfile(cyclesPath,filestoplot{iCycle})).Data;

t = [1:length(data_temp.RE_Velocity_LARP_Cycles)]/1000;
cyclestokeep = str2double(data_temp.KeepCycleNums);

figure,
plot(t,data_temp.RE_Velocity_LARP_Cycles(:,cyclestokeep),'Color',[0.4660 0.6740 0.1880 0.3])
hold on
plot(t,data_temp.RE_Velocity_RALP_Cycles(:,cyclestokeep),'Color',[0 0.4470 0.7410 0.3])
plot(t,data_temp.RE_Velocity_Z_Cycles(:,cyclestokeep),'Color',[0.6350 0.0780 0.1840 0.3])

title('Z axis response w/ saccades', '-100uA baseline +/- 200uA  trapezoids')
ylabel('eye velocity (dps)')
xlabel('time (s)')
xlim([0 max(t)])