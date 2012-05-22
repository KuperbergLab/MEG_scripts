###################################################################################################
#!/usr/bin/env python
"""Compute SSP/PCA projections for ECG artifacts
You can do for example:

$mne_proj_ecg.py -i sample_audvis_raw.fif -c "MEG 1531" --l-freq 1 --h-freq 100 --rej-grad 3000 --rej-mag 4000 --rej-eeg 100
"""

# Author: Alexandre Gramfort, Ph.D. Source: mne_compute_proj_ecg.py
# Modified by CandidaUstine

import os
import sys
sys.path.insert(0,'/cluster/kuperberg/SemPrMM/MEG/mne-python/')
import mne
from mne import fiff
from pipeline import make_lingua
        
###############################################################################################################################################################################################
def compute_proj_ecg(in_path, in_fif_fname, tmin, tmax, n_grad, n_mag, n_eeg, l_freq, h_freq, average, filter_length, n_jobs, ch_name, reject, avg_ref, bads):

    """Compute SSP/PCA projections for ECG/EOG artifacts

    Parameters
    ----------
    in_fif_fname: string
        Raw fif File
    XXX
    """

    in_fif_fname = in_path + in_fif_fname
    
    print 'Reading fif File'
    raw = mne.fiff.Raw(in_fif_fname) #, preload=preload)
    if in_fif_fname.endswith('_raw.fif') or in_fif_fname.endswith('-raw.fif'):
        prefix = in_fif_fname[:-8]
    else:
        prefix = in_fif_fname[:-4]
    ecg_event_fname = prefix + '_ecg-eve.fif'

    print 'Running ECG SSP computation'

    ecg_events, _, _ = mne.artifacts.find_ecg_events(raw, ch_name=ch_name)
    print "Writing ECG events in %s" % ecg_event_fname
    mne.write_events(ecg_event_fname, ecg_events)
    make_lingua(ecg_event_fname)
    
    if avg_ref:
        print "Adding average EEG reference projection."
        eeg_proj = mne.fiff.proj.make_eeg_average_ref_proj(raw.info)
        raw.info['projs'].append(eeg_proj)

##    if average:
##         ecg_proj_fname = prefix + '_ecg_avg_proj.fif'
##         out_fif_fname = prefix + '_ecg_avg_proj_raw.fif'
##
##    else:
    ecg_proj_fname = prefix + '_ecg_proj.fif'
    out_fif_fname = prefix + '_ecg_proj_raw.fif'


    print 'Computing ECG projector'

    # Handler rejection parameters
    if len(mne.fiff.pick_types(raw.info, meg='grad', eeg=False, eog=False)) == 0:
        del reject['grad']
    if len(mne.fiff.pick_types(raw.info, meg='mag', eeg=False, eog=False)) == 0:
        del reject['mag']
    if len(mne.fiff.pick_types(raw.info, meg=False, eeg=True, eog=False)) == 0:
        del reject['eeg']
    if len(mne.fiff.pick_types(raw.info, meg=False, eeg=False, eog=True)) == 0:
        del reject['eog']

    picks = mne.fiff.pick_types(raw.info, meg=True, eeg=True, eog=True,
                                exclude=raw.info['bads'] + bads)
    if l_freq is None and h_freq is not None:
        raw.high_pass_filter(picks, h_freq, filter_length, n_jobs)
    if l_freq is not None and h_freq is None:
        raw.low_pass_filter(picks, h_freq, filter_length, n_jobs)
    if l_freq is not None and h_freq is not None:
        raw.band_pass_filter(picks, l_freq, h_freq, filter_length, n_jobs)

    epochs_ecg = mne.Epochs(raw, ecg_events, None, tmin, tmax, baseline=None,
                        picks=picks, reject=reject, proj=True)

    projs_init = raw.info['projs'] 

    if average:
        evoked_ecg = epochs_ecg.average()
        projs_ecg = mne.compute_proj_evoked(evoked_ecg, n_grad=n_grad, n_mag=n_mag,
                                        n_eeg=n_eeg)
    else:
        projs_ecg = mne.compute_proj_epochs(epochs_ecg, n_grad=n_grad, n_mag=n_mag,
                                        n_eeg=n_eeg)
    

    print "Writing ECG projections in %s" % ecg_proj_fname
    mne.write_proj(ecg_proj_fname, projs_ecg + projs_init) ## Original Projections written along with the ecg projections. 

    print "Writing ECG projections in %s" % ecg_proj_fname
    mne.write_proj(ecg_proj_fname, projs_ecg)

    return in_fif_fname, ecg_proj_fname, out_fif_fname
########################################################################################################################################################################
def compute_proj_eog(in_path, in_fif_fname, tmin, tmax, n_grad, n_mag, n_eeg, l_freq, h_freq, average, filter_length, n_jobs, ch_name, reject, avg_ref, bads):

    in_fif_fname = in_path + in_fif_fname
    raw = mne.fiff.Raw(in_fif_fname) #, preload=preload)
    
    if in_fif_fname.endswith('_raw.fif') or in_fif_fname.endswith('-raw.fif'):
        prefix = in_fif_fname[:-8]
    else:
        prefix = in_fif_fname[:-4]

    eog_event_fname = prefix + '_eog-eve.fif'
    make_lingua(eog_event_fname)

##    if average:
##        eog_proj_fname = prefix + '_eog_avg_proj.fif'
##        out_fif_fname = prefix + '_eog_avg_proj_raw.fif'
##
##    else:
    eog_proj_fname = prefix + '_eog_proj.fif'
    out_fif_fname = prefix + '_eog_proj_raw.fif'


    print 'Running EOG SSP computation'

    eog_events, _= mne.artifacts.find_eog_events(raw)  # since our copy of the mne.artifacts.events.py script returns two parameters. 
    print "Writing EOG events in %s" % eog_event_fname
    mne.write_events(eog_event_fname, eog_events)

    print 'Computing EOG projector'

    # Handler rejection parameters
    if len(mne.fiff.pick_types(raw.info, meg='grad', eeg=False, ecg=False)) == 0:
        del reject['grad']
    if len(mne.fiff.pick_types(raw.info, meg='mag', eeg=False, ecg=False)) == 0:
        del reject['mag']
    if len(mne.fiff.pick_types(raw.info, meg=False, eeg=True, ecg=False)) == 0:
        del reject['eeg']
    if len(mne.fiff.pick_types(raw.info, meg=False, eeg=False, ecg=True)) == 0:
        del reject['ecg']

    picks_eog = mne.fiff.pick_types(raw.info, meg=True, eeg=True, ecg=True,
                                exclude=raw.info['bads'] + bads)
    if l_freq is None and h_freq is not None:
        raw.high_pass_filter(picks, h_freq, filter_length, n_jobs)
    if l_freq is not None and h_freq is None:
        raw.low_pass_filter(picks, h_freq, filter_length, n_jobs)
    if l_freq is not None and h_freq is not None:
        raw.band_pass_filter(picks, l_freq, h_freq, filter_length, n_jobs)

    epochs_eog = mne.Epochs(raw, eog_events, None, tmin, tmax, baseline=None,
                        picks=picks_eog, reject=reject, proj=True)

    projs_init = raw.info['projs']

    if average:
        evoked_eog = epochs_eog.average()
        projs_eog = mne.compute_proj_evoked(evoked_eog, n_grad=n_grad, n_mag=n_mag,
                                        n_eeg=n_eeg)
    else:
        projs_eog = mne.compute_proj_epochs(epochs, n_grad=n_grad, n_mag=n_mag,
                                        n_eeg=n_eeg)


    print "Writing EOG projections in %s" % eog_proj_fname
    mne.write_proj(eog_proj_fname, projs_eog)
    
    return in_fif_fname, eog_proj_fname, out_fif_fname

########################################################################################################################################################
def compute_proj_ecgeog(in_path, in_fif_fname):

    in_fif_fname = in_path + in_fif_fname
    raw = mne.fiff.Raw(in_fif_fname) #, preload=preload)
    
    if in_fif_fname.endswith('_raw.fif') or in_fif_fname.endswith('-raw.fif'):
        prefix = in_fif_fname[:-8]
    else:
        prefix = in_fif_fname[:-4]

##    if average:
##        ecg_proj_fname = prefix + '_ecg_avg_proj.fif'
##        eog_proj_fname = prefix + '_eog_avg_proj.fif'
##        out_fif_fname = prefix + '_ecgeog_avg_proj_raw.fif'
##
##    else:
    ecg_proj_fname = prefix + '_ecg_proj.fif'
    eog_proj_fname = prefix + '_eog_proj.fif'
    out_fif_fname = prefix + '_ecgeog_proj_raw.fif'
        
    print 'Applying ECG and EOG projector'
    command = ('mne_process_raw --cd %s --raw %s --proj %s --proj %s --proj %s '
                   '--projoff --save %s --filteroff'
               % (in_path, in_fif_fname, eog_proj_fname, ecg_proj_fname, in_fif_fname,
               out_fif_fname))

    make_lingua(out_fif_fname)
    
    print 'Command executed: %s' % command
    print 'Running : %s' % command	
    st = os.system(command)
    if st != 0:
          raise ValueError('Problem while running : %s' % command)
    else:
        print 'Done'
        print ('Computed ECG EOG Rejection fif file. Saved result as %s' % out_fif_fname) 
    
###################################################################################################    

if __name__ == '__main__':
    import sys
    sys.path.insert(0,'/cluster/kuperberg/SemPrMM/MEG/mne-python/')
    import mne
    from mne import fiff

    from optparse import OptionParser

    parser = OptionParser()
    parser.add_option("--in_path", dest="in_path",
                    help="Raw file path name",
                    default=None)
    parser.add_option("-i", "--in", dest="raw_in",
                    help="Input raw FIF file", metavar="FILE")
    parser.add_option("-o", "--out", dest="raw_out",
                    help="Output FIF file", metavar="FILE",
                    default=None)
    parser.add_option("--tmin", dest="tmin",
                    help="time before event in seconds",
                    default=-0.2)
    parser.add_option("--tmax", dest="tmax",
                    help="time before event in seconds",
                    default=0.4)
    parser.add_option("-g", "--n-grad", dest="n_grad",
                    help="Number of SSP vectors for gradiometers",
                    default=1)
    parser.add_option("-m", "--n-mag", dest="n_mag",
                    help="Number of SSP vectors for magnetometers",
                    default=1)
    parser.add_option("-e", "--n-eeg", dest="n_eeg",
                    help="Number of SSP vectors for EEG",
                    default=1)
    parser.add_option("--l-freq", dest="l_freq",
                    help="Filter low cut-off frequency in Hz",
                    default=None)  # XXX
    parser.add_option("--h-freq", dest="h_freq",
                    help="Filter high cut-off frequency in Hz",
                    default=None)  # XXX
 #   parser.add_option("-p", "--preload", dest="preload",
 #                   help="Temporary file used during computaion",
 #                    default='tmp.mmap')
    parser.add_option("-a", "--average", dest="average", action="store_true",
                    help="Compute SSP after averaging",
                    default=False)
    parser.add_option("--filtersize", dest="filter_length",
                    help="Number of SSP vectors for EEG",
                    default=2048)
    parser.add_option("-j", "--n-jobs", dest="n_jobs",
                    help="Number of jobs to run in parallel",
                    default=1)
    parser.add_option("-c", "--channel", dest="ch_name",
                    help="Channel to use for ECG detection (Required if no ECG found)",
                    default=None)
    parser.add_option("--rej-grad", dest="rej_grad",
                    help="Gradiometers rejection parameter in fT/cm (peak to peak amplitude)",
                    default=2000)
    parser.add_option("--rej-mag", dest="rej_mag",
                    help="Magnetometers rejection parameter in fT (peak to peak amplitude)",
                    default=3000)
    parser.add_option("--rej-eeg", dest="rej_eeg",
                    help="EEG rejection parameter in uV (peak to peak amplitude)",
                    default=50)
    parser.add_option("--rej-eog", dest="rej_eog",
                    help="EOG rejection parameter in uV (peak to peak amplitude)",
                    default=250)
    parser.add_option("--avg-ref", dest="avg_ref", action="store_true",
                    help="Add EEG average reference proj",
                    default=False)
    parser.add_option("--bad", dest="bad_fname",
                    help="Text file containing bad channels list (one per line)",
                    default=None)
    parser.add_option("--tag", dest="tag",
                    help="Tag that defines whether to run ecg or eog projection. Can take ecg or eog or ecgeog",
                    default=None)

    options, args = parser.parse_args()

    raw_in = options.raw_in
    raw_out = options.raw_out

    if raw_in is None:
        parser.print_help()
        sys.exit(-1)
     
    in_path = options.in_path
    tmin = options.tmin
    tmax = options.tmax
    n_grad = options.n_grad
    n_mag = options.n_mag
    n_eeg = options.n_eeg
    l_freq = options.l_freq
    h_freq = options.h_freq
    average = options.average # Using the average of all the ecg/eog events to compute the corresponding projector. 
 #   preload = options.preload
    filter_length = options.filter_length
    n_jobs = options.n_jobs
    ch_name = options.ch_name
    tag = options.tag
    reject = dict(grad=1e-13 * float(options.rej_grad),
                  mag=1e-15 * float(options.rej_mag),
                  eeg=1e-6 * float(options.rej_eeg))
                  ##eog=1e-6 * float(options.rej_eog))
    avg_ref = options.avg_ref
    bad_fname = options.bad_fname

    bad_fname = in_path + bad_fname 
    print bad_fname
    if bad_fname is not None:
        bads = [w.rstrip().split() for w in open(bad_fname).readlines()]
        print 'Bad channels read : %s' % bads
    else:
        bads = []
    
    if tag == 'ecg':
                in_fif_fname, ecg_proj_fname, out_fif_fname = compute_proj_ecg(in_path, raw_in, tmin, tmax, n_grad, n_mag, n_eeg, l_freq, h_freq,
                             average, filter_length, n_jobs, ch_name, reject,
                             avg_ref, bads)
                make_lingua(in_fif_fname)
                make_lingua(ecg_proj_fname)
                make_lingua(out_fif_fname)
                print 'Applying ECG projector'
                command = ('mne_process_raw --cd %s --raw %s --proj %s --proj %s '
                       '--projoff --save %s --filteroff'
                           % (in_path, in_fif_fname, ecg_proj_fname, in_fif_fname,
                           out_fif_fname))
                st = os.system(command)
                if st != 0:
                     raise ValueError('Problem while running : %s' % command)
                else:
                     print 'Command executed: %s' % command
                     print 'Done'
                     print ('Computed EOG Rejection fif file. Saved result as %s' % out_fif_fname)
           
    elif tag =='eog':
                in_fif_fname, eog_proj_fname, out_fif_fname = compute_proj_eog(in_path, raw_in, tmin, tmax, n_grad, n_mag, n_eeg, l_freq, h_freq,
                             average, filter_length, n_jobs, ch_name, reject,
                             avg_ref, bads)
                make_lingua(in_fif_fname)
                make_lingua(ecg_proj_fname)
                make_lingua(out_fif_fname)
                print 'Applying EOG projector'
                command = ('mne_process_raw --cd %s --raw %s --proj %s --proj %s '
                       '--projoff --save %s --filteroff'
                           % (in_path, in_fif_fname, eog_proj_fname, in_fif_fname,
                           out_fif_fname))
                st = os.system(command)
                if st != 0:
                     raise ValueError('Problem while running : %s' % command)
                else:
                     print 'Command executed: %s' % command
                     print 'Done'
                     print ('Computed EOG Rejection fif file. Saved result as %s' % out_fif_fname)

    elif tag == 'ecgeog':
        compute_proj_ecg(in_path, raw_in, tmin, tmax, n_grad, n_mag, n_eeg, l_freq, h_freq,
                     average, filter_length, n_jobs, ch_name, reject,
                     avg_ref, bads)
        compute_proj_eog(in_path, raw_in, tmin, tmax, n_grad, n_mag, n_eeg, l_freq, h_freq,
                     average, filter_length, n_jobs, ch_name, reject,
                     avg_ref, bads)
        compute_proj_ecgeog(in_path, raw_in)      

       
    elif tag == 'None': 
        print 'Specify the Artifact projection required - ecg, eog or ecgeog.'
