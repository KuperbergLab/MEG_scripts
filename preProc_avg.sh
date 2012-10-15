#!/bin/csh -f

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

foreach proj ( 'projon' 'projoff') ## Do not change the order. 
	echo "Making Ave Parameter Files" >>& $log
	python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py $1 $proj >>& $log

	echo "Making Avg fif Files" >>& $log
	cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_$proj
 
 	mne_process_raw \
 	--raw ../$1_Blink_raw.fif \
 	--ave ../ave/$1_Blink.ave \
 	--$proj --lowpass 20 >>& $log
 
 	mne_process_raw \
 	--raw ../$1_ATLLoc_ssp_raw.fif \
 	--ave ../ave/$1_ATLLoc.ave \
 	--$proj --lowpass 20 --highpass .5 >>& $log
 	
 	mne_process_raw \
 	--raw ../$1_MaskedMMRun1_ssp_raw.fif \
 	--raw ../$1_MaskedMMRun2_ssp_raw.fif \
 	--ave ../ave/$1_MaskedMMRun1.ave \
 	--ave ../ave/$1_MaskedMMRun2.ave \
 	--gave $1_MaskedMM_All-ave.fif \
 	--$proj --lowpass 20 >>& $log
#  
 	mne_process_raw \
 	--raw ../$1_BaleenLPRun1_ssp_raw.fif \
 	--raw ../$1_BaleenLPRun2_ssp_raw.fif \
 	--raw ../$1_BaleenLPRun3_ssp_raw.fif \
 	--raw ../$1_BaleenLPRun4_ssp_raw.fif \
 	--ave ../ave/$1_BaleenLPRun1.ave \
 	--ave ../ave/$1_BaleenLPRun2.ave \
 	--ave ../ave/$1_BaleenLPRun3.ave \
 	--ave ../ave/$1_BaleenLPRun4.ave \
 	--gave $1_BaleenLP_All-ave.fif \
 	--$proj --lowpass 20 >>& $log


 
 	mne_process_raw \
 	--raw ../$1_BaleenHPRun1_ssp_raw.fif \
 	--raw ../$1_BaleenHPRun2_ssp_raw.fif \
 	--raw ../$1_BaleenHPRun3_ssp_raw.fif \
 	--raw ../$1_BaleenHPRun4_ssp_raw.fif \
 	--ave ../ave/$1_BaleenHPRun1.ave \
 	--ave ../ave/$1_BaleenHPRun2.ave \
 	--ave ../ave/$1_BaleenHPRun3.ave \
 	--ave ../ave/$1_BaleenHPRun4.ave \
 	--gave $1_BaleenHP_All-ave.fif \
 	--$proj --lowpass 20 >>& $log


 	if ( -e ../$1_AXCPTRun1_ssp_raw.fif ) then
 		if ( -e ../$1_AXCPTRun2_ssp_raw.fif ) then
 			mne_process_raw \
 			--raw ../$1_AXCPTRun1_ssp_raw.fif \
 			--raw ../$1_AXCPTRun2_ssp_raw.fif \
 			--ave ../ave/$1_AXCPTRun1.ave \
 			--ave ../ave/$1_AXCPTRun2.ave \
 			--gave $1_AXCPT_All-ave.fif \
 			--$proj --lowpass 20 >>& $log
 		else
 			mne_process_raw \
 			--raw ../$1_AXCPTRun1_ssp_raw.fif \
 			--ave ../ave/$1_AXCPTRun1.ave \
 			--$proj --lowpass 20 >>& $log
 			cp $1_AXCPTRun1-ave.fif $1_AXCPT_All-ave.fif
 		endif
 	endif
 	
	
	##Hack for ac8, missing run and LF noise
	if ( $1 == 'ac8' ) then
		
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_ssp_raw.fif \
		--raw ../$1_BaleenLPRun3_ssp_raw.fif \
		--raw ../$1_BaleenLPRun4_ssp_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun3.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 --highpass .5 >>& $log

 	mne_process_raw \
 	--raw ../$1_BaleenHPRun1_ssp_raw.fif \
 	--raw ../$1_BaleenHPRun2_ssp_raw.fif \
 	--raw ../$1_BaleenHPRun3_ssp_raw.fif \
 	--raw ../$1_BaleenHPRun4_ssp_raw.fif \
 	--ave ../ave/$1_BaleenHPRun1.ave \
 	--ave ../ave/$1_BaleenHPRun2.ave \
 	--ave ../ave/$1_BaleenHPRun3.ave \
 	--ave ../ave/$1_BaleenHPRun4.ave \
 	--gave $1_BaleenHP_All-ave.fif \
 	--$proj --lowpass 20 --highpass .5 >>& $log

	endif	

	##hack for ac22, highpass
	if ( $1 == 'ac22' ) then
		
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_ssp_raw.fif \
		--raw ../$1_BaleenLPRun2_ssp_raw.fif \
		--raw ../$1_BaleenLPRun3_ssp_raw.fif \
		--raw ../$1_BaleenLPRun4_ssp_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun2.ave \
		--ave ../ave/$1_BaleenLPRun3.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 --highpass .5 >>& $log

 	mne_process_raw \
 	--raw ../$1_BaleenHPRun1_ssp_raw.fif \
 	--raw ../$1_BaleenHPRun2_ssp_raw.fif \
 	--raw ../$1_BaleenHPRun3_ssp_raw.fif \
 	--raw ../$1_BaleenHPRun4_ssp_raw.fif \
 	--ave ../ave/$1_BaleenHPRun1.ave \
 	--ave ../ave/$1_BaleenHPRun2.ave \
 	--ave ../ave/$1_BaleenHPRun3.ave \
 	--ave ../ave/$1_BaleenHPRun4.ave \
 	--gave $1_BaleenHP_All-ave.fif \
 	--$proj --lowpass 20 --highpass .5 >>& $log


	endif	
 
 
        ##Lost BaleenLPRun3, so averaging only 3 runs
	if ( $1 == 'ac19' ) then
		
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_ssp_raw.fif \
		--raw ../$1_BaleenLPRun2_ssp_raw.fif \
		--raw ../$1_BaleenLPRun4_ssp_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun2.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log

	endif	
	##Sc3_LP4 and sc4 LP2 have the nskip issue, so creating the average without them for no 9/4/12
	if ( $1 == 'sc4' ) then
		
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_ssp_raw.fif \
		--raw ../$1_BaleenLPRun3_ssp_raw.fif \
		--raw ../$1_BaleenLPRun4_ssp_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun3.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log

	endif
	if ( $1 == 'sc3' ) then
		
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_ssp_raw.fif \
		--raw ../$1_BaleenLPRun2_ssp_raw.fif \
		--raw ../$1_BaleenLPRun3_ssp_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun2.ave \
		--ave ../ave/$1_BaleenLPRun3.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log

	endif
	####################################
    if ( $proj == 'projon' ) then
        	echo "Making ModRej4projoff.eve files" >>& $log
	        python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_rej2eve_projon.py $1 >>& $log
	        echo "done" >>& $log
    endif  

 end

#mkdir /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_MaxFilter
#mkdir /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_MaxFilter/logs


#echo "Making Ave Parameter Files for MaxFilter" >>& $log
#python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py $1 projon >>& $log

#echo "Making Avg fif Files for MaxFilter" >>& $log
#cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_MaxFilter

#mne_process_raw \
#--raw ../$1_BaleenHPRun1_MF_raw.fif \
#--raw ../$1_BaleenHPRun2_MF_raw.fif \
#--raw ../$1_BaleenHPRun3_MF_raw.fif \
#--raw ../$1_BaleenHPRun4_MF_raw.fif \
#--ave ../ave/$1_BaleenHPRun1.ave \
#--ave ../ave/$1_BaleenHPRun2.ave \
#--ave ../ave/$1_BaleenHPRun3.ave \
#--ave ../ave/$1_BaleenHPRun4.ave \
#--gave $1_BaleenHP_All-ave.fif \
#--projon --lowpass 20 >>& $log


