%% Load and plot central attenuation data

TabPulseCA = readtable('R:\Vesper, Evan\Monkey DC eeVOR Data\ExperimentRecords_62K_LH_PulseCentralAttenuation.csv');
TabPulseCARepeat = readtable('R:\Vesper, Evan\Monkey DC eeVOR Data\ExperimentRecords_62K_LH_PulseCentralAttenuationRepeat.csv');

TabiDCCA = readtable('R:\Vesper, Evan\Monkey DC eeVOR Data\ExperimentRecords_62K_LH_iDCCentralAttenuation.csv');
TabiDCCARepeat = readtable('R:\Vesper, Evan\Monkey DC eeVOR Data\ExperimentRecords_62K_LH_iDCCentralAttenuationRepeat.csv');

%% plot

clf(figure(1))
