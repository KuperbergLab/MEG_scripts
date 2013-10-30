function sensor_allfif2mat_both(exp,listPrefix)

%%This saves a mat file holding all the average data for all subjects in
%%list. Actually it saves two mat files, one with projections on and one
%%with them off.

%%It also fixes one bug. The first four subjects had two junk channels
%%acquired, so the evoked structure is a different size and breaks in
%%grand-averaging. Here we delete those channels from the evoked.epochs
%%structure. It is important to note they are still present in other parts
%%of the data file, for example, the channel_name structure. 

%%EX: sensor_allfif2mat('MaskedMM_All','ac', 'sc','ya.n22.meeg')

dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/';
fileID = fopen(strcat(dataPath,'scripts/function_inputs/',listPrefix, '.txt'));
subjList = textscan(fileID, '%s', 'Delimiter', '\n');
newsubjList = {'ac31', 'sc19','sc20', 'sc21', 'sc22', 'ac33'}; 

%%run twice, for each projection setting
for x = 2:2
    if x == 1
        projType = 'projoff';
    elseif x == 2
        projType = 'projon';
    end
  
    count = 0;
     
    for n=1:36
        count = count + 1;
        %subjGroup = subj(1:2);
        %disp(n)
        subj=subjList{1}{n}
        if x == 1
            inFile = strcat(dataPath,'data/',subjGroup,int2str(subj),'/ave_projoff/',subjGroup,int2str(subj),'_',exp,'-I-ave.fif');
        elseif x == 2
            inFile = strcat(dataPath,'data/',subj,'/ave_projon/',subj, '_',exp,'-I-ave.fif');

        end
        disp(inFile)
        tempSubjData = fiff_read_evoked_all(inFile);
        
        
        %%Get rid of STI channels in between MEG and EEG channels in subjects 
        %%aquired before the MEG acquisition system change 

        
        if ~ismember(subj, newsubjList) 
            disp(subj)
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
            end
        end
        
        if ismember(subj, newsubjList)
            disp(subj)
            condNum = size(tempSubjData.evoked,2);
            for c = 1:condNum
                tempSubjData.evoked(c).epochs(383,:) = []; %deleting STI
                tempSubjData.evoked(c).epochs(382,:) = []; %deleting STI
                tempSubjData.evoked(c).epochs(381,:) = []; %deleting STI 
            end
        end
        
        allSubjData{count} = tempSubjData; 
     end
 
    outFile = strcat(dataPath, 'results/sensor_level/ave_mat/', listPrefix,'_', exp, '_projon.mat');
    save(outFile,'allSubjData')
end
