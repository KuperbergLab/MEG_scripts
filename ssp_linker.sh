#!/bin/csh -f
#usage ./ssp_linker.sh subjID tag paradigm 
#Example: ./ssp_linker.sh ya1 ecg MaskedMM 


cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$1/
echo "Creating the symbolic links for the ssp files" 




echo "removed"

if $2 == 'raw' then
   set label = 'raw' 

else if $2 == 'ecg' then 
   set label = 'ecg_avg_proj_raw'

else if $2 == 'eog' then 
   set label = 'eog_avg_proj_raw'

else if $2 == 'ecgeog' then 
   set label = 'ecgeog_avg_proj_raw'

endif

echo $label
rm {$1}_{$3}Run1_ssp_raw.fif
rm {$1}_{$3}Run2_ssp_raw.fif

if $3 == 'ATLLoc' then 
      if $2 == 'raw' then 
            ln -s {$1}_ATLLoc_$label.fif {$1}_ATLLoc_ssp_raw.fif
      else 
            ln -s /ssp/{$1}_ATLLoc_$label.fif {$1}_ATLLoc_ssp_raw.fif
      endif
else
      pwd
      if $2 == 'raw' then
            if (-e {$1}_{$3}Run1_raw.fif) then 
                  ln -s {$1}_{$3}Run1_$label.fif {$1}_{$3}Run1_ssp_raw.fif 
            endif
            if (-e {$1}_{$3}Run2_raw.fif) then 
                  ln -s {$1}_{$3}Run2_$label.fif {$1}_{$3}Run2_ssp_raw.fif 
            endif
            if (-e {$1}_{$3}Run3_raw.fif) then 
                  ln -s {$1}_{$3}Run3_$label.fif {$1}_{$3}Run3_ssp_raw.fif 
            endif            
            if (-e {$1}_{$3}Run4_raw.fif) then 
                  ln -s {$1}_{$3}Run4_$label.fif {$1}_{$3}Run4_ssp_raw.fif 
            endif
      else 
            if (-e {$1}_{$3}Run1_raw.fif) then 
                  ln -s /ssp/{$1}_{$3}Run1_$label.fif {$1}_{$3}Run1_ssp_raw.fif 
            endif
            if (-e {$1}_{$3}Run2_raw.fif) then 
                  ln -s /ssp/{$1}_{$3}Run2_$label.fif {$1}_{$3}Run2_ssp_raw.fif 
            endif
            if (-e {$1}_{$3}Run3_raw.fif) then 
                  ln -s /ssp/{$1}_{$3}Run3_$label.fif {$1}_{$3}Run3_ssp_raw.fif 
            endif            
            if (-e {$1}_{$3}Run4_raw.fif) then 
                  ln -s /ssp/{$1}_{$3}Run4_$label.fif {$1}_{$3}Run4_ssp_raw.fif 
            endif
       endif   
endif

 

