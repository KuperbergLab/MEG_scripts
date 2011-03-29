
#####Make stc files to subtract in Matlab####

###Unmorphed##

mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 4 --bmin -100 --bmax -.01 --stc $1_BaleenLP_UnRelFiller-spm.stc --smooth 5 --spm

mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc $1_BaleenHP_Rel-spm.stc --smooth 5 --spm

mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc $1_BaleenHP_Unrel-spm.stc --smooth 5 --spm

##Morphed##
mne_make_movie --inv $1_BaleenLP_All-ave-7-meg-meg-inv.fif --meas $1_BaleenLP_All-ave.fif --set 4 --bmin -100 --bmax -.01 --stc $1_BaleenLP_UnRelFillerM-spm.stc --smooth 5 --spm --morph fsaverage

mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 1 --bmin -100 --bmax -.01 --stc $1_BaleenHP_RelM-spm.stc --smooth 5 --spm --morph fsaverage

mne_make_movie --inv $1_BaleenHP_All-ave-7-meg-meg-inv.fif --meas $1_BaleenHP_All-ave.fif --set 2 --bmin -100 --bmax -.01 --stc $1_BaleenHP_UnrelM-spm.stc --smooth 5 --spm --morph fsaverage


########FIX GROUP ON ALL FILES########
chgrp -R lingua .