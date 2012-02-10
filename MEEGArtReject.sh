#!/bin/csh -f
#usage: MEGArtReject.sh SubjType 
#usage: subjType: sc ac or ya (in Lower case) 
#Computes the MEG and EEG rejection for all paradigms - 'ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM' 'AXCPT'- (only in the case of ya)


echo 'CountEvents-CountBadChannels'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
foreach par ('ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM')
   echo $par
   foreach i ( $1* )
      echo $i 
      cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/
      if ($par == 'ATLLoc') then
          if ( -e /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/{$i}_ATLLoc-ave.log) then
              foreach t ( {$i}_ATLLoc-ave.log ) 
                  python /cluster/kuperberg/SemPrMM/MEG/scripts/countBadChan.py $t $par 
              end
          endif
      else
         if (-e /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/{$i}_ATLLoc-ave.log ) then
              foreach t ( {$i}_{$par}Run?-ave.log ) 
                  python /cluster/kuperberg/SemPrMM/MEG/scripts/countBadChan.py $t $par
              end
         endif
      endif      
      cd ../../..
    end
end


if ($1 == 'ya') then
    echo 'AXCPT for ya'
    foreach i ($1*)
      cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs
      if (-e /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/{$i}_AXCPTRun1-ave.log) then 
          foreach t ( {$i}_AXCPTRun?-ave.log ) 
                 python /cluster/kuperberg/SemPrMM/MEG/scripts/countBadChan.py $t AXCPT
          end
      endif
      cd ../../..
    end
endif
 
cd ../../..

echo 'Clearing existing results from MEG/results folder'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/results/artifact_rejection/megeeg_rejection
   rm $1_MEEGArtRejSummary_ATLLoc
   rm $1_MEEGArtRejSummary_BaleenHP
   rm $1_MEEGArtRejSummary_BaleenLP
   rm $1_MEEGArtRejSummary_MaskedMM
   rm $1_MEEGArtRejSummary_AXCPT
cd ../../..
echo 'ComputeEvents'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
foreach par ( 'AXCPT' 'ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM' )
   echo $par
   python /cluster/kuperberg/SemPrMM/MEG/scripts/computeEvents.py $1 $par /cluster/kuperberg/SemPrMM/MEG/results/artifact_rejection/megeeg_rejection/$1_MEEGArtRejSummary-$par
end
echo 'Results saved in MEG/results/artifact_rejection/megeeg_rejection folder' 
