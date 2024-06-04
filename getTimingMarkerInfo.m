function [stimTimingChan stimTimingType] = getTimingMarkerInfo(expDate)

filepath = 'R:\Vesper, Evan\Monkey DC eeVOR Data';
filename = 'Pearl eeVOR setup each day';
stimTimingTable = readtable(fullfile(filepath,filename),'NumHeaderLines',5);

isPhaseMarker = matches(stimTimingTable.PhaseMarker,'x');
isTeensyTrig = matches(stimTimingTable.TeensyTrigger,'x') & ~isPhaseMarker;
isTextMarker = matches(stimTimingTable.TextMarker,'x') & ~isTeensyTrig & ~isPhaseMarker;

dates = string(yyyymmdd(stimTimingTable.Date));
stimType = zeros(length(dates),1);

stimType(isTextMarker) = 1;
stimType(isTeensyTrig) = 2;
stimType(isPhaseMarker) = 3;

for iExp = find(matches(dates,expDate))
    switch stimType(iExp)
        case 1
            stimTimingType = 'TextMarker';
            stimTimingChan = 30;
        case 2
%             stimTimingType = 'TeensyTrig';
%             stimTimingChan = 15;

            stimTimingType = 'TextMarker';
            stimTimingChan = 30;
        case 3
            stimTimingType = 'PhaseMarker';
            stimTimingChan = 22;
    end
end

end