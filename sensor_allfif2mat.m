function sensor_allfif2mat(exp,listPrefix)

%%This saves a mat file holding all the average data for all subjects in
%%list. Actually it saves two mat files, one with projections on and one
%%with them off.

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, exp, '.txt')))';


%%run twice, for each projection setting
for x = 1:2
    if x == 1
        projType = 'projoff';
    else
        projType = 'projon';
    end
 
    count = 0;
    allSubjData={};

    for subj=subjList
        count = count + 1;
        inFile = strcat(dataPath,'data/ya',int2str(subj),'/ave_',projType,'/','ya',int2str(subj),'_',exp,'_All-ave.fif');
        tempSubjData = fiff_read_evoked_all(inFile);
            
        allSubjData{count} = tempSubjData;

    end

    outFile = strcat(dataPath, 'results/sensor_level/ave_mat/', exp, '_',projType,'_n',int2str(count));

    save(outFile,'allSubjData')
end