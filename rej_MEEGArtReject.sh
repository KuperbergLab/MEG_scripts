#!/bin/csh -f
#usage: MEEGArtReject.sh SubjType 
#eg: ./MEEGArtReject.sh ac  
#Computes the MEG and EEG channel rejections for all paradigms - 'ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM' 'AXCPT'- (only in the case of ya). This is computed after the eyeblink(HEOG/VEOG)Rejection. 


echo 'CountEvents-CountBadChannels'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
foreach par ('ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM')
#foreach par ('BaleenLP')
   echo $par
   foreach i ( $1* )
         echo $i
         if ($par == 'ATLLoc') then
             echo $par
             if ( -e /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/{$i}_ATLLoc-ave.log) then
               cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/
               foreach t ( {$i}_ATLLoc-ave.log )
                  python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_countBadChan.py $t $par 
               end
             endif
         else
            echo $par 
            if (-e /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/{$i}_ATLLoc-ave.log ) then
               cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/
               foreach t ( {$i}_{$par}Run?-ave.log )
                  #echo $t   
                  python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_countBadChan.py $t $par
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
                 python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_countBadChan.py $t AXCPT
          end
      endif
      cd ../../..
    end
endif
 

echo 'ComputeEvents'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
foreach par ('ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM')
   echo $par
   python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_computeEvents.py $1 $par /cluster/kuperberg/SemPrMM/MEG/results/artifact_rejection/megeeg_rejection/$1_MEEGArtRejSummary-$par
end
echo 'Results saved in MEG/results/artifact_rejection/megeeg_rejection folder' 
