#!/bin/csh

#usage preProc_avg [subject]

echo
echo "Making Ave Parameter Files"
python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py $1


echo
echo "Making Cov Parameter Files"
python /cluster/kuperberg/SemPrMM/MEG/scripts/makeCovFiles.py $1


foreach proj ( 'projoff' 'projon')

	cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_$proj

	mne_process_raw \
	--raw ../$1_ATLLoc_raw.fif \
	--ave ../ave/$1_ATLLoc.ave \
	--$proj --lowpass 20 --highpass .5

	mne_process_raw \
	--raw ../$1_MaskedMMRun1_raw.fif \
	--raw ../$1_MaskedMMRun2_raw.fif \
	--ave ../ave/$1_MaskedMMRun1.ave \
	--ave ../ave/$1_MaskedMMRun2.ave \
	--gave $1_MaskedMM_All-ave.fif \
	--$proj --lowpass 20

	mne_process_raw \
	--raw ../$1_BaleenLPRun1_raw.fif \
	--raw ../$1_BaleenLPRun2_raw.fif \
	--raw ../$1_BaleenLPRun3_raw.fif \
	--raw ../$1_BaleenLPRun4_raw.fif \
	--ave ../ave/$1_BaleenLPRun1.ave \
	--ave ../ave/$1_BaleenLPRun2.ave \
	--ave ../ave/$1_BaleenLPRun3.ave \
	--ave ../ave/$1_BaleenLPRun4.ave \
	--gave $1_BaleenLP_All-ave.fif \
	--$proj --lowpass 20

	mne_process_raw \
	--raw ../$1_BaleenHPRun1_raw.fif \
	--raw ../$1_BaleenHPRun2_raw.fif \
	--raw ../$1_BaleenHPRun3_raw.fif \
	--raw ../$1_BaleenHPRun4_raw.fif \
	--ave ../ave/$1_BaleenHPRun1.ave \
	--ave ../ave/$1_BaleenHPRun2.ave \
	--ave ../ave/$1_BaleenHPRun3.ave \
	--ave ../ave/$1_BaleenHPRun4.ave \
	--gave $1_BaleenHP_All-ave.fif \
	--$proj --lowpass 20


	if ( -e ../$1_AXCPTRun1_raw.fif ) then
		if ( -e ../$1_AXCPTRun2_raw.fif ) then
			mne_process_raw \
			--raw ../$1_AXCPTRun1_raw.fif \
			--raw ../$1_AXCPTRun2_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--ave ../ave/$1_AXCPTRun2.ave \
			--gave $1_AXCPT_All-ave.fif \
			--$proj --lowpass 20
		else
			mne_process_raw \
			--raw ../$1_AXCPTRun1_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--$proj --lowpass 20
			cp $1_AXCPTRun1-ave.fif $1_AXCPT_All-ave.fif
		endif
	endif

	####################################

	echo "Counting events"
	
	python /cluster/kuperberg/SemPrMM/MEG/scripts/countEvents.py $1 0 ATLLoc 1 $proj
	python /cluster/kuperberg/SemPrMM/MEG/scripts/countEvents.py $1 0 MaskedMM 2 $proj
	python /cluster/kuperberg/SemPrMM/MEG/scripts/countEvents.py $1 0 Baleen 8 $proj
	

end