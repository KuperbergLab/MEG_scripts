%  t=1:length(filteog);
%  plot(t,filteog);
%  hold on
%  grid on
%  axis tight
%  plot(t(eog_events),filteog(eog_events),'r+')
%  print( gcf, '-dpng', eog_figfile )
 
 wdata = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc3/ssp/sc3_BaleenHPRun1_ecg10Projmag-lh.w');
 hist(wdata.data, 100);
 print('-f1', '-dpng', '/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc3/ssp/sc3_BaleenHPRun1_ecg10Proj_wHist')