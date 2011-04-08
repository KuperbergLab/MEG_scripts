#!/bin/csh

setenv SUBJECT $1
cd /cluster/kuperberg/SemPrMM/MEG/data/$1/ave_projon

#####Make stc files to subtract in Matlab####

###Unmorphed##

foreach run (1 2 3 4)
	
	mne_make_movie --inv $1_BaleenRun{$run}-ave-7-meg-inv.fif --meas $1_BaleenRun{$run}-ave.fif --set 4 --bmin -100 --bmax -.01 --stc $1_BaleenRun{$run}_c4-spm.stc --smooth 5 --spm
	
	foreach cond (1 2)	
		mne_make_movie --inv $1_BaleenRun{$run}-ave-7-meg-inv.fif --meas $1_BaleenRun{$run}-ave.fif --set $cond --bmin -100 --bmax -.01 --stc $1_BaleenRun{$run}_c{$cond}-spm.stc --smooth 5 --spm
	end

end

foreach run (5 6 7 8)

	foreach cond (1 2)	
		mne_make_movie --inv $1_BaleenRun{$run}-ave-7-meg-inv.fif --meas $1_BaleenRun{$run}-ave.fif --set $cond --bmin -100 --bmax -.01 --stc $1_BaleenRun{$run}_c{$cond}-spm.stc --smooth 5 --spm
	end
	
end


##Morphed##

foreach run (1 2 3 4)

	mne_make_movie --inv $1_BaleenRun{$run}-ave-7-meg-inv.fif --meas $1_BaleenRun{$run}-ave.fif --set 4 --bmin -100 --bmax -.01 --stc $1_BaleenRun{$run}_c4-spm-M.stc --smooth 5 --spm --morph fsaverage

end

########FIX GROUP ON ALL FILES########
chgrp -R lingua .