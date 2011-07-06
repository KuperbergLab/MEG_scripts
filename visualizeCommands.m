%%%BaleenHP%%

avgAcrossSubjs('BaleenHP_All')
saveSubjAve('BaleenHP_All')
diffAcrossSubjs('ga_ave_BaleenHP_All_eeg-n20-goodC-ave.fif',1,2);
diffAcrossSubjs('ga_ave_BaleenHP_All_eeg-n20-goodC-ave.fif',3,4);
diffAcrossSubjs('ga_ave_BaleenHP_All_meg-n21-goodC-ave.fif',1,2);
diffAcrossSubjs('ga_ave_BaleenHP_All_meg-n21-goodC-ave.fif',3,4);
visualizeT('BaleenHP_All', 'projoff', 1,2,300,500,.05)
visualizeT('BaleenHP_All', 'projoff', 3,4,300,500,.05)
visualizeT('BaleenHP_All', 'projon', 1,2,300,500,.05)
visualizeT('BaleenHP_All', 'projon', 3,4,300,500,.05)


avgSTCDiffAcrossSubjs('BaleenHP_All',[1 2],'mne',0);
avgSTCDiffAcrossSubjs('BaleenHP_All',[1 2],'mne',1);
avgSTCDiffAcrossSubjs('BaleenHP_All',[1 2],'spm',0);
avgSTCDiffAcrossSubjs('BaleenHP_All',[1 2],'spm',1);
avgSTCDiffAcrossSubjs('BaleenHP_All',[3 4],'mne',0);
avgSTCDiffAcrossSubjs('BaleenHP_All',[3 4],'mne',1);
avgSTCDiffAcrossSubjs('BaleenHP_All',[3 4],'spm',0);
avgSTCDiffAcrossSubjs('BaleenHP_All',[3 4],'spm',1);

statSTC('BaleenHP_All',[1 2],'spm',0)
statSTC('BaleenHP_All',[1 2],'mne',0);
statSTC('BaleenHP_All',[1 2],'spm',1)
statSTC('BaleenHP_All',[1 2],'mne',1);
statSTC('BaleenHP_All',[3 4],'spm',0)
statSTC('BaleenHP_All',[3 4],'mne',0);
statSTC('BaleenHP_All',[3 4],'spm',1)
statSTC('BaleenHP_All',[3 4],'mne',1);

avgSTCinTime(filePrefix, type,300,500);


%%%BaleenLP%%%

avgAcrossSubjs('BaleenLP_All')
saveSubjAve('BaleenLP_All')

avgAcrossSubjs('MaskedMM_All')
saveSubjAve('MaskedMM_All')

visualizeT('MaskedMM_All', 'projoff', 1,3,300,500,.05)
visualizeT('BaleenLP_All', 'projoff', 1,2,300,500,.05)
visualizeT('MaskedMM_All', 'projon', 1,3,300,500,.05)
visualizeT('BaleenLP_All', 'projon', 1,2,300,500,.05)

avgSTCAcrossSubjs('BaleenLP_All',3);