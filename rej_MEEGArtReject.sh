#!/bin/csh -f
#usage: MEEGArtReject.sh SubjType 
#eg: ./MEEGArtReject.sh ac  
#Computes the MEG and EEG channel rejections for all paradigms - 'ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM' 'AXCPT'- (only in the case of ya). This is computed after the eyeblink(HEOG/VEOG)Rejection. 


echo 'CountEvents-CountBadChannels'
cd /autofs/cluster/kuperberg/SemPrMM/MEG/data/
#foreach par ('BaleenHP' 'BaleenLP' 'ATLLoc' 'MaskedMM')
foreach par ('BaleenHP')
   echo $par
  # foreach i ( 'ac1' 'ac2' 'ac3' 'ac6' 'ac8' 'ac11' 'ac12' 'ac13' 'ac14' 'ac16' 'ac19' 'ac20' 'ac22' 'ac23' 'ac23' 'ac24' 'ac28' )
  # foreach i ( 'sc12' )
   foreach i ( 'sc1' 'sc3' 'sc4' 'sc5' 'sc6' 'sc7' 'sc8' 'sc9' 'sc10' 'sc12' 'sc13' 'sc14' 'sc15' 'sc16' 'sc17' 'sc18' )

         echo $i
         rm /cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/{$i}_MEEGArtReject_{$par}
	     rm /cluster/kuperberg/SemPrMM/MEG/data/$i/ave_projon/logs/{$i}_MEEGArtReject-BadChan_{$par}
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
               #echo 'jane nadri iraiva....'
               foreach t ( {$i}_{$par}Run?-ave.log )
                       python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_countBadChan.py $t $par 
               end
               
#                if ($i != 'sc12') then 
#                    foreach t ( {$i}_{$par}Run?_ecgeog1-ave.log )
# 					  echo $t   
# 					  python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_countBadChan.py $t $par 
# 				   end
# 			    else
#                    foreach t ( sc12_{$par}Run?_ecgeog1-0.2-ave.log )
# 					  echo $t   
# 					  python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_countBadChan.py $t $par 
# 				   end 
# 				endif
            endif
         endif
         cd ../../../
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
#foreach par ('ATLLoc' 'BaleenHP' 'BaleenLP' 'MaskedMM')
foreach par ('BaleenHP')
   echo $par
   python /cluster/kuperberg/SemPrMM/MEG/scripts/rej_computeEvents.py $1 $par 
end
echo 'Results saved in MEG/results/artifact_rejection/megeeg_rejection folder' 
