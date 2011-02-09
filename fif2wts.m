function fif2wts(subject, priorwd)
%%
newwd = fullfile('/cluster/kuperberg/SemPrMM/MEG/data',subject)
cd(newwd)

fiffs = {};
%attloc
files = dir('ya*_ATLLoc_raw.fif');
fiffs{end+1} = files(1).name;
%baleen
files = dir('ya*_Baleen*_raw.fif');
for ii = 1:length(files)
    fiffs{end+1} = files(ii).name;
end
%maskedmm
files = dir('ya*_MaskedMM*_raw.fif');
for ii = 1:length(files)
    fiffs{end+1} = files(ii).name;
end
%axcpt
files = dir('ya*_AXCPT*_raw.fif');
for ii = 1:length(files)
    fiffs{end+1} = files(ii).name;
end
clear files ii
chans = 316:389;

%%
for ii = 1:length(fiffs)
    fiff = fiffs{ii};
    dataStruct = fiff_setup_read_raw(fiff);
    X = fiff_read_raw_segment(dataStruct,dataStruct.first_samp,dataStruct.last_samp,chans);
    k = strfind(fiff,'.');
    filename = [fiff(1:k-1) '_ica.mat']
    [wts spheres] = runica(X,'extended',1);
    save(filename,'wts','spheres');
end
