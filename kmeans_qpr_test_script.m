%% load data 
filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data\20240216 Pearl DC trapz with baseline amphetamines';
isDC = 1;
isAdaptation = 0;
isNystagmus = 0;

segmentsPath = fullfile(filepath,'Segments');

dataPaths = {dir(fullfile(segmentsPath,'*.mat')).name}';
nFiles = length(dataPaths);

filt_window = 20;
iFile = 1;
data_temp = load(fullfile(segmentsPath,dataPaths{iFile})).Data;

filtLARP = movmean(data_temp.RE_Velocity_LARP,filt_window);
filtRALP = movmean(data_temp.RE_Velocity_RALP,filt_window);
filtZ = movmean(data_temp.RE_Velocity_Z,filt_window);

waveformLength_ms = 150 + 750 + 150 ...
    + 750 + (4 * 50);

for i = 1:20
    eyeVelLARP_cycles(i,:) = filtLARP(((i-1)*waveformLength_ms)+1:(i*waveformLength_ms));
    eyeVelRALP_cycles(i,:) = filtRALP(((i-1)*waveformLength_ms)+1:(i*waveformLength_ms));
    eyeVelZ_cycles(i,:) = filtZ(((i-1)*waveformLength_ms)+1:(i*waveformLength_ms));
end

%% plot data w/ saccades

% figure, plot(filtZ)


waveformInfo = strsplit(dataPaths{iFile},{'_','Offs','uA'});
offset = str2double(waveformInfo{7});
low_amp = offset + str2double(waveformInfo{4});
high_amp = offset + str2double(waveformInfo{6});

waveform = [interp1([1 50],[offset low_amp],[1:50],'linear'), ...
    repmat(low_amp,1,150), ...
    interp1([201 250],[low_amp offset],[201:250],'linear'), ...
    repmat(offset,1,750), ...
    interp1([1001 1050],[offset high_amp],[1001:1050],'linear'), ...
    repmat(high_amp,1,150), ...
    interp1([1201 1250],[high_amp offset],[1201:1250],'linear') ...
    repmat(offset,1,750), ...
    ];

%% plot data w/o saccades

eyeVelZ_cycles_median = median(eyeVelZ_cycles);
low_amp = min(eyeVelZ_cycles_median(1:1000));
high_amp = max(eyeVelZ_cycles_median(1000:end));

t = 1:length(filtZ(1:end-1));
waveform_rescaled = -repmat([interp1([1 50],[0 low_amp],[1:50],'linear'), ...
    repmat(low_amp,1,150), ...
    interp1([201 250],[low_amp 0],[201:250],'linear'), ...
    repmat(0,1,750), ...
    interp1([1001 1050],[0 high_amp],[1001:1050],'linear'), ...
    repmat(high_amp,1,150), ...
    interp1([1201 1250],[high_amp 0],[1201:1250],'linear') ...
    repmat(0,1,750), ...
    ],1,20);

% figure, plot(waveform_rescaled)
eyeVeldata(:,1) = t/1000;
eyeVeldata(:,2) = sign(waveform_rescaled').*filtZ(1:end-1);
[qpr_clusters C] = kmeans(eyeVeldata,2,'Replicates',50);

% figure, plot(eyeVelZ_cycles','k')

% figure, 
% plot(t(qpr_clusters==1),filtZ(qpr_clusters==1),'.r')
% hold on
% plot(t(qpr_clusters==2),filtZ(qpr_clusters==2),'.g')


% spline over quick phases
qp_idx = find(qpr_clusters==2);
D = diff([0,diff(qp_idx')==1,0]);
start_qp = qp_idx(D>0);
end_qp = qp_idx(D<0);

nQPs = length(start_qp);
nQPs_last = 0;
while nQPs ~= nQPs_last
    nQPs_last = length(start_qp);
    for iQP = 1:length(start_qp)
        % combine qps that are close together
        if iQP + 1 <= length(start_qp) && end_qp(iQP) + 100 >= start_qp(iQP+1)
            end_qp(iQP) = end_qp(iQP+1);
            start_qp(iQP + 1) = [];
            end_qp(iQP + 1) = [];
        end
    end
    nQPs = length(start_qp);
end

t_noqp = t;
filtLARP_noqp = filtLARP(1:end-1);
filtRALP_noqp = filtRALP(1:end-1);
filtZ_noqp = filtZ(1:end-1);
qp_times = [];
% THIS TREATS Z AS THE PRIORITY AXIS!!!
for iQP = 1:length(start_qp)-1
    qp_removal_start_idx = find(t_noqp == start_qp(iQP))-30;
    qp_removal_end_idx = find(t_noqp == end_qp(iQP)+70);
    
    if qp_removal_start_idx <= 0
        qp_removal_start_idx = 1;
    end
    if qp_removal_end_idx > length(t_noqp)
        qp_removal_end_idx = t_noqp(end);
    end

    qp_range_temp = qp_removal_start_idx:qp_removal_end_idx;
    t_noqp(qp_range_temp) = [];
    filtLARP_noqp(qp_range_temp) = [];
    filtRALP_noqp(qp_range_temp) = [];
    filtZ_noqp(qp_range_temp) = [];

%     filtZ_spline_temp = interp1(t_noqp,filtZ_noqp',qp_range_temp,'spline');
% 
    qp_range_start = start_qp(iQP)-30;
    qp_range_end = end_qp(iQP)+70;

    if  qp_range_start <= 0
        qp_range_start = 1;
    end
    if qp_range_end > length(t)
        qp_range_end = t(end);
    end
    qp_range = [qp_range_start : qp_range_end];

    qp_times = [qp_times qp_range];
%     filtZ_spline = [filtZ_spline filtZ_spline_temp];
end

% figure, 
% plot(filtZ,'r.')
% hold on
% plot(t_noqp,filtZ_noqp,'g.')
% 
% figure, plot(t_noqp,filtZ_noqp,'.r')
% hold on
% plot(qp_times, zeros(1,length(qp_times),1),'.g')

filtLARP_spline = [];
filtRALP_spline = [];
filtZ_spline = [];

filtLARP_spline = interp1(t_noqp,filtLARP_noqp,qp_times,'pchip');
filtRALP_spline = interp1(t_noqp,filtRALP_noqp,qp_times,'pchip');
filtZ_spline = interp1(t_noqp,filtZ_noqp,qp_times,'pchip');
% combine spline and no qp data
filtLARP_qp_removed = [];
filtRALP_qp_removed = [];
filtZ_qp_removed = [];

t_unsorted = [];
t_unsorted = [qp_times t_noqp]';
filtLARP_qp_removed = [filtLARP_spline filtLARP_noqp']';
filtRALP_qp_removed = [filtRALP_spline filtRALP_noqp']';
filtZ_qp_removed = [filtZ_spline filtZ_noqp']';

% sort data traces
sorted_idx = [];
[~,sorted_idx] = sort(t_unsorted,'ascend');

filtLARP_qp_removed = filtLARP_qp_removed(sorted_idx,:);
filtRALP_qp_removed = filtRALP_qp_removed(sorted_idx,:);
filtZ_qp_removed = filtZ_qp_removed(sorted_idx,:);

% reshape into cycles
filtLARP_qp_removed_cycles = reshape(filtLARP_qp_removed,[],20);
filtRALP_qp_removed_cycles = reshape(filtRALP_qp_removed,[],20);
filtZ_qp_removed_cycles = reshape(filtZ_qp_removed,[],20);


%% plot data before kmeans clustering to filter QPRs
responseSize = max(abs(median(eyeVelZ_cycles)));
yaxisrange = [-ceil(responseSize/100)*100 ceil(responseSize/100)*100];
figure;
tiledlayout(4,9,'TileSpacing','none')
% LARP
nexttile([1 9]);
plot(eyeVelLARP_cycles','k')
hold on
plot(median(eyeVelLARP_cycles),'g','LineWidth',3)
xticks([])
title('before kmeans clustering to filter QPRs')
ylim(yaxisrange)
% RALP
nexttile([1 9]);
plot(eyeVelRALP_cycles','k')
hold on
plot(median(eyeVelRALP_cycles),'b','LineWidth',3)
xticks([])
ylabel('eye velocity (dps)')
ylim(yaxisrange)
%Z
nexttile([1 9]);
plot(eyeVelZ_cycles','k')
hold on
plot(median(eyeVelZ_cycles),'r','LineWidth',3)
xticks([])
ylim(yaxisrange)

nexttile([1 9]);
plot(waveform,'k','LineWidth',2)
axis padded
xlim([0 length(waveform)])
ylabel('current (uA)')
xlabel('time (ms)')

%% plot data after kmeans clustering to filter QPRs
responseSize = max(abs(median(filtZ_qp_removed_cycles)));
yaxisrange = [-ceil(responseSize/100)*100 ceil(responseSize/100)*100];
figure;
tiledlayout(4,9,'TileSpacing','none')
% LARP
nexttile([1 9]);
plot(filtLARP_qp_removed_cycles,'k')
hold on
plot(median(filtLARP_qp_removed_cycles'),'g','LineWidth',3)
xticks([])
title('after kmeans clustering to filter QPRs')
ylim(yaxisrange)
% RALP
nexttile([1 9]);
plot(filtRALP_qp_removed_cycles,'k')
hold on
plot(median(filtRALP_qp_removed_cycles'),'b','LineWidth',3)
xticks([])
ylabel('eye velocity (dps)')
ylim(yaxisrange)
%Z
nexttile([1 9]);
plot(filtZ_qp_removed_cycles,'k')
hold on
plot(median(filtZ_qp_removed_cycles'),'r','LineWidth',3)
xticks([])
ylim(yaxisrange)

nexttile([1 9]);
plot(waveform,'k','LineWidth',2)
axis padded
xlim([0 length(waveform)])
ylabel('current (uA)')
xlabel('time (ms)')


%% plot data after kmeans clustering to filter QPRs
responseSize = max(abs(median(filtZ_qp_removed_cycles)));
yaxisrange = [-ceil(responseSize/100)*100 ceil(responseSize/100)*100];
figure;
tiledlayout(4,9,'TileSpacing','none')
% LARP
nexttile([1 9]);
plot(eyeVelLARP_cycles','k')
hold on
plot(median(filtLARP_qp_removed_cycles'),'g','LineWidth',3)
xticks([])
title('after kmeans clustering to filter QPRs')
ylim(yaxisrange)
% RALP
nexttile([1 9]);
plot(eyeVelRALP_cycles','k')
hold on
plot(median(filtRALP_qp_removed_cycles'),'b','LineWidth',3)
xticks([])
ylabel('eye velocity (dps)')
ylim(yaxisrange)
%Z
nexttile([1 9]);
plot(eyeVelZ_cycles','k')
hold on
plot(median(filtZ_qp_removed_cycles'),'r','LineWidth',3)
xticks([])
ylim(yaxisrange)

nexttile([1 9]);
plot(waveform,'k','LineWidth',2)
axis padded
xlim([0 length(waveform)])
ylabel('current (uA)')
xlabel('time (ms)')



%% remove saccades with median across cycle time points


kmeans_testData = load('R:\Vesper, Evan\Monkey DC eeVOR Data\kmeans_testData.mat').kmeans_testData;
filtZ = kmeans_testData.RE_Velocity_Z_filt;
filtLARP = kmeans_testData.RE_Velocity_LARP_filt;
filtRALP = kmeans_testData.RE_Velocity_RALP_filt;

for i = 1:20
    eyeVelLARP_cycles(i,:) = filtLARP(((i-1)*waveformLength_ms)+1:(i*waveformLength_ms));
    eyeVelRALP_cycles(i,:) = filtRALP(((i-1)*waveformLength_ms)+1:(i*waveformLength_ms));
    eyeVelZ_cycles(i,:) = filtZ(((i-1)*waveformLength_ms)+1:(i*waveformLength_ms));
end


eyeVelZ_cycles_median = median(eyeVelZ_cycles);
eyeVelZ_cycles_template = repmat(eyeVelZ_cycles_median,1,20);

eyeVeldata_median(:,1) = t/1000;
eyeVeldata_median(:,2) = sign(eyeVelZ_cycles_template').*filtZ(1:end-1);

% 
% eyeVeldata_median(:,1) = t/1000;
% eyeVeldata_median(:,2) = sign(-filtZ(1:end-1)).*filtZ(1:end-1);
[qpr_clusters_median,~] = kmeans(eyeVeldata_median,2,'Replicates',50);
% 
% figure,
% plot(t(qpr_clusters_median == 1 | qpr_clusters == 1), filtZ(qpr_clusters_median == 1 | qpr_clusters == 1), '.r')
% hold on
% plot(t(qpr_clusters_median == 2 & qpr_clusters == 2), filtZ(qpr_clusters_median == 2 & qpr_clusters == 2), '.b')
% 
% 

if sum(qpr_clusters==1) > sum(qpr_clusters==2)
    qpr_clusters_qp = qpr_clusters == 2;
else
    qpr_clusters_qp = qpr_clusters == 1;
end

if sum(qpr_clusters_median==1) > sum(qpr_clusters_median==2)
    qpr_clusters_median_qp = qpr_clusters_median == 2;
else
    qpr_clusters_median_qp = qpr_clusters_median == 1;
end


% spline over quick phases
qp_idx = find(qpr_clusters_median_qp);
D = diff([0,diff(qp_idx')==1,0]);
start_qp = qp_idx(D>0);
end_qp = qp_idx(D<0);

nQPs = length(start_qp);
nQPs_last = 0;
while nQPs ~= nQPs_last
    nQPs_last = length(start_qp);
    for iQP = 1:length(start_qp)
        % combine qps that are close together
        if iQP + 1 <= length(start_qp) && end_qp(iQP) + 100 >= start_qp(iQP+1)
            end_qp(iQP) = end_qp(iQP+1);
            start_qp(iQP + 1) = [];
            end_qp(iQP + 1) = [];
        end
    end
    nQPs = length(start_qp);
end

t_noqp = t;
filtLARP_noqp = filtLARP(1:end-1);
filtRALP_noqp = filtRALP(1:end-1);
filtZ_noqp = filtZ(1:end-1);
qp_times = [];
% THIS TREATS Z AS THE PRIORITY AXIS!!!
for iQP = 1:length(start_qp)-1
    qp_removal_start_idx = find(t_noqp == start_qp(iQP))-30;
    qp_removal_end_idx = find(t_noqp == end_qp(iQP)+70);
    
    if qp_removal_start_idx <= 0
        qp_removal_start_idx = 1;
    end
    if qp_removal_end_idx > length(t_noqp)
        qp_removal_end_idx = t_noqp(end);
    end

    qp_range_temp = qp_removal_start_idx:qp_removal_end_idx;
    t_noqp(qp_range_temp) = NaN;
    filtLARP_noqp(qp_range_temp) = NaN;
    filtRALP_noqp(qp_range_temp) = NaN;
    filtZ_noqp(qp_range_temp) = NaN;

%     filtZ_spline_temp = interp1(t_noqp,filtZ_noqp',qp_range_temp,'spline');
% 
    qp_range_start = start_qp(iQP)-10;
    qp_range_end = end_qp(iQP)+10;

    if  qp_range_start <= 0
        qp_range_start = 1;
    end
    if qp_range_end > length(t)
        qp_range_end = t(end);
    end
    qp_range = [qp_range_start : qp_range_end];

    qp_times = [qp_times qp_range];
%     filtZ_spline = [filtZ_spline filtZ_spline_temp];
end

% figure, 
% plot(filtZ,'r.')
% hold on
% plot(t_noqp,filtZ_noqp,'g.')
% 
% figure, plot(t_noqp,filtZ_noqp,'.r')
% hold on
% plot(qp_times, zeros(1,length(qp_times),1),'.g')

% filtLARP_spline = [];
% filtRALP_spline = [];
% filtZ_spline = [];
% 
% filtLARP_spline = interp1(t_noqp,filtLARP_noqp,qp_times,'pchip');
% filtRALP_spline = interp1(t_noqp,filtRALP_noqp,qp_times,'pchip');
% filtZ_spline = interp1(t_noqp,filtZ_noqp,qp_times,'pchip');
% % combine spline and no qp data
% filtLARP_qp_removed = [];
% filtRALP_qp_removed = [];
% filtZ_qp_removed = [];
% 
% t_unsorted = [];
% t_unsorted = [qp_times t_noqp]';
% filtLARP_qp_removed = [filtLARP_spline filtLARP_noqp']';
% filtRALP_qp_removed = [filtRALP_spline filtRALP_noqp']';
% filtZ_qp_removed = [filtZ_spline filtZ_noqp']';
% 
% % sort data traces
% sorted_idx = [];
% [~,sorted_idx] = sort(t_unsorted,'ascend');
% 
% filtLARP_qp_removed = filtLARP_qp_removed(sorted_idx,:);
% filtRALP_qp_removed = filtRALP_qp_removed(sorted_idx,:);
% filtZ_qp_removed = filtZ_qp_removed(sorted_idx,:);
% 
% % reshape into cycles
% filtLARP_qp_removed_cycles = reshape(filtLARP_qp_removed,[],20);
% filtRALP_qp_removed_cycles = reshape(filtRALP_qp_removed,[],20);
% filtZ_qp_removed_cycles = reshape(filtZ_qp_removed,[],20);


% reshape into cycles
filtLARP_qp_removed_cycles = reshape(filtLARP_noqp,[],20);
filtRALP_qp_removed_cycles = reshape(filtRALP_noqp,[],20);
filtZ_qp_removed_cycles = reshape(filtZ_noqp,[],20);

figure, plot(filtZ_noqp,'.')

ZVel_KeepCycles = filtZ_qp_removed_cycles(:,str2double(kmeans_testData.KeepCycleNums));
figure, plot(movmean(ZVel_KeepCycles,25),'k')

cathodic_mean = mean(min(movmedian(ZVel_KeepCycles(1:200,:),15)));
cathodic_std = std(min(movmedian(ZVel_KeepCycles(1:200,:),15)));

anodic_mean = mean(max(movmedian(ZVel_KeepCycles(1000:1200,:),15)));
anodic_std = std(max(movmedian(ZVel_KeepCycles(1000:1200,:),15)));

figure, plot(movmedian(ZVel_KeepCycles,25),'k')
hold on
plot(100,cathodic_mean,'*b')
plot(1100,anodic_mean,'*b')
