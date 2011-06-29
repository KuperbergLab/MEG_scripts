function fif2blinks(subject, priorwd)

do_plot = 1;
thr = 75e-6;
write = 0;

newwd = fullfile('/cluster/kuperberg/SemPrMM/MEG/data', subject);
cd(newwd)

fiffs = {};
%attloc
files = dir('*_ATLLoc_raw.fif');
fiffs{end+1} = files(1).name;
%baleen
files = dir('*_Baleen*_raw.fif');
for ii = 1:length(files)
    fiffs{end+1} = files(ii).name;
end
%maskedmm
files = dir('*_MaskedMM*_raw.fif');
for ii = 1:length(files)
    fiffs{end+1} = files(ii).name;
end
%axcpt
files = dir('*_AXCPT*_raw.fif');
for ii = 1:length(files)
    fiffs{end+1} = files(ii).name;
end
clear files ii
veog = 377;
Fs = 600;

for ii = 1:length(fiffs)
%for ii = 1
    fiff = fiffs{ii}
    dataStruct = fiff_setup_read_raw(fiff);
    X = fiff_read_raw_segment(dataStruct,dataStruct.first_samp,dataStruct.last_samp,veog);    
    avgX = mean(X);
    X = X - avgX;
    bad = X > thr | X < -thr;
    if do_plot
        b = ones(1,length(X));
        b = bad * thr;
        plot(X(1:10000))
        hold on
        plot(b(1:10000), 'r');plot(-b(1:10000), 'r')
        hold off
        pause(5)
    end
    bad_tp = find(bad);
    if write
        dot = strfind(fiff,'.');
        file_to_write = [fiff(1:dot-1) '.blinks'];
        dlmwrite(file_to_write, bad_tp, '\n')    
    end
end