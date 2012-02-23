#!/bin/csh -f 

#usage makeInv subjID logfile
setenv USE_STABLE_5_0_0
source /usr/local/freesurfer/nmr-stable50-env
source /usr/pubsw/packages/mne/nightly/bin/mne_setup

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 1 ) then
    set log='./makeInv.log'
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

###################INVERSE SOLUTIONS####################
###note these only change if cov matrix changes###
##Note we're using the covariance from BaleenLP, because we don't have a good baseline period in ATLLoc


foreach t ('meg' 'eeg' 'meg-eeg')
	##This has to be done separately b/c just one fwd solution exists for EEG, and just need one for each covariance matrix
	if ($t == 'eeg' ) then
		 mne_do_inverse_operator --fwd $1_All-ave-7-eeg-fwd.fif --depth --loose .5 --$t --senscov $1_Baleen_All-cov.fif --inv $1_ATLLoc-Baleen-ave-7-eeg-inv.fif >>& $log
		 mne_do_inverse_operator --fwd $1_All-ave-7-eeg-fwd.fif --depth --loose .5 --$t --senscov $1_MaskedMM_All-cov.fif --inv $1_MaskedMM-ave-7-eeg-inv.fif >>& $log
		if ( -e $1_AXCPTRun1-ave.fif ) then
			mne_do_inverse_operator --fwd $1_All-ave-7-eeg-fwd.fif --depth --loose .5 --$t --senscov $1_AXCPT_All-cov.fif --inv $1_AXCPT-ave-7-eeg-inv.fif >>& $log
		endif	
	else if ( $t == 'meg') then
		 mne_do_inverse_operator --fwd $1_ATLLoc-ave-7-$t-fwd.fif --depth --loose .5 --$t --senscov $1_Baleen_All-cov.fif --inv $1_ATLLoc-ave-7-$t-inv.fif >>& $log
		 mne_do_inverse_operator --fwd $1_MaskedMM_All-ave-7-$t-fwd.fif --depth --loose .5 --$t --senscov $1_MaskedMM_All-cov.fif --inv $1_MaskedMM_All-ave-7-$t-inv.fif >>& $log
		 mne_do_inverse_operator --fwd $1_BaleenLP_All-ave-7-$t-fwd.fif --depth --loose .5 --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenLP_All-ave-7-$t-inv.fif >>& $log
		 mne_do_inverse_operator --fwd $1_BaleenHP_All-ave-7-$t-fwd.fif --depth --loose .5 --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenHP_All-ave-7-$t-inv.fif >>& $log
		if ( -e $1_AXCPTRun1-ave.fif ) then
			mne_do_inverse_operator --fwd $1_AXCPT_All-ave-7-$t-fwd.fif --depth --loose .5 --$t --senscov $1_AXCPT_All-cov.fif --inv $1_AXCPT_All-ave-7-$t-inv.fif >>& $log
		endif
		##This has to be done separately b/c I couldn't figure out how to code it with the previous loop given the --meg and --eeg options
	else if ($t == 'meg-eeg') then
		 mne_do_inverse_operator --fwd $1_ATLLoc-ave-7-$t-fwd.fif --depth --loose .5 --meg --eeg --senscov $1_Baleen_All-cov.fif --inv $1_ATLLoc-ave-7-$t-inv.fif >>& $log 
		 mne_do_inverse_operator --fwd $1_MaskedMM_All-ave-7-$t-fwd.fif --depth --loose .5 --meg --eeg --$t --senscov $1_MaskedMM_All-cov.fif --inv $1_MaskedMM_All-ave-7-$t-inv.fif >>& $log
		 mne_do_inverse_operator --fwd $1_BaleenLP_All-ave-7-$t-fwd.fif --depth --loose .5 --meg --eeg --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenLP_All-ave-7-$t-inv.fif >>& $log
		 mne_do_inverse_operator --fwd $1_BaleenHP_All-ave-7-$t-fwd.fif --depth --loose .5 --meg --eeg --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenHP_All-ave-7-$t-inv.fif >>& $log
		if ( -e $1_AXCPTRun1-ave.fif ) then
			mne_do_inverse_operator --fwd $1_AXCPT_All-ave-7-$t-fwd.fif --depth --loose .5 --meg --eeg --$t --senscov $1_AXCPT_All-cov.fif --inv $1_AXCPT_All-ave-7-$t-inv.fif >>& $log
		endif
	endif		
end	


######MAKE MORPHING MAP TO FSAVERAGE######

mne_make_morph_maps --from $1 --to fsaverage >>& $log



########FIX GROUP ON ALL FILES########
chgrp -R lingua .
