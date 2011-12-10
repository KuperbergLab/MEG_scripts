function sensor_mashBaleen_ga(listPrefix,dataType)

%The purpose of this script is to mash together the BaleenLP and BaleenHP
%grand-average fif files so the field patterns and waveforms can be
%directly compared

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/results/sensor_level/ga_fif/';

fileNameLP = strcat(dataPath,'ga_',listPrefix, '_BaleenLP_All_',dataType,'-goodC-ave.fif')
fileNameHP = strcat(dataPath,'ga_',listPrefix, '_BaleenHP_All_',dataType,'-goodC-ave.fif')


dataStructLP = fiff_read_evoked_all(fileNameLP);
dataStructHP = fiff_read_evoked_all(fileNameHP);
[~,nCondLP] = size(dataStructLP.evoked)
[~,nCondHP] = size(dataStructHP.evoked)


dataStructAll = dataStructLP;  %initialize the mash with the LP data

for c = 1:nCondHP %add the HP data
    dataStructAll.evoked(nCondLP+c) = dataStructAll.evoked(1);
    dataStructAll.evoked(nCondLP+c).epochs = dataStructHP.evoked(c).epochs;
    dataStructAll.evoked(nCondLP+c).comment = strcat(dataStructHP.evoked(c).comment,'_HP');
    dataStructAll.evoked(nCondLP+c).nave = dataStructHP.evoked(c).nave;
end

outFile = strcat(dataPath,'ga_',listPrefix, '_BaleenAll_',dataType,'-goodC-ave.fif');
fiff_write_evoked(outFile,dataStructAll);