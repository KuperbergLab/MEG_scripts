function sensor_allfif2mat(exp,listPrefix)

%%This saves a mat file holding all the average data for all subjects in
%%list. Actually it saves two mat files, one with projections on and one
%%with them off.

%%It also fixes one bug. The first four subjects had two junk channels
%%acquired, so the evoked structure is a different size and breaks in
%%grand-averaging. Here we delete those channels from the evoked.epochs
%%structure. It is important to note they are still present in other parts
%%of the data file, for example, the channel_name structure. 

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
        if strcmp(exp,'ATLLoc') == 1
            inFile = strcat(dataPath,'data/ya',int2str(subj),'/ave_',projType,'/','ya',int2str(subj),'_',exp,'-ave.fif');
        else
            inFile = strcat(dataPath,'data/ya',int2str(subj),'/ave_',projType,'/','ya',int2str(subj),'_',exp,'_All-ave.fif');
        end
        tempSubjData = fiff_read_evoked_all(inFile);
        
        %%Get rid of junk channels accidentally acquired in first subjects
        %%so matrices match up
        if (subj == 1 || subj == 2 || subj == 3 || subj == 4)
            condNum = size(tempSubjData.evoked,2);
            for c = 1:condNum
                tempSubjData.evoked(c).epochs(390,:) = [];
                tempSubjData.evoked(c).epochs(379,:) = [];
            end
        end
        
        allSubjData{count} = tempSubjData;

    end

    outFile = strcat(dataPath, 'results/sensor_level/ave_mat/', exp, '_',projType,'_n',int2str(count));

    save(outFile,'allSubjData')
end