function visualizeT(exp, dataType, subjList, cond1, cond2, t1, t2, pVal)

load('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/ch_names.mat')

[m,nSubj] = size(subjList);
[m,nchan] = size(ch_names);
nonSigChan = {};
sigChan = {};
nonSigCount = 0;
sigCount = 0;

if strcmp(dataType,'projon') 
    firstChan = 1;
    lastChan = 306;
elseif strcmp(dataType,'projoff')
    firstChan = 307;
    lastChan = 376;
end
    
%nchan = 1
for ichan = firstChan:lastChan
    ichan
    [p,contrast] = quickT(exp, dataType, subjList, cond1, cond2, t1, t2, ch_names{ichan},'mat');
    if p > pVal
        nonSigCount = nonSigCount+1;
        nonSigChan{nonSigCount} = ch_names{ichan};
    else 
        sigCount = sigCount + 1;
        sigChan{sigCount} = ch_names{ichan};
    end
end

nonSigChan
sigChan

%%Read in the grand-average data for visualization
gaStr = fiff_read_evoked_all(strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/data/ga/ave_',dataType,'ga_',exp,'-n',int2str(nSubj),'-ave.fif'));
gaStr.info.bads = nonSigChan;
gaStr.info

outFile = strcat('/autofs/cluster/kuperberg/SemPrMM/MEG/data/ga/ave_',dataType,'ga_',exp,contrast,'-',int2str(t1),'-',int2str(t2),'-p-',num2str(pVal),'n',int2str(nSubj),'-ave.fif');
fiff_write_evoked(outFile,gaStr);