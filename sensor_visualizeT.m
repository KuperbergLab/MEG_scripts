function sensor_visualizeT(exp, listPrefix,cond1, cond2, t1, t2, pVal)

load('/autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/ch_names.mat')

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, exp, '.txt')))';
numSubj = size(subjList,2);

%%%%Getting the data out, loop once each for projon and projoff

for x = 1:2
    
    if x == 1
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', exp, '_projoff_n',int2str(numSubj)));
        dataType = 'eeg';
        projType = 'projoff';
        numChan = 74;
        chanV = 316:389;
    else
        load(strcat(dataPath, 'results/sensor_level/ave_mat/', exp, '_projon_n',int2str(numSubj)));
        dataType = 'meg';
        projType = 'projon';
        numChan = 306;
        chanV = 1:306;
    end
    
    nonSigChan = {};
    sigChan = {};
    nonSigCount = 0;
    sigCount = 0;


    %nchan = 1
    for ichan = chanV
        ch_names{ichan}
        [p,contrast] = sensor_quickT(exp, listPrefix,projType, cond1, cond2, t1, t2, ichan);
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
    gaStr = fiff_read_evoked_all(strcat(dataPath,'results/sensor_level/ga_fif/ga_',exp,'_',dataType,'-n',int2str(numSubj),'-goodC-ave.fif'));
    gaStr.info.bads = nonSigChan;
    gaStr.info

    outFile = strcat(dataPath,'results/sensor_level/ga_fif_tmap/','ga_',exp,'_',dataType,'_',contrast,'_',int2str(t1),'-',int2str(t2),'_p',num2str(pVal),'_n',int2str(numSubj),'-ave.fif');
    fiff_write_evoked(outFile,gaStr);

end