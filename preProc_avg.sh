#!/bin/csh

#usage preProc_avg [subject] [log file]

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 1 ) then
    set log='./preProc_avg.log'
    echo "Logging to default log..." >>& $log
endif

if ( $#argv == 2) then
    set log=$2
endif

# if log exists, delete
if ( -e $log ) then
    rm $log
endif


echo "Making Ave Parameter Files" >>& $log



python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py $1 >>& $log



foreach proj ( 'projoff' 'projon')
	echo "Making Avg fif Files" >>& $log
	cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_$proj

	mne_process_raw \
	--raw ../$1_ATLLoc_raw.fif \
	--ave ../ave/$1_ATLLoc.ave \
	--$proj --lowpass 20 --highpass .5 >>& $log

	mne_process_raw \
	--raw ../$1_MaskedMMRun1_raw.fif \
	--raw ../$1_MaskedMMRun2_raw.fif \
	--ave ../ave/$1_MaskedMMRun1.ave \
	--ave ../ave/$1_MaskedMMRun2.ave \
	--gave $1_MaskedMM_All-ave.fif \
	--$proj --lowpass 20 >>& $log

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
	--$proj --lowpass 20 >>& $log

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
	--$proj --lowpass 20 >>& $log


	if ( -e ../$1_AXCPTRun1_raw.fif ) then
		if ( -e ../$1_AXCPTRun2_raw.fif ) then
			mne_process_raw \
			--raw ../$1_AXCPTRun1_raw.fif \
			--raw ../$1_AXCPTRun2_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--ave ../ave/$1_AXCPTRun2.ave \
			--gave $1_AXCPT_All-ave.fif \
			--$proj --lowpass 20 >>& $log
		else
			mne_process_raw \
			--raw ../$1_AXCPTRun1_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--$proj --lowpass 20 >>& $log
			cp $1_AXCPTRun1-ave.fif $1_AXCPT_All-ave.fif
		endif
	endif

	####################################


end
