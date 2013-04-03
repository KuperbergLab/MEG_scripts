function sensor_allfif2mat(exp,subjGroup,listPrefix)

%%This saves a mat file holding all the average data for all subjects in
%%list. Actually it saves two mat files, one with projections on and one
%%with them off.

%%It also fixes one bug. The first four subjects had two junk channels
%%acquired, so the evoked structure is a different size and breaks in
%%grand-averaging. Here we delete those channels from the evoked.epochs
%%structure. It is important to note they are still present in other parts
%%of the data file, for example, the channel_name structure. 

%%EX: sensor_allfif2mat('MaskedMM_All','ya','ya.n22.meeg')

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
subjList = (dlmread(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt')))';
newsubjList = {'ac31', 'sc19','sc20', 'sc21', 'sc22'}; 

%%run twice, for each projection setting
for x = 1:1
    if x == 1
        projType = 'projoff';
    elseif x == 2
        projType = 'projon';
    elseif x == 3 
        projType = 'MaxFilter';
    end
 
    count = 0;
    allSubjData={};

    for subj=subjList
        count = count + 1;
        
        if x == 1
            inFile = strcat(dataPath,'data/',subjGroup,int2str(subj),'/ave_projon/',subjGroup,int2str(subj),'_',exp,'_noavgref-I-ave.fif');
        elseif x == 2
            inFile = strcat(dataPath,'data/',subjGroup,int2str(subj),'/ave_projon/',subjGroup,int2str(subj),'_',exp,'_noavgref-I-ave.fif');
        elseif x == 3
            inFile = strcat(dataPath,'data/',subjGroup,int2str(subj),'/ave_MaxFilter/',subjGroup,int2str(subj),'_',exp,'-ave.fif');
        end
        
        tempSubjData = fiff_read_evoked_all(inFile);
        
        %%Get rid of junk channels accidentally acquired in first ya subjects
        %%so matrices match up
        if (subj == 1 || subj == 2 || subj == 3 || subj == 4) && strcmp(subjGroup,'ya')
            condNum = size(tempSubjData.evoked,2);
            for c = 1:condNum
                tempSubjData.evoked(c).epochs(390,:) = [];
                tempSubjData.evoked(c).epochs(379,:) = [];
            end
        end
        
        %%Get rid of STI channels in between MEG and EEG channels in subjects 
        %%aquired before the MEG acquisition system change 
        subjID = strcat(subjGroup, int2str(subj));
        disp(subjID)
        
        if ~ismember(subjID, newsubjList) 
            disp(subjID)
            condNum = size(tempSubjData.evoked,2);
            for c = 1:condNum
                tempSubjData.evoked(c).epochs(390,:) = []; %deleting EEG115 or MISC 115 (as in the case of sc3)
                tempSubjData.evoked(c).epochs(315,:) = []; %deleting STI 
                tempSubjData.evoked(c).epochs(314,:) = []; %deleting STI
                tempSubjData.evoked(c).epochs(313,:) = []; %deleting STI 
                tempSubjData.evoked(c).epochs(312,:) = []; %deleting STI 
                tempSubjData.evoked(c).epochs(311,:) = []; %deleting STI 
                tempSubjData.evoked(c).epochs(310,:) = []; %deleting STI 
                tempSubjData.evoked(c).epochs(309,:) = []; %deleting STI 
                tempSubjData.evoked(c).epochs(308,:) = []; %deleting STI 
                tempSubjData.evoked(c).epochs(307,:) = []; %deleting STI

                %tempSubjData.evoked(c).epochs(307:315,:) = [];
            end
        end
        
        if ismember(subjID, newsubjList)
            disp(subjID)
            condNum = size(tempSubjData.evoked,2);
            for c = 1:condNum
                %tempSubjData.evoked(c).epochs(381:383,:) = [];
                tempSubjData.evoked(c).epochs(383,:) = []; %deleting STI
                tempSubjData.evoked(c).epochs(382,:) = []; %deleting STI
                tempSubjData.evoked(c).epochs(381,:) = []; %deleting STI 
            end
        end
        
        allSubjData{count} = tempSubjData; %%changed allSubjData to TempSubjData to get the ave.mat file for ac.meg.31 to acquire teh template data structure for new MEG EEG channels. 
    end

    outFile = strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix,'_noavgref_',exp, '_projon.mat');

    save(outFile,'allSubjData')
end
