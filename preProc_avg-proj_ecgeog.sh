#!/bin/csh -f

## CandidaUstine
#usage preProc_avg [subject] [tag] [log file]


if ( $#argv == 0 ) then  
    echo "NO SUBJECT ARGUMENT"
    exit 1
endif

if ( $#argv == 2 ) then
    set log='./preProc_avg.log'
    echo "Logging to default log..." >>& $log
endif

if ( $#argv == 3) then
    set log=$2
endif

# if log exists, delete
if ( -e $log ) then
    rm $log
endif

if $2 == 'ecg' then

    foreach proj ( 'projon' 'projoff' )
	   echo "Making Ave Parameter Files" >>& $3
	   python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py $1 $proj >>& $3

	   echo "Making Avg fif Files" >>& $3
	   cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_$proj

	   mne_process_raw \
	   --raw ../$1_Blink_raw.fif \
	   --ave ../ave/$1_Blink.ave \
	   --$proj --lowpass 20 >>& $log

	   mne_process_raw \
	   --raw ../$1_ATLLoc_ecg_proj_raw.fif \
	   --ave ../ave/$1_ATLLoc.ave \
	   --$proj --lowpass 20 --highpass .5 >>& $log
	
	   mne_process_raw \
	   --raw ../$1_MaskedMMRun1_ecg_proj_raw.fif \
	   --raw ../$1_MaskedMMRun2_ecg_proj_raw.fif \
	   --ave ../ave/$1_MaskedMMRun1.ave \
	   --ave ../ave/$1_MaskedMMRun2.ave \
	   --gave $1_MaskedMM_All-ecgproj-ave.fif \
	   --$proj --lowpass 20 >>& $3

	   mne_process_raw \
	   --raw ../$1_BaleenLPRun1_ecg_proj_raw.fif \
	   --raw ../$1_BaleenLPRun2_ecg_proj_raw.fif \
	   --raw ../$1_BaleenLPRun3_ecg_proj_raw.fif \
	   --raw ../$1_BaleenLPRun4_ecg_proj_raw.fif \
	   --ave ../ave/$1_BaleenLPRun1_ecg_proj.ave \
	   --ave ../ave/$1_BaleenLPRun2.ave \
	   --ave ../ave/$1_BaleenLPRun3.ave \
	   --ave ../ave/$1_BaleenLPRun4.ave \
	   --gave $1_BaleenLP_All-ave.fif \
	   --$proj --lowpass 20 >>& $log

	   mne_process_raw \
	   --raw ../$1_BaleenHPRun1_ecg_proj_raw.fif \
	   --raw ../$1_BaleenHPRun2_ecg_proj_raw.fif \
	   --raw ../$1_BaleenHPRun3_ecg_proj_raw.fif \
	   --raw ../$1_BaleenHPRun4_ecg_proj_raw.fif \
	   --ave ../ave/$1_BaleenHPRun1.ave \
	   --ave ../ave/$1_BaleenHPRun2.ave \
	   --ave ../ave/$1_BaleenHPRun3.ave \
	   --ave ../ave/$1_BaleenHPRun4.ave \
	   --gave $1_BaleenHP_All-ave.fif \
	   --$proj --lowpass 20 >>& $log


	   if ( -e ../$1_AXCPTRun1_raw.fif ) then
		 if ( -e ../$1_AXCPTRun2_raw.fif ) then
			mne_process_raw \
			--raw ../$1_AXCPTRun1_ecg_proj_raw.fif \
			--raw ../$1_AXCPTRun2_ecg_proj_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--ave ../ave/$1_AXCPTRun2.ave \
			--gave $1_AXCPT_All-ave.fif \
			--$proj --lowpass 20 >>& $log
		 else
			mne_process_raw \
			--raw ../$1_AXCPTRun1_ecg_proj_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--$proj --lowpass 20 >>& $log
			cp $1_AXCPTRun1-ave.fif $1_AXCPT_All-ave.fif
		 endif
	   endif
	
	
	##Hack for ac8 BaleenLP
	   if ( $1 == 'ac8' ) then
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_ecg_proj_raw.fif \
		--raw ../$1_BaleenLPRun3_ecg_proj_raw.fif \
		--raw ../$1_BaleenLPRun4_ecg_proj_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun3.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log
	   endif	
 
        ##Lost BaleenLPRun3, so averaging only 3 runs
	   if ( $1 == 'ac19' ) then
		
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_ecg_proj_raw.fif \
		--raw ../$1_BaleenLPRun2_ecg_proj_raw.fif \
		--raw ../$1_BaleenLPRun4_ecg_proj_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun2.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log

	   endif	

	####################################
       if ( $proj == 'projon' ) then
        	echo "Making ModRej4projoff.eve files" >>& $3
	        python /cluster/kuperberg/SemPrMM/MEG/scripts/projonrej2eve.py $1 >>& $3
       endif  
    end

else if $2 == 'eog' then 

    foreach proj ( 'projon' 'projoff' )
	   echo "Making Ave Parameter Files" >>& $log
	   python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py $1 $proj >>& $log

	   echo "Making Avg fif Files" >>& $log
	   cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_$proj

	   mne_process_raw \
	   --raw ../$1_Blink_eog_proj_raw.fif \
	   --ave ../ave/$1_Blink.ave \
	   --$proj --lowpass 20 >>& $log

	   mne_process_raw \
	   --raw ../$1_ATLLoc_eog_proj_raw.fif \
	   --ave ../ave/$1_ATLLoc.ave \
	   --$proj --lowpass 20 --highpass .5 >>& $log
	
	   mne_process_raw \
	   --raw ../$1_MaskedMMRun1_eog_proj_raw.fif \
	   --raw ../$1_MaskedMMRun2_eog_proj_raw.fif \
	   --ave ../ave/$1_MaskedMMRun1.ave \
	   --ave ../ave/$1_MaskedMMRun2.ave \
	   --gave $1_MaskedMM_All-ave.fif \
	   --$proj --lowpass 20 >>& $log

	   mne_process_raw \
	   --raw ../$1_BaleenLPRun1_eog_proj_raw.fif \
	   --raw ../$1_BaleenLPRun2_eog_proj_raw.fif \
	   --raw ../$1_BaleenLPRun3_eog_proj_raw.fif \
	   --raw ../$1_BaleenLPRun4_eog_proj_raw.fif \
	   --ave ../ave/$1_BaleenLPRun1.ave \
	   --ave ../ave/$1_BaleenLPRun2.ave \
	   --ave ../ave/$1_BaleenLPRun3.ave \
	   --ave ../ave/$1_BaleenLPRun4.ave \
	   --gave $1_BaleenLP_All-ave.fif \
	   --$proj --lowpass 20 >>& $log

	   mne_process_raw \
	   --raw ../$1_BaleenHPRun1_eog_proj_raw.fif \
	   --raw ../$1_BaleenHPRun2_eog_proj_raw.fif \
	   --raw ../$1_BaleenHPRun3_eog_proj_raw.fif \
	   --raw ../$1_BaleenHPRun4_eog_proj_raw.fif \
	   --ave ../ave/$1_BaleenHPRun1.ave \
	   --ave ../ave/$1_BaleenHPRun2.ave \
	   --ave ../ave/$1_BaleenHPRun3.ave \
	   --ave ../ave/$1_BaleenHPRun4.ave \
	   --gave $1_BaleenHP_All-ave.fif \
	   --$proj --lowpass 20 >>& $log


	   if ( -e ../$1_AXCPTRun1_raw.fif ) then
		 if ( -e ../$1_AXCPTRun2_raw.fif ) then
			mne_process_raw \
			--raw ../$1_AXCPTRun1_eog_proj_raw.fif \
			--raw ../$1_AXCPTRun2_eog_proj_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--ave ../ave/$1_AXCPTRun2.ave \
			--gave $1_AXCPT_All-ave.fif \
			--$proj --lowpass 20 >>& $log
		 else
			mne_process_raw \
			--raw ../$1_AXCPTRun1_eog_proj_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--$proj --lowpass 20 >>& $log
			cp $1_AXCPTRun1-ave.fif $1_AXCPT_All-ave.fif
		 endif
	   endif
	
	
	##Hack for ac8 BaleenLP
	   if ( $1 == 'ac8' ) then
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_eog_proj_raw.fif \
		--raw ../$1_BaleenLPRun3_eog_proj_raw.fif \
		--raw ../$1_BaleenLPRun4_eog_proj_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun3.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log
	   endif	
 
        ##Lost BaleenLPRun3, so averaging only 3 runs
	   if ( $1 == 'ac19' ) then
		
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_eog_proj_raw.fif \
		--raw ../$1_BaleenLPRun2_eog_proj_raw.fif \
		--raw ../$1_BaleenLPRun4_eog_proj_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun2.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log

	   endif	

	####################################
       if ( $proj == 'projon' ) then
        	echo "Making ModRej4projoff.eve files" >>& $log
	        python /cluster/kuperberg/SemPrMM/MEG/scripts/projonrej2eve.py $1 >>& $log
       endif  

    end

else if $2 =='ecgeog' then 

    foreach proj ( 'projon' 'projoff' )
	   echo "Making Ave Parameter Files" >>& $log
	   python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py $1 $proj >>& $log

	   echo "Making Avg fif Files" >>& $log
	   cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_$proj

	   mne_process_raw \
	   --raw ../$1_Blink_ecgeog_proj_raw.fif \
	   --ave ../ave/$1_Blink.ave \
	   --$proj --lowpass 20 >>& $log

	   mne_process_raw \
	   --raw ../$1_ATLLoc_ecgeog_proj_raw.fif \
	   --ave ../ave/$1_ATLLoc.ave \
	   --$proj --lowpass 20 --highpass .5 >>& $log
	
	   mne_process_raw \
	   --raw ../$1_MaskedMMRun1_ecgeog_proj_raw.fif \
	   --raw ../$1_MaskedMMRun2_ecgeog_proj_raw.fif \
	   --ave ../ave/$1_MaskedMMRun1.ave \
	   --ave ../ave/$1_MaskedMMRun2.ave \
	   --gave $1_MaskedMM_All-ave.fif \
	   --$proj --lowpass 20 >>& $log

	   mne_process_raw \
	   --raw ../$1_BaleenLPRun1_ecgeog_proj_raw.fif \
	   --raw ../$1_BaleenLPRun2_ecgeog_proj_raw.fif \
	   --raw ../$1_BaleenLPRun3_ecgeog_proj_raw.fif \
	   --raw ../$1_BaleenLPRun4_ecgeog_proj_raw.fif \
	   --ave ../ave/$1_BaleenLPRun1.ave \
	   --ave ../ave/$1_BaleenLPRun2.ave \
	   --ave ../ave/$1_BaleenLPRun3.ave \
	   --ave ../ave/$1_BaleenLPRun4.ave \
	   --gave $1_BaleenLP_All-ave.fif \
	   --$proj --lowpass 20 >>& $log

	   mne_process_raw \
	   --raw ../$1_BaleenHPRun1_ecgeog_proj_raw.fif \
	   --raw ../$1_BaleenHPRun2_ecgeog_proj_raw.fif \
	   --raw ../$1_BaleenHPRun3_ecgeog_proj_raw.fif \
	   --raw ../$1_BaleenHPRun4_ecgeog_proj_raw.fif \
	   --ave ../ave/$1_BaleenHPRun1.ave \
	   --ave ../ave/$1_BaleenHPRun2.ave \
	   --ave ../ave/$1_BaleenHPRun3.ave \
	   --ave ../ave/$1_BaleenHPRun4.ave \
	   --gave $1_BaleenHP_All-ave.fif \
	   --$proj --lowpass 20 >>& $log


	   if ( -e ../$1_AXCPTRun1_raw.fif ) then
		 if ( -e ../$1_AXCPTRun2_raw.fif ) then
			mne_process_raw \
			--raw ../$1_AXCPTRun1_ecgeog_proj_raw.fif \
			--raw ../$1_AXCPTRun2_ecgeog_proj_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--ave ../ave/$1_AXCPTRun2.ave \
			--gave $1_AXCPT_All-ave.fif \
			--$proj --lowpass 20 >>& $log
		 else
			mne_process_raw \
			--raw ../$1_AXCPTRun1_ecgeog_proj_raw.fif \
			--ave ../ave/$1_AXCPTRun1.ave \
			--$proj --lowpass 20 >>& $log
			cp $1_AXCPTRun1-ave.fif $1_AXCPT_All-ave.fif
		 endif
	   endif
	
	
	##Hack for ac8 BaleenLP
	   if ( $1 == 'ac8' ) then
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_ecgeog_proj_raw.fif \
		--raw ../$1_BaleenLPRun3_ecgeog_proj_raw.fif \
		--raw ../$1_BaleenLPRun4_ecgeog_proj_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun3.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log
	   endif	
 
        ##Lost BaleenLPRun3, so averaging only 3 runs
	   if ( $1 == 'ac19' ) then
		
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_ecgeog_proj_raw.fif \
		--raw ../$1_BaleenLPRun2_ecgeog_proj_raw.fif \
		--raw ../$1_BaleenLPRun4_ecgeog_proj_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun2.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log

	   endif	

	####################################
       if ( $proj == 'projon' ) then
        	echo "Making ModRej4projoff.eve files" >>& $log
	        python /cluster/kuperberg/SemPrMM/MEG/scripts/projonrej2eve.py $1 >>& $log
       endif  
    end

else

    foreach proj ( 'projon' 'projoff' )
	   echo "Making Ave Parameter Files" >>& $log
	   python /cluster/kuperberg/SemPrMM/MEG/scripts/makeAveFiles.py $1 $proj >>& $log

	   echo "Making Avg fif Files" >>& $log
	   cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_$proj

	   mne_process_raw \
	   --raw ../$1_Blink_raw.fif \
	   --ave ../ave/$1_Blink.ave \
	   --$proj --lowpass 20 >>& $log

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
	
	
	##Hack for ac8 BaleenLP
	   if ( $1 == 'ac8' ) then
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_raw.fif \
		--raw ../$1_BaleenLPRun3_raw.fif \
		--raw ../$1_BaleenLPRun4_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun3.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log
	   endif	
 
        ##Lost BaleenLPRun3, so averaging only 3 runs
	   if ( $1 == 'ac19' ) then
		
		mne_process_raw \
		--raw ../$1_BaleenLPRun1_raw.fif \
		--raw ../$1_BaleenLPRun2_raw.fif \
		--raw ../$1_BaleenLPRun4_raw.fif \
		--ave ../ave/$1_BaleenLPRun1.ave \
		--ave ../ave/$1_BaleenLPRun2.ave \
		--ave ../ave/$1_BaleenLPRun4.ave \
		--gave $1_BaleenLP_All-ave.fif \
		--$proj --lowpass 20 >>& $log

	   endif	

	####################################
       if ( $proj == 'projon' ) then
        	echo "Making ModRej4projoff.eve files" >>& $log
	        python /cluster/kuperberg/SemPrMM/MEG/scripts/projonrej2eve.py $1 >>& $log
       endif  
    end

endif



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


