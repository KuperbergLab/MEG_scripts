#!/bin/csh

setenv SUBJECT $1

cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_projon

date

if ( ! -e /cluster/kuperberg/SemPrMM/MRI/structurals/subjects/$1/mri/T1-neuromag/sets/COR-*.fif) then
	echo 'No coregistration transform created'
endif

foreach t ('meg' 'eeg' 'meg-eeg')

####FORWARD SOLUTIONS#####
####note these don't depend on brain data so don't need to change if avg changes
####EEG cap stays in place, so only one for whole experiment

	if ( $t == 'eeg' ) then
		mne_do_forward_solution --bem $1-5120-5120-5120-bem-sol.fif --meas $1_ATLLoc-ave.fif --eegonly --fwd $1_All-ave-7-$t-fwd.fif
	endif


	foreach e ('ATLLoc' 'MaskedMMRun1' 'MaskedMMRun2' 'BaleenRun1' 'BaleenRun2' 'BaleenRun3' 'BaleenRun4' 'BaleenRun5' 'BaleenRun6' 'BaleenRun7' 'BaleenRun8' 'AXCPTRun1' 'AXCPTRun2')
	
		if ( -e $1_$e-ave.fif ) then

			if ( $t == 'meg' ) then
				 mne_do_forward_solution --bem $1-5120-5120-5120-bem-sol.fif --meas $1_$e-ave.fif --megonly --fwd $1_$e-ave-7-$t-fwd.fif
			endif
			
			if ( $t == 'meg-eeg' ) then
				mne_do_forward_solution --bem $1-5120-5120-5120-bem-sol.fif --meas $1_$e-ave.fif --fwd $1_$e-ave-7-meg-eeg-fwd.fif
			endif
			
		endif

	end

###################INVERSE SOLUTIONS####################
###note these only change if cov matrix changes###
##Note we're using the covariance from BaleenLP, because we don't have a good baseline period in ATLLoc
	
	if ( $t == 'meg' || $t == 'eeg' ) then
		 mne_do_inverse_operator --fwd $1_ATLLoc-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_Baleen_All-cov.fif --inv $1_ATLLoc-ave-7-$t-inv.fif

		 mne_do_inverse_operator --fwd $1_MaskedMMRun1-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_MaskedMM_All-cov.fif --inv $1_MaskedMMRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_MaskedMMRun2-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_MaskedMM_All-cov.fif --inv $1_MaskedMMRun1-ave-7-$t-inv.fif
		 
		 mne_do_inverse_operator --fwd $1_BaleenRun1-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun2-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun3-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun4-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun5-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun6-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun7-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun8-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif

		if ( -e $1_AXCPTRun1-ave.fif ) then
			mne_do_inverse_operator --fwd $1_AXCPTRun1-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_AXCPT_All-cov.fif --inv $1_AXCPTRun1-ave-7-$t-inv.fif
		endif

		if ( -e $1_AXCPTRun2-ave.fif ) then
			mne_do_inverse_operator --fwd $1_AXCPTRun2-ave-7-$t-fwd.fif --depth --loose .2 --$t --senscov $1_AXCPT_All-cov.fif --inv $1_AXCPTRun2-ave-7-$t-inv.fif
		endif		
	endif
	
	
	else if ($t == 'meg-eeg') then
		mne_do_inverse_operator --fwd $1_ATLLoc-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_Baleen_All-cov.fif --inv $1_ATLLoc-ave-7-$t-inv.fif

		 mne_do_inverse_operator --fwd $1_MaskedMMRun1-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_MaskedMM_All-cov.fif --inv $1_MaskedMMRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_MaskedMMRun2-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_MaskedMM_All-cov.fif --inv $1_MaskedMMRun1-ave-7-$t-inv.fif
		 
		 mne_do_inverse_operator --fwd $1_BaleenRun1-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun2-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun3-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun4-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun5-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun6-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun7-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif
		 mne_do_inverse_operator --fwd $1_BaleenRun8-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_Baleen_All-cov.fif --inv $1_BaleenRun1-ave-7-$t-inv.fif

		if ( -e $1_AXCPTRun1-ave.fif ) then
			mne_do_inverse_operator --fwd $1_AXCPTRun1-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_AXCPT_All-cov.fif --inv $1_AXCPTRun1-ave-7-$t-inv.fif
		endif

		if ( -e $1_AXCPTRun2-ave.fif ) then
			mne_do_inverse_operator --fwd $1_AXCPTRun2-ave-7-$t-fwd.fif --depth --loose .2 --meg --eeg --senscov $1_AXCPT_All-cov.fif --inv $1_AXCPTRun2-ave-7-$t-inv.fif
		endif	
	endif		

end	


######MAKE MORPHING MAP TO FSAVERAGE######

mne_make_morph_maps --from $1 --to fsaverage



########FIX GROUP ON ALL FILES########
chgrp -R lingua .