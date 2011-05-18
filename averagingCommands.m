baleenSubj = [1 3 4 6 9 12 13 15:21 23:25];
maskedSubjAll = [2 6:9 12:13 15:21 23:25];


saveSubjAve('BaleenLP_All','projoff',baleenSubj);
saveSubjAve('BaleenLP_All','projon',baleenSubj);
saveSubjAve('BaleenHP_All','projoff',baleenSubj);
saveSubjAve('BaleenHP_All','projon',baleenSubj);

avgAcrossSubjs('BaleenLP_All','projoff',baleenSubj);
avgAcrossSubjs('BaleenLP_All','projon',baleenSubj);
avgAcrossSubjs('BaleenHP_All','projoff',baleenSubj);
avgAcrossSubjs('BaleenHP_All','projon',baleenSubj);

saveSubjAve('MaskedMM_All','projoff',maskedSubjAll);
saveSubjAve('MaskedMM_All','projon',maskedSubjAll);

avgAcrossSubjs('MaskedMM_All','projoff',maskedSubjAll);
avgAcrossSubjs('MaskedMM_All','projon',maskedSubjAll);
