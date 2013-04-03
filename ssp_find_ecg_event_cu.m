% function ssp_find_ecg_event_cu(infif, inpath)

%input file
%in_fif_File = infif;
%EOG Event file
%[~, name, ~] = fileparts(infif);
% [name1, remain]= strtok(name, '_');
% [name2, ~]=strtok(remain, '_');
% eog_eventFileName = [inpath, name1,'_', name2, '_eog-eve.fif'];

in_fif_File='/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc3/sc3_BaleenLPRun4_raw.fif';
ecg_eventFileName='/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc3/ssp/sc3_BaleenLPRun4_ecg-eve.fif';
%eog_figfile='/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc1/ssp/sc1_BaleenHPRun2_m2sd_eog.png';

%reading eog channels from data files
[fiffsetup] = fiff_setup_read_raw(in_fif_File);
channelNames = fiffsetup.info.ch_names;
ch_ECG = strmatch('ECG',channelNames);
sampRate = fiffsetup.info.sfreq;
start_samp = fiffsetup.first_samp;
end_samp = fiffsetup.last_samp;
[ecg] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp, ch_ECG(1));



% Detecting Blinks
filtecg = eegfilt(ecg, sampRate,0,100);
ECG_type = 999;
firstSamp = fiffsetup.first_samp;
temp = filtecg-mean(filtecg);

ecg_std_dev_value=1; %tried 1.75, 1.5, 2 and higher - 2 works best for sc4LP2-flat channels, and 1 works best for s3LP4. 

if sum(temp>(mean(temp)+2*std(temp))) > sum(temp<(mean(temp)+2*std(temp)))
    
    ecg_events = peakfinder((filtecg),ecg_std_dev_value*std(filtecg),-1);

else
    ecg_events = peakfinder((filtecg),ecg_std_dev_value*std(filtecg),1);

end

%  t=1:length(filteog);
%  plot(t,filteog);
%  hold on
%  grid on
%  axis tight
%  plot(t(eog_events),filteog(eog_events),'r+')
%  print( gcf, '-dpng', eog_figfile )

writeEventFile(ecg_eventFileName, firstSamp, ecg_events, ECG_type);

%end
