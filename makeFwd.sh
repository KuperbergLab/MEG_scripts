#!/bin/csh -f

#usage makeFwd subjID logfile
setenv USE_STABLE_5_0_0
source /usr/local/freesurfer/nmr-stable50-env
source /usr/pubsw/packages/mne/nightly/bin/mne_setup

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 1 ) then
    set log='./makeFwd.log'
    echo "Logging to default log..." >>& $log
endif

if ( $#argv == 2) then
    set log=$2
endif

# if log exists, delete
if ( -e $log ) then
    rm $log
endif

setenv SUBJECT $1

cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_projon

date

####FORWARD SOLUTIONS#####
####note these don't depend on brain data so don't need to change if avg changes
####EEG cap stays in place, so only one for whole experiment

#foreach t ('meg-eeg')
foreach t ('meg' 'eeg' 'meg-eeg')
#    echo "Jane here"
	if ( $t == 'eeg' ) then
		mne_do_forward_solution --bem $1-5120-5120-5120-bem-sol.fif --meas $1_ATLLoc-ave.fif --eegonly --fwd $1_All-ave-7-$t-fwd.fif --overwrite >>& $log
	endif
 	foreach exp ('ATLLoc' 'MaskedMMRun1' 'MaskedMMRun2' 'BaleenLPRun1' 'BaleenLPRun2' 'BaleenLPRun3' 'BaleenLPRun4' 'BaleenHPRun1' 'BaleenHPRun2' 'BaleenHPRun3' 'BaleenHPRun4' 'AXCPTRun1' 'AXCPTRun2')	
 	#foreach exp ('ATLLoc')
 		if ( -e $1_$exp-ave.fif ) then
 			if ( $t == 'meg' ) then
 				 mne_do_forward_solution --bem $1-5120-5120-5120-bem-sol.fif --meas $1_$exp-ave.fif --megonly --fwd $1_$exp-ave-7-$t-fwd.fif --overwrite >>& $log
 			endif
 			if ( $t == 'meg-eeg' ) then
 				mne_do_forward_solution --bem $1-5120-5120-5120-bem-sol.fif --meas $1_$exp-ave.fif --fwd $1_$exp-ave-7-$t-fwd.fif --overwrite >>& $log
 			endif
 			if ( $t == 'eeg' ) then
 				 mne_do_forward_solution --bem $1-5120-5120-5120-bem-sol.fif --meas $1_$exp-ave.fif --eegonly --fwd $1_$exp-ave-7-$t-fwd.fif --overwrite >>& $log
 			endif
 		endif
 	end	
########################AVERAGE FORWARD SOLUTIONS#######################	
    if ($t == 'meg' || $t == 'meg-eeg' ) then
#  #  if ($t == 'meg-eeg' ) then
        mne_average_forward_solutions --fwd $1_MaskedMMRun1-ave-7-$t-fwd.fif --fwd $1_MaskedMMRun2-ave-7-$t-fwd.fif --out $1_MaskedMM_All-ave-7-$t-fwd.fif >>& $log
        mne_average_forward_solutions --fwd $1_BaleenLPRun1-ave-7-$t-fwd.fif --fwd $1_BaleenLPRun2-ave-7-$t-fwd.fif --fwd $1_BaleenLPRun3-ave-7-$t-fwd.fif --fwd $1_BaleenLPRun4-ave-7-$t-fwd.fif --out $1_BaleenLP_All-ave-7-$t-fwd.fif >>& $log
        mne_average_forward_solutions --fwd $1_BaleenHPRun1-ave-7-$t-fwd.fif --fwd $1_BaleenHPRun2-ave-7-$t-fwd.fif --fwd $1_BaleenHPRun3-ave-7-$t-fwd.fif --fwd $1_BaleenHPRun4-ave-7-$t-fwd.fif --out $1_BaleenHP_All-ave-7-$t-fwd.fif >>& $log		
        if ($1 == 'ac8') then
 	   mne_average_forward_solutions --fwd $1_BaleenLPRun1-ave-7-$t-fwd.fif --fwd $1_BaleenLPRun3-ave-7-$t-fwd.fif --fwd $1_BaleenLPRun4-ave-7-$t-fwd.fif --out $1_BaleenLP_All-ave-7-$t-fwd.fif >>& $log
        endif
        if ($1 == 'ac19') then
 	   mne_average_forward_solutions --fwd $1_BaleenLPRun1-ave-7-$t-fwd.fif --fwd $1_BaleenLPRun2-ave-7-$t-fwd.fif --fwd $1_BaleenLPRun4-ave-7-$t-fwd.fif --out $1_BaleenLP_All-ave-7-$t-fwd.fif >>& $log
        endif
        if ($1 == 'sc19') then
 	   mne_average_forward_solutions --fwd $1_MaskedMMRun2-ave-7-$t-fwd.fif --out $1_MaskedMM_All-ave-7-$t-fwd.fif >>& $log
        endif
        if ( -e $1_AXCPTRun2-ave.fif ) then
 	   mne_average_forward_solutions --fwd $1_AXCPTRun1-ave-7-$t-fwd.fif --fwd $1_AXCPTRun2-ave-7-$t-fwd.fif --out $1_AXCPT_All-ave-7-$t-fwd.fif >>& $log		
        else if ( -e $1_AXCPTRun1-ave.fif ) then
 	   mne_average_forward_solutions --fwd $1_AXCPTRun1-ave-7-$t-fwd.fif  --out $1_AXCPT_All-ave-7-$t-fwd.fif >>& $log
        endif
    endif
end

########FIX GROUP ON ALL FILES########
chgrp -R lingua .
