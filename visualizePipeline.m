%%%BALEENHP%%%

baleensubj = [1 3 4 5 6 9 12 13 15 16 17 19];

avgAcrossSubjs('BaleenHP_All','projoff',baleensubj)
avgAcrossSubjs('BaleenHP_All','projon',baleensubj)

saveSubjAve('BaleenHP_All', 'projoff',baleensubj)
saveSubjAve('BaleenHP_All', 'projon',baleensubj)

visualizeT('BaleenHP_All', 'projoff', baleensubj,3,4,300,500,.05)
visualizeT('BaleenHP_All', 'projon', baleensubj,3,4,300,500,.05)

visualizeT('BaleenHP_All', 'projoff', baleensubj,1,2,300,500,.05)
visualizeT('BaleenHP_All', 'projon', baleensubj,1,2,300,500,.05)


%%%BALEENLP%%%

avgAcrossSubjs('BaleenLP_All','projoff',baleensubj)
avgAcrossSubjs('BaleenLP_All','projon',baleensubj)

saveSubjAve('BaleenLP_All', 'projoff',baleensubj)
saveSubjAve('BaleenLP_All', 'projon',baleensubj)

visualizeT('BaleenLP_All', 'projoff', baleensubj,1,2,300,500,.05)
visualizeT('BaleenLP_All', 'projon', baleensubj,1,2,300,500,.05)


%%%MASKEDMM%%%

maskedSubj = [2 5 6 7 8 9 12 13 15 16 17 19]

avgAcrossSubjs('MaskedMM_All','projoff',maskedSubj)
avgAcrossSubjs('MaskedMM_All','projon',maskedSubj)

saveSubjAve('MaskedMM_All', 'projoff',maskedSubj)
saveSubjAve('MaskedMM_All', 'projon',maskedSubj)

visualizeT('MaskedMM_All', 'projoff', maskedSubj,1,3,300,500,.05)
visualizeT('MaskedMM_All', 'projon', maskedSubj,1,3,300,500,.05)


