function fif2set

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;


exp = 'ATLLoc'
dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';
%subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, exp, '.txt')))';
subj = 12
subjDataPath = strcat(dataPath,'ya',int2str(subj),'/')
%run = 2

inFile = strcat(subjDataPath,'ya',int2str(subj),'_',exp,'_raw.fif')
%inFile = strcat(subjDataPath,'ya',int2str(subj),'_',exp,'Run',int2str(run),'_raw.fif')
EEG = pop_fileio(inFile);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','test','gui','off'); 

EEG = pop_select( EEG,'channel',{'FP1' 'FPZ' 'FP2' 'AF7' 'AF3' 'AFZ' 'AF4' 'AF8' 'F7' 'F5' 'F3' 'F1' 'FZ' 'F2' 'F4' 'F6' 'F8' 'FT9' 'FT7' 'FC5' 'FC3' 'FC1' 'FCZ' 'FC2' 'FC4' 'FC6' 'FT8' 'FT10' 'T9' 'T7' 'C5' 'C3' 'C1' 'CZ' 'C2' 'C4' 'C6' 'T8' 'T10' 'TP9' 'TP7' 'CP5' 'CP3' 'CP1' 'CPZ' 'CP2' 'CP4' 'CP6' 'TP8' 'TP10' 'P9' 'P7' 'P5' 'P3' 'P1' 'PZ' 'P2' 'P4' 'P6' 'P8' 'EOG 061' 'EOG 062' 'ECG 063' 'P10' 'PO7' 'PO3' 'POZ' 'PO4' 'PO8' 'O1' 'OZ' 'O2' 'IZ' 'RMAST'});


outFile = strcat('ya',int2str(subj),'_',exp,'.set')
EEG = pop_saveset( EEG, 'filename',outFile,'filepath',subjDataPath);
