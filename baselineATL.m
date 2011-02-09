function baselineATL(subjList)

dataType = 'ave_projon';
dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

for subj=subjList
    subj
    filename = strcat(dataPath,'ya',int2str(subj),'/',dataType,'/','ya',int2str(subj),'_ATLLoc-ave.fif')
    tempStr = fiff_read_evoked_all(filename);
 
    for cond = 1:3
        tempEv = tempStr.evoked(cond).epochs(:,:);
        condFirst = cond+3;
        blEv = tempStr.evoked(condFirst).epochs(:,1:60); %100 ms pre-stim
        avgBlEv = mean(blEv,2);
        avgBlEvRep = repmat(avgBlEv,1,601);
        blTempEv = tempEv-avgBlEvRep;
        tempStr.evoked(cond).epochs = blTempEv;
    end

    outFile = strcat(dataPath,'ya',int2str(subj),'/',dataType,'/','ya',int2str(subj),'_ATLLocBL-ave.fif')
    fiff_write_evoked(outFile,tempStr);
    
end

end