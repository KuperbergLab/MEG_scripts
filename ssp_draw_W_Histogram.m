%  t=1:length(filteog);
%  plot(t,filteog);
%  hold on
%  grid on
%  axis tight
%  plot(t(eog_events),filteog(eog_events),'r+')
%  print( gcf, '-dpng', eog_figfile )
 
 wdataL = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeogProjeeg-lh.w');
 wdataR = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeogProjeeg-rh.w');
 data = [wdataL.data;wdataR.data];
 hist(data, 100)
 set(gca, 'YLim',[0 500], 'XLim', [0 1]);
 print('-f1', '-dpng', '/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeogProjeeg_wHist')
 
 
 wdataL = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeogProjmag-lh.w');
 wdataR = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeogProjmag-rh.w');
 data = [wdataL.data;wdataR.data];
 hist(data, 100)
 set(gca, 'YLim',[0 500], 'XLim', [0 1]);
 print('-f1', '-dpng', '/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeogProjmag_wHist')
 
 
 wdataL = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeogProjgrad-lh.w');
 wdataR = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeogProjgrad-rh.w');
 data = [wdataL.data;wdataR.data];
 hist(data, 100)
 set(gca, 'YLim',[0 500], 'XLim', [0 1]);
 print('-f1', '-dpng', '/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeogProjgrad_wHist')
 
 
 wdataL = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeog2Projeeg-lh.w');
 wdataR = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeog2Projeeg-rh.w');
 data = [wdataL.data;wdataR.data];
 hist(data, 100)
 set(gca, 'YLim',[0 500], 'XLim', [0 1]);
 print('-f1', '-dpng', '/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeog2Projeeg_wHist')
 
 
 wdataL = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeog2Projmag-lh.w');
 wdataR = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeog2Projmag-rh.w');
 data = [wdataL.data;wdataR.data];
 hist(data, 100)
 set(gca, 'YLim',[0 500], 'XLim', [0 1]);
 print('-f1', '-dpng', '/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeog2Projmag_wHist')
 
 
 wdataL = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeog2Projgrad-lh.w');
 wdataR = mne_read_w_file('/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeog2Projgrad-rh.w');
 data = [wdataL.data;wdataR.data];
 hist(data, 100)
 set(gca, 'YLim',[0 500], 'XLim', [0 1]);
 print('-f1', '-dpng', '/autofs/cluster/kuperberg/SemPrMM/MEG/data/sc14/ssp/sc14_BaleenHPRun1_122612-M7_ecgeog2Projgrad_wHist')
 
 
