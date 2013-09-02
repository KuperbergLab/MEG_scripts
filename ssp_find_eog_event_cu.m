function ssp_find_eog_event_cu(subjID,exp, runnum)

%input file
%in_fif_File = infif;
%EOG Event file
%[~, name, ~] = fileparts(infif);
% [name1, remain]= strtok(name, '_');
% [name2, ~]=strtok(remain, '_');
% eog_eventFileName = [inpath, name1,'_', name2, '_eog-eve.fif'];


inpath = '/autofs/cluster/kuperberg/SemPrMM/MEG';

%in_fif_File = [inpath '/data/' subjID '/' subjID '_' exp,runnum,'_raw.fif'];
in_fif_File = [inpath '/data/' subjID '/' subjID '_ATLLoc_raw.fif'];
%eog_eventFileName = [inpath '/data/' subjID '/ssp/' subjID '_' exp,runnum,'_eog-eve.fif'];
eog_eventFileName = [inpath '/data/' subjID '/ssp/' subjID '_ATLLoc_eog-eve.fif'];
%eog_eventFileName='/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc4/ssp/sc4_BaleenHPRun1_eog-eve.fif';
%eog_figfile='/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc1/ssp/sc1_MaskedMMRun22BaleenLP_m2sd_eog.png';

%reading eog channels from data files
[fiffsetup] = fiff_setup_read_raw(in_fif_File);
channelNames = fiffsetup.info.ch_names;
ch_EOG = strmatch('EOG',channelNames);
sampRate = fiffsetup.info.sfreq;
start_samp = fiffsetup.first_samp;
end_samp = fiffsetup.last_samp;
[eog] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp, ch_EOG(2));

% Detecting Blinks
filteog = ssp_eegfilt(eog, sampRate,0,20);
EOG_type = 998;
firstSamp = fiffsetup.first_samp;
temp = filteog-mean(filteog);
 
eog_std_dev_value=1; %Change according to the subject(Default 1) (Higher number- detect only distict narrow peaks) 

if sum(temp>(mean(temp)+1*std(temp))) > sum(temp<(mean(temp)+1*std(temp)))
    
    eog_events = ssp_peakfinder((filteog),eog_std_dev_value*std(filteog),-1);

else
    eog_events = ssp_peakfinder((filteog),eog_std_dev_value*std(filteog),1);

end

%  t=1:length(filteog);
%  plot(t,filteog);
%  hold on
%  grid on
%  axis tight
%  plot(t(eog_events),filteog(eog_events),'r+')
%  print( gcf, '-dpng', eog_figfile )

ssp_writeEventFile(eog_eventFileName, firstSamp, eog_events, EOG_type);

end
