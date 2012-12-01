#!/bin/csh -f
#usage: MEEGArtReject.sh SubjType 
#eg: ./MEEGArtReject.sh ac  
#Computes the MEG and EEG channel rejections for all paradigms - 'ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM' 'AXCPT'- (only in the case of ya). This is computed after the eyeblink(HEOG/VEOG)Rejection. 


echo 'CountEvents-CountBadChannels'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
foreach par ('BaleenHP' 'BaleenLP' 'ATLLoc' 'MaskedMM')
#foreach par ('BaleenHP' 'BaleenLP')
   echo $par
   foreach i (`cat /autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/$1.meg.all.txt`)   
         set subj = $1$i
         echo $subj
         rm /cluster/kuperberg/SemPrMM/MEG/data/$subj/ave_projon/logs/{$subj}_MEEGArtReject_{$par}
	 rm /cluster/kuperberg/SemPrMM/MEG/data/$subj/ave_projon/logs/{$subj}_MEEGArtReject-BadChan_{$par}
         if ($par == 'ATLLoc') then 
             echo $par
             if ( -e /autofs/cluster/kuperberg/SemPrMM/MEG/data/$subj/ave_projon/logs/{$subj}_ATLLoc-ave.log) then
               cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$subj/ave_projon/logs/
               foreach t ( {$subj}_ATLLoc-ave.log )
                  python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_countBadChan.py $t $par 
               end
             endif
         else
            echo $par 
            if (-e /autofs/cluster/kuperberg/SemPrMM/MEG/data/$subj/ave_projon/logs/{$subj}_ATLLoc-ave.log ) then
               cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$subj/ave_projon/logs/
               foreach t ( {$subj}_{$par}Run?-ave.log )
                       python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_countBadChan.py $t $par 
               end
            endif
         endif
         cd ../../../
   end
end


if ($1 == 'ya') then
    echo 'AXCPT for ya'
    foreach i (`cat /autofs/cluster/kuperberg/SemPrMM/MEG/scripts/function_inputs/$1.meg.all.txt`)   
      set subj = $1$i
      cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/$subj/ave_projon/logs
      if (-e /autofs/cluster/kuperberg/SemPrMM/MEG/data/$subj/ave_projon/logs/{$subj}_AXCPTRun1-ave.log) then 
          foreach t ( {$subj}_AXCPTRun?-ave.log ) 
                 python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_countBadChan.py $t AXCPT
          end
      endif
      cd ../../..
    end
endif
 

echo 'ComputeEvents'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
foreach par ('ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM')
#foreach par ('BaleenHP' 'BaleenLP')
      echo $par
      python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_computeEvents.py $1 $par 
end
echo 'Results saved in MEG/results/artifact_rejection/megeeg_rejection folder' 

