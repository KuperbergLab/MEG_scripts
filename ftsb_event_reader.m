function trl = ftsb_event_reader(cfg)
assert(isfield(cfg,'sb'),'cfg not loaded with .sb')
assert(isfield(cfg.sb,'eve'),'cfg.sb not loaded with eve')
assert(isfield(cfg.sb,'num'),'cfg.sb not loaded with num')
eve = load(cfg.sb.eve);

%must sync with events from fif
events = ft_read_event(cfg.dataset);

%start hacks
if strcmp(cfg.dataset,'/cluster/kuperberg/SemPrMM/MEG/data/ya16/ya16_ATLLoc_raw.fif')
    syncSamp = 10201;
elseif strcmp(cfg.dataset,'/cluster/kuperberg/SemPrMM/MEG/data/ya16/ya16_BaleenRun4_raw.fif')
    syncSamp = 45601;
elseif strcmp(cfg.dataset,'/cluster/kuperberg/SemPrMM/MEG/data/ya9/ya9_BaleenRun6_raw.fif')
else
    syncSamp = events(cell2mat({events.value}) == 13).sample;
end
%end hack
syncEveInd = find(eve(:,4) == 13);
%not sure why, but events(syncEventInd).sample and eve(1,syncEveInd) are
%not the same (maybe time we take to press "record raw"?)
offset  = eve(syncEveInd,1) - syncSamp;

eve_of_interest = find(eve(:,4) == cfg.sb.num);
fprintf('Found %d events of interest\n',length(eve_of_interest))
trl = zeros(length(eve_of_interest),3);
for ii = 1:length(eve_of_interest)
    ind = eve_of_interest(ii);
    trig_offset = cfg.sb.time(1);
    samp_to_add = cfg.sb.time(2);
    trl(ii,1) = eve(ind,1) - offset;
    trl(ii,2) = trl(ii,1) + samp_to_add;
    trl(ii,3) = trig_offset;
end
