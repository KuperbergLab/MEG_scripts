function writeEventFile(eventFileName, firstSamp, events, eventType)
% WRITEEVENTFILE: creates .eve text file (MNE) from a list of events
%
% USAGE:  writeEventFile(fid, firstSamp, lastSamp, sampRate, events, eventType);
%
% INPUT:
%   - eventFileName : name of file to save event
%   - firstSamp   : first valid sample of raw data (type double)
%   - event       : array of events (samples)
%   - eventType   : type of events (ie 1000)
% OUTPUT: 
%   _sss-eve.fif file with events (MNE format)
% Author: Sheraz Khan, PhD
%         Martinos Center
%         MGH, Boston, USA
% --------------------------- Script History ------------------------------
% SK 20-DEC-2010  Creation
% sheraz@nmr.mgh.harvard.edu


% Adjust the event samples for MNE
firstSamp = double(firstSamp);
adj_events = events+firstSamp;

% Include psuedo event
eventlist(1,1) = firstSamp;
eventlist(1,2) = 0;
eventlist(1,3) = 0;

% Include all other events
num_events = length(events);
eventlist(2:num_events+1,1) = adj_events;
eventlist(2:num_events+1,2) = zeros(1,num_events);
eventlist(2:num_events+1,3) = ones(1,num_events)*eventType;

% Write to .fif file
mne_write_events(eventFileName,eventlist);

end

