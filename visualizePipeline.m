avgAcrossSubjs('BaleenHP_All')
saveSubjAve('BaleenHP_All')

avgAcrossSubjs('BaleenLP_All')
saveSubjAve('BaleenLP_All')

avgAcrossSubjs('MaskedMM_All')
saveSubjAve('MaskedMM_All')

visualizeT('MaskedMM_All', 'projoff', 1,3,300,500,.05)
visualizeT('BaleenLP_All', 'projoff', 1,2,300,500,.05)
visualizeT('BaleenHP_All', 'projoff', 1,2,300,500,.05)

visualizeT('BaleenHP_All', 'projoff', 3,4,300,500,.05)
visualizeT('BaleenHP_All', 'projoff', 1,2,200,250,.05)

visualizeT('BaleenHP_All', 'projon', 3,4,300,500,.05)
visualizeT('MaskedMM_All', 'projon', 1,3,300,500,.05)
visualizeT('BaleenHP_All', 'projon', 1,2,300,500,.05)
visualizeT('BaleenLP_All', 'projon', 1,2,300,500,.05)


avgSTCDiffAcrossSubjs('BaleenHP_All',2,1);
avgSTCAcrossSubjs('BaleenLP_All',3);