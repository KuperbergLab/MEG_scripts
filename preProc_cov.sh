#!/bin/csh -f 

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 1 ) then
    set log='./preProc_cov.log'
    echo "Logging to default log..." >>& $log
endif

if ( $#argv == 2) then
    set log=$2
endif

# if log exists, delete
if ( -e $log ) then
    rm $log
endif

echo
echo "Making Cov Parameter Files"  >>& $log
cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_projon
python /cluster/kuperberg/SemPrMM/MEG/scripts/makeCovFiles.py $1  >>& $log

echo "Computing covariance"  >>& $log
date
mne_process_raw \
 --raw ../$1_MaskedMMRun1_raw.fif \
 --raw ../$1_MaskedMMRun2_raw.fif \
 --cov ../cov/$1_MaskedMMRun1.cov \
 --cov ../cov/$1_MaskedMMRun2.cov \
 --gcov $1_MaskedMM_All-cov.fif \
 --projon --lowpass 20  >>& $log
 
mne_process_raw \
 --raw ../$1_BaleenLPRun1_raw.fif \
 --raw ../$1_BaleenLPRun2_raw.fif \
 --raw ../$1_BaleenLPRun3_raw.fif \
 --raw ../$1_BaleenLPRun4_raw.fif \
 --raw ../$1_BaleenHPRun1_raw.fif \
 --raw ../$1_BaleenHPRun2_raw.fif \
 --raw ../$1_BaleenHPRun3_raw.fif \
 --raw ../$1_BaleenHPRun4_raw.fif \
 --cov ../cov/$1_BaleenLPRun1.cov \
 --cov ../cov/$1_BaleenLPRun2.cov \
 --cov ../cov/$1_BaleenLPRun3.cov \
 --cov ../cov/$1_BaleenLPRun4.cov \
 --cov ../cov/$1_BaleenHPRun1.cov \
 --cov ../cov/$1_BaleenHPRun2.cov \
 --cov ../cov/$1_BaleenHPRun3.cov \
 --cov ../cov/$1_BaleenHPRun4.cov \
 --gcov $1_Baleen_All-cov.fif \
 --projon --lowpass 20  >>& $log
 

if ( -e ../$1_AXCPTRun1_raw.fif ) then
	if ( -e ../$1_AXCPTRun2_raw.fif ) then
		mne_process_raw \
		--raw ../$1_AXCPTRun1_raw.fif \
		--raw ../$1_AXCPTRun2_raw.fif \
		--cov ../cov/$1_AXCPTRun1.cov \
		--cov ../cov/$1_AXCPTRun2.cov \
		--gcov $1_AXCPT_All-cov.fif \
		--projon --lowpass 20  >>& $log
	else
		mne_process_raw \
		--raw ../$1_AXCPTRun1_raw.fif \
		--cov ../cov/$1_AXCPTRun1.cov \
		--gcov $1_AXCPT_All-cov.fif \
		--projon --lowpass 20  >>& $log		
	endif
endif


if ( $1 == 'ac19' ) then
		
	mne_process_raw \
		--raw ../$1_BaleenLPRun1_raw.fif \
		--raw ../$1_BaleenLPRun2_raw.fif \
		--raw ../$1_BaleenLPRun4_raw.fif \
		--raw ../$1_BaleenHPRun1_raw.fif \
        --raw ../$1_BaleenHPRun2_raw.fif \
        --raw ../$1_BaleenHPRun3_raw.fif \
        --raw ../$1_BaleenHPRun4_raw.fif \
		--cov ../cov/$1_BaleenLPRun1.cov \
		--cov ../cov/$1_BaleenLPRun2.cov \
		--cov ../cov/$1_BaleenLPRun4.cov \
		--cov ../cov/$1_BaleenHPRun1.cov \
		--cov ../cov/$1_BaleenHPRun2.cov \
		--cov ../cov/$1_BaleenHPRun3.cov \
		--cov ../cov/$1_BaleenHPRun4.cov \
		--gcov $1_Baleen_All-cov.fif \
		--projon --lowpass 20 >>& $log

endif


date
echo "FINISHED"  >>& $log
