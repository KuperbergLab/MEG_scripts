#!/bin/csh -f
## Usage ./call_preProc_Pyavg.sh subjectType 


cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
#foreach par ('BaleenHP' 'BaleenLP' 'ATLLoc' 'MaskedMM')
foreach par ('BaleenHP')
   echo $par
   foreach i (`cat /autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/$1.meg.all.txt`)   
         set subj = $1$i
         echo $subj
         python  /cluster/kuperberg/SemPrMM/MEG/scripts/preProc_avg.py $subj $par
   end
