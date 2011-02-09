function avg_across_subjs(subjList)

%%%Currently does not remove bad channels from image


dataType = 'ave_projon';
dataPath = '/autofs/cluster/kuperberg/SemPrMM/MEG/data/';

%%%ATLLoc runs%%%%
blankStr = fiff_read_evoked_all(strcat(dataPath,'ya2/',dataType,'/ya2_ATLLoc-ave.fif'));

count = 0;
allData=[];
for subj=subjList
    count=count+1
    subj
    filename = strcat(dataPath,'ya',int2str(subj),'/',dataType,'/','ya',int2str(subj),'_ATLLoc-ave.fif')
    tempRunStr = fiff_read_evoked_all(filename);

    for x = 1:3
        temp = tempRunStr.evoked(x).epochs(:,:);
        if (subj == 1 || subj == 3 || subj == 4 || subj == 7)
            temp(390,:) = [];
            temp(379,:) = [];
        end
        
       size(temp)
       tempEv(:,:,x) = temp;
    end

    size(tempEv)
    size(allData)
    allData(:,:,:,count) = tempEv;
    size(allData)
    clear('tempEv');
    clear('tempRunStr');
    
end

gaData = mean(allData,4);

for y = 1:3
    blankStr.evoked(y).epochs(:,:) = gaData(:,:,y);
end


outFile = strcat(dataPath,'ga/',dataType,'ga_ATLLoc-ave.fif')
fiff_write_evoked(outFile,blankStr);


%%%%MaskedMM runs%%%%%

blankStr = fiff_read_evoked_all(strcat(dataPath,'ya2/',dataType,'/ya2_MaskedMM_All-ave.fif'));
strSize = size(blankStr.evoked);
cond = strSize(2);

count = 0
allData=[];
for subj=subjList
    
    if (subj ~= 1 && subj ~= 3 && subj ~= 4)
        count=count+1;
        subj
        filename = strcat(dataPath,'ya',int2str(subj),'/',dataType,'/','ya',int2str(subj),'_MaskedMM_All-ave.fif')
        tempRunStr = fiff_read_evoked_all(filename);

        for x = 1:cond
            temp = tempRunStr.evoked(x).epochs(:,:);
            if (subj == 7)
                temp(390,:) = [];
                temp(379,:) = [];
            end
            tempEv(:,:,x) = temp;
        end

        size(tempEv)
        size(allData)
        allData(:,:,:,count) = tempEv;
        size(allData)
        clear('tempEv');
        clear('tempRunStr');
    end
end

gaData = mean(allData,4);

for y = 1:cond
    blankStr.evoked(y).epochs(:,:) = gaData(:,:,y);
end


outFile = strcat(dataPath,'ga/',dataType,'ga_MaskedMM_All-ave.fif')
fiff_write_evoked(outFile,blankStr);
allData=[]

%%%%%Low-Prop runs%%%%
blankStr = fiff_read_evoked_all(strcat(dataPath,'ya2/',dataType,'/','ya2_BaleenLP_All-ave.fif'));
strSize = size(blankStr.evoked);
cond = strSize(2);

count=0
for subj=subjList
    count=count+1;
    tempRunStr = fiff_read_evoked_all(strcat(dataPath,'ya',int2str(subj),'/',dataType,'/','ya',int2str(subj),'_BaleenLP_All-ave.fif'));
    
    for x = 1:cond
        subj
        temp = tempRunStr.evoked(x).epochs(:,:);
        if (subj == 1 || subj == 3 || subj == 4 || subj == 7)
            temp(390,:) = [];
            temp(379,:) = [];
        end
        tempEv(:,:,x) = temp;
    end

    size(tempEv)
    size(allData)
    allData(:,:,:,count) = tempEv;
    size(allData)
    clear('tempEv');
    clear('tempRunStr');


end

gaData = mean(allData,4);

for y = 1:cond
    blankStr.evoked(y).epochs(:,:) = gaData(:,:,y);
end

outFile = strcat(dataPath,'ga/',dataType,'ga_BaleenLP_All-ave.fif')
fiff_write_evoked(outFile,blankStr);

allData = [];
%%%%High-Prop runs%%%%
blankStr = fiff_read_evoked_all(strcat(dataPath,'ya2/',dataType,'/','ya2_BaleenHP_All-ave.fif'));
strSize = size(blankStr.evoked);
cond = strSize(2);

count=0
for subj=subjList
    count=count+1;
    tempRunStr = fiff_read_evoked_all(strcat(dataPath,'ya',int2str(subj),'/',dataType,'/','ya',int2str(subj),'_BaleenHP_All-ave.fif'));
    
    for x = 1:cond
        temp = tempRunStr.evoked(x).epochs(:,:);
        if (subj == 1 || subj == 3 || subj == 4 || subj == 7)
            temp(390,:) = [];
            temp(379,:) = [];
        end
        tempEv(:,:,x) = temp;
    end
    
    allData(:,:,:,count) = tempEv;
    clear('tempEv');
    clear('tempRunStr');

end

gaData = mean(allData,4);

for y = 1:cond
    blankStr.evoked(y).epochs(:,:) = gaData(:,:,y);
end

outFile = strcat(dataPath,'ga/',dataType,'ga_BaleenHP_All-ave.fif')
fiff_write_evoked(outFile,blankStr);