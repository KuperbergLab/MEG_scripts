function fifwts2blinks(subject, priorwd)
%%
newwd = fullfile('/cluster/kuperberg/SemPrMM/MEG/data',subject)
cd(newwd)

fiffs = {};
mats = {};
%attloc
files = dir('ya*_ATLLoc_raw.fif');
mat = dir('ya*_ATLLoc_raw*.mat');
fiffs{end+1} = files(1).name;
mats{end+1} = mat(1).name;
%baleen
files = dir('ya*_Baleen*_raw.fif');
mat = dir('ya*_Baleen*_raw*.mat');
for ii = 1:length(files)
    fiffs{end+1} = files(ii).name;
    mats{end+1} = mat(ii).name;
end
%maskedmm
files = dir('ya*_MaskedMM*_raw.fif');
mat = dir('ya*_MaskedMM*_raw*.mat');
for ii = 1:length(files)
    fiffs{end+1} = files(ii).name;
    mats{end+1} = mat(ii).name;
end
%axcpt
files = dir('ya*_AXCPT*_raw.fif');
mat = dir('ya*_AXCPT*_raw*.mat');
for ii = 1:length(files)
    fiffs{end+1} = files(ii).name;
    mats{end+1} = mat(ii).name;
end
clear files ii mat
chans = 316:389;
Fs = 600;

%%
for ii = 1:length(fiffs)
    fiff = fiffs{ii};
    ICA = mats{ii};
    
    dataStruct = fiff_setup_read_raw(fiff);
    X = fiff_read_raw_segment(dataStruct,dataStruct.first_samp,dataStruct.last_samp,chans);
    % loads spheres and wts
    load(ICA)
    
    t = linspace(0,length(X)/Fs,length(X));
    
    U = wts * X;
    
    Winv = inv(wts);
    badComp = [1];
    Winv(:,badComp) = 0;
    Xclean = Winv * U;
   
    
    [pk loc] = findpeaks(U(1,:),'MINPEAKDISTANCE',150,'MINPEAKHEIGHT',mean(U(1,:))+3*std(U(1,:)));
    samp = dataStruct.first_samp;
    loc = loc + double(dataStruct.first_samp);
    
    dot = strfind(fiff,'.');
    file_to_write = [fiff(1:dot-1) '.blinks'];
    fid = fopen(file_to_write,'w');
    for jj = 1:length(loc)
        fprintf(fid,'%d\n',loc(jj));
    end
    fclose(fid);
    fprintf(['Wrote ' file_to_write '\n']);
end

cd(priorwd)