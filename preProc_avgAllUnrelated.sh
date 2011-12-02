#!/bin/csh -f

#usage preProc_avg [subject] [log file]

if ( $#argv == 0 ) then 
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 1 ) then
    set log='./preProc_avgAllUnrelated.log'
    echo "Logging to default log..." >>& $log
endif

if ( $#argv == 2) then
    set log=$2
endif

# if log exists, delete
if ( -e $log ) then
    rm $log
endif


echo "Fixing Triggers"
python fixTriggersAllUnrelated.py $1

echo "Making Ave Parameter Files" >>& $log

python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFilesAllUnrelated.py $1 >>& $log



foreach proj ( 'projoff' 'projon')
	echo "Making Avg fif Files" >>& $log
	cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_$proj

	mne_process_raw \
	--raw ../$1_BaleenLPRun1_raw.fif \
	--raw ../$1_BaleenLPRun2_raw.fif \
	--raw ../$1_BaleenLPRun3_raw.fif \
	--raw ../$1_BaleenLPRun4_raw.fif \
	--ave ../ave/$1_BaleenLPRun1AllUnrelated.ave \
	--ave ../ave/$1_BaleenLPRun2AllUnrelated.ave \
	--ave ../ave/$1_BaleenLPRun3AllUnrelated.ave \
	--ave ../ave/$1_BaleenLPRun4AllUnrelated.ave \
	--gave $1_BaleenLP_AllUnrelated-ave.fif \
	--$proj --lowpass 20 >>& $log

	mne_process_raw \
	--raw ../$1_BaleenHPRun1_raw.fif \
	--raw ../$1_BaleenHPRun2_raw.fif \
	--raw ../$1_BaleenHPRun3_raw.fif \
	--raw ../$1_BaleenHPRun4_raw.fif \
	--ave ../ave/$1_BaleenHPRun1AllUnrelated.ave \
	--ave ../ave/$1_BaleenHPRun2AllUnrelated.ave \
	--ave ../ave/$1_BaleenHPRun3AllUnrelated.ave \
	--ave ../ave/$1_BaleenHPRun4AllUnrelated.ave \
	--gave $1_BaleenHP_AllUnrelated-ave.fif \
	--$proj --lowpass 20 >>& $log
end
