% function ssp_find_ecg_event_cu(infif, inpath)
%Run this script for subjects that have a flat signal in their runs, as the python ecg event detector does not skip through this section in teh ssp script. 
%sc4 LP2, sc3 LP4, ya30 MM1 

%input file
%in_fif_File = infif;
%EOG Event file
%[~, name, ~] = fileparts(infif);
% [name1, remain]= strtok(name, '_');
% [name2, ~]=strtok(remain, '_');
% eog_eventFileName = [inpath, name1,'_', name2, '_eog-eve.fif'];

in_fif_File='/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc4/sc4_BaleenLPRun2_raw.fif';
ecg_eventFileName='/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc4/ssp/sc4_BaleenLPRun2_ecg-eve.fif';
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

ecg_std_dev_value=2; %tried 1.75, 1.5, 2 and higher - 2 works best for sc4LP2-flat channels, and 1 works best for s3LP4. 

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

ssp_writeEventFile(ecg_eventFileName, firstSamp, ecg_events, ECG_type);

%end
