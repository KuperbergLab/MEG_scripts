import os
import os.path as op
from glob import glob

from mne import command as commands
from fixTriggers import fixTriggers
from makeAveFiles import makeAveFiles
from makeCovFiles import makeCovFiles
from blinkEveFiles import blinkEveFiles
from countEvents import countEvents

def average(fif,ave,projection="off",lowpass=40,highpass=0.0,gave=None):
    """
    fif,ave are lists
    """
    if "on" in proj:
        proja = True
    if "off" in proj:
        proja = False
    if len(fif) != len(ave):
        raise Exception("average:# fif != # ave")
    commands.process_raw(raw=fif,ave=ave,proj=proja,lowpass=lowpass,highpass=highpass,gave=gave_out)
    
def covariance(fif,cov,projection="off",lowpass=40,highpass=0.0,gcov=None):
    """
    fif,ave are lists
    """
    if "on" in proj:
        proja = True
    else:
        proja = False
    if len(fif) != len(cov):
        raise Exception("covariance:#fif != # ave")
    commands.process_raw(raw=fif,cov=cov,proj=proja,lowpass=lowpass,highpass=highpass,gcov=gcov)


def preProc(sub,directory,**kwargs):
    """
    New pure-python pre-processing for MEG.
    kwargs:force
    """
    #make folders
    dirs = ["raw_backup","eve","ave","cov","ave_projon","ave_projoff","ave_projon/logs","ave_projoff/logs"]
    for dir in dirs:
        to_make = os.path.join(directory,dir)
        if not os.path.exists(to_make):
            os.mkdir(to_make)
    raw_fifs = glob(os.path.join(directory,"*_raw.fif"))
    raw_fifs = filter(lambda x:not("Blink" in x or "emptyroom" in x),raw_fifs)
    #copy _raw.fif
    for raw in raw_fifs:
        fname = os.path.basename(raw)
        fname_copy = os.path.join(directory,"raw_backup",fname)
        if not os.path.exists(fname_copy):
            shutil.copyfile(raw,fname_copy)
    #extract events
    print("Extracting Events...")
    for raw in raw_fifs:
        eve_name = os.path.basename(raw).replace("_raw.fif",".eve")
        eve_p = os.path.join(directory,"eve",eve_name)
		result = commands.process_raw(raw=raw,eventsout=eve_p)
		if result:
			print("ERROR JUST OCCURED")
    #fixTriggers
    print("Fixing Triggers...")
    fixTriggers(sub)
    #rename channels
    if sub in ["ya1","ya3","ya4","ya7"]:
        for raw in raw_fifs:
            rename_chan(fiff=raw,alias="/cluster/kuperberg/SemPrMM/MEG/scripts/alias1.txt")
            result = commands.check_eeg_locations(raw,fix=True)
            if result:
                print("ERROR JUST OCCURED")
    for raw in raw_fifs:
        result = commands.rename_channels(raw,"/cluster/kuperberg/SemPrMM/MEG/scripts/alias2.txt")
    # mark bad chan
    for raw in raw_fifs:
        bad_file = os.path.join(directory,sub+"_bad_chan.txt")
        if not os.path.exists(bad_file):
            raise Exception("preProc: no bad channels file. Fix and re-run")
        result = commands.mark_bad_channels(raw,bad_file)
        if result:
            print("ERROR JUST OCCURED")
    preBlinkTime = "-0.1"
    postBlinkTime = "0.3"
    print("Making Ave Parameter Files...")
    makeAveFiles(sub,preBlinkTime,postBlinkTime)
    print("Making blink .eve files...")
    blinkEveFiles(sub,preBlinkTime,postBlinkTime)
    print("Making Cov parameter files...")
    makeCovFiles(sub,preBlinkTime,postBlinkTime)
    #line up all files
    atl_fif = [os.path.join(directory,"{0}_ATLLoc_raw.fif".format(sub))]
    atl_ave = [os.path.join(directory,"ave","{0}_ATLLoc.ave".format(sub))]
    do_atl = len(atl_fif) == len(atl_ave)
    mask_fif = sorted(glob(os.path.join(directory,"*MaskedMM*_raw.fif")))
    mask_ave = sorted(glob(os.path.join(directory,"ave","*MaskedMM*.ave")))
    do_mask = len(mask_fif) == len(mask_ave)
    blp_fif = sorted(glob(os.path.join(directory,"*BaleenRun[1-4]_raw.fif")))
    blp_ave = sorted(glob(os.path.join(directory,"ave","*BaleenRun[1-4]*.ave")))
    do_blp = len(blp_fif) == len(blp_ave)
    bhp_fif = sorted(glob(os.path.join(directory,"*BaleenRun[5-8]_raw.fif")))
    bhp_ave = sorted(glob(os.path.join(directory,"ave","*BaleenRun[5-8]*.ave")))
    do_bhp = len(bhp_fif) == len(bhp_ave)
    ax_fif = sorted(glob(os.path.join(directory,"*AXCPT*_raw.fif")))
    ax_ave = sorted(glob(os.path.join(directory,"ave","*AXCPT*.ave")))
    do_ax = len(ax_fif) == len(ax_ave)
    #will need to fix later for single runs of AX
    for proj in ["projon","projoff"]:
        if proj == "projon":
            proj_arg = True
        else:
            proj_arg = False
        print("Projection:{0}".format(proj))
        #ATLLoc
        gave = os.path.join(directory,"ave_proj"+proj,"{0}_ATLLoc-ave.fif".format(sub))
        if do_atl:
            print("Averaging ATLLoc")
            commands.process_raw(raw=atl_fif,ave=atl_ave,proj=proj_arg,lowpass=20,highpass=0.5,gave=gave)
        #MaskedMM
        gave = os.path.join(directory,"ave_proj"+proj,"{0}_MaskedMM_All-ave.fif".format(sub))
        if do_mask:
            print("Averaging Mask")
            commands.process_raw(raw=mask_fif,ave=mask_ave,proj=proj_arg,lowpass=20,gave=gave)
        #BaleenLP
        gave = os.path.join(directory,"ave_proj"+proj,"{0}_BaleenLP_All-ave.fif".format(sub))
        if do_blp:
            print("Averaging BaleenLP")
            average(raw=blp_fif,ave=blp_ave,proj=proj_arg,lowpass=20,gave=gave)
        #BaleenHP
        gave = os.path.join(directory,"ave_proj"+proj,"{0}_BaleenHP_All-ave.fif".format(sub))
        if do_bhp:
            print("Averaging BaleenHP")
            average(raw=blp_fif,ave=blp_ave,proj=proj_arg,lowpass=20,gave=gave)
        #AXCPT
        gave = os.path.join(directory,"ave_proj"+proj,"{0}_AXCPT_All-ave.fif".format(sub))
        if do_ax:
            print("Averaging AXCPT")
            average(raw=ax_fif,ave=ax_ave,proj=proj_arg,lowpass=20,gave=gave)
        countEvents(sub,0,"ATLLoc","1",proj)
        countEvents(sub,0,"MaskedMM", "2",proj)
        countEvents(sub,0,"Baleen","8",proj)
    #COVARIANCES
    ax_cov = sorted(glob(os.path.join(directory,"cov","*AXCPT*.cov")))
    do_ax = len(ax_fif) == len(ax_cov)
    gcov = os.path.join(directory,"ave_projon","{0}_AXCPT_All-cov.fif".format(sub))
    if do_ax:
        covariance(ax_fif,ax_cov,projection="on",lowpass=20,gcov=gcov)
    #cov all tar
    mask_cov = glob(os.path.join(directory,"cov","{0}_MaskedMMRun*.cov".format(sub)))
    bal_cov = glob(os.path.join(directory,"cov","{0}_BaleemRun*.cov".format(sub)))
    all_fif = mask_fif.extend(blp_fif).extend(bhp_fif)
    all_cov = mask_cov.extend(bal_cov)
    gcov = os.path.join(directory,"ave_projon","{0}_AllTar-cov.fif".format(sub))
    if len(all_fif) == len(all_cov):
        print("Processing covariance for all targets")
        covariance(all_fif,all_cov,projection="on",lowpass=20,gcov=gcov)
    #change group for all files
    os.system("chgrp -R lingua {0}".format(directory))
