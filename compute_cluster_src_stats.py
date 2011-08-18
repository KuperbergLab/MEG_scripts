import copy
import numpy as np
import scipy

import mne
from mne.stats import permutation_cluster_1samp_test

from scikits.learn.externals.joblib import Memory

###############################################################################
# Parameters

subjects = [1, 3, 4, 6, 9, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 30, 31, 32, 33]
#subjects = [6, 9, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 30, 31, 32, 33]


conds = [1, 2]  # 1 - 2
#conds = [1, 3] 


protocol = 'BaleenHP'
#protocol = 'BaleenLP'
#protocol = 'MaskedMM'


#time_interval = (0.35, 0.45)  #If you set a real time_interval, you will average across this and do spatial clusters
#dec = None


time_interval = None  #If you set time_interval to None, it will do spatiotemporal clusters
dec = 10  # this sets the temporal decimation factor. e.g. if you sampled 600Hz and set this to 3, you will downsample the test to every 5 ms


thresholds = [.1]  #This sets the threshold for the first stage of the test. You have the option of including more than one threshold to see what happens when it changes


def stat_fun(X):
    return np.mean(X, axis=0)  #This determines what function to use for the first stage of the test (e.g. mean, t-value)
stat_name = 'mean'

#def stat_fun(X):
#	return scipy.stats.ttest_1samp(X,0)[0]
#stat_name = 'ttest'


#n_permutations = 1000
n_permutations = 100 #This sets the number of permutations to run

###############################################################################
# Process


mem = Memory(cachedir=None)
#mem = Memory(cachedir='./scratch') #This caches stuff in the local directory scratch, so if you run it again it can be faster. if you don't want to do this just comment this line.
# mem = Memory(cachedir='my_joblib.cache', verbose=5)
# mem = Memory(cachedir='/space/megmix/1/users/gramfort', mmap_mode='r', verbose=5)
# mem = Memory(cachedir='/space/megmix/1/users/gramfort', verbose=5)

import multiprocessing
n_jobs = multiprocessing.cpu_count()
if n_jobs > 20:
    n_jobs = min(n_jobs, 10)
else:
    n_jobs = min(n_jobs, 5)

#inputs
prefix = "%s_c%d_c%d_" % (protocol, conds[0], conds[1])

stcs1_fname = ['/cluster/kuperberg/SemPrMM/MEG/data/ya%d/ave_projon/stc/ya%d_%s_All_c%dM-spm' % (s, s, protocol, conds[0]) for s in subjects]
stcs2_fname = ['/cluster/kuperberg/SemPrMM/MEG/data/ya%d/ave_projon/stc/ya%d_%s_All_c%dM-spm' % (s, s, protocol, conds[1]) for s in subjects]

#load the vertex configuration
ico_tris = mne.source_estimate._get_ico_tris(grade=5)
src = [dict(), dict()]
src[0]['use_tris'] = ico_tris
src[1]['use_tris'] = ico_tris


def load_data(stcs1_fname, stcs2_fname, dec):
    stcs1 = [mne.SourceEstimate(fname) for fname in stcs1_fname]
    stcs2 = [mne.SourceEstimate(fname) for fname in stcs2_fname]

	#This is just resampling in time, not space
    def resample_stc(stc, dec):
        """Resample stc inplace"""
        stc.data = stc.data[:,::dec].astype(np.float)
        stc.tstep *= dec
        stc.times = stc.times[::dec]
	
    if dec is not None:
        for stc in stcs1 + stcs2:
            resample_stc(stc, dec=dec)
            stc.crop(0.1, None)  #cropping the time-window for faster runtime

    def average_stcs(stcs):
        mean_stc = copy.deepcopy(stcs[0])
        times = mean_stc.times
        n_sources, n_times = mean_stc.data.shape
        X = np.empty((len(stcs), n_sources, n_times))
        for i, stc in enumerate(stcs):
            if len(times) == len(stc.times):
                X[i] = stc.data
        mean_stc.data = np.mean(X, axis=0)
        return mean_stc, X

	#X1, X2 are the full time,vertices,subject matrices; mean_stc1 and mean_stc2 are the grand-avgs
    mean_stc1, X1 = average_stcs(stcs1)
    mean_stc2, X2 = average_stcs(stcs2)
    return mean_stc1, X1, mean_stc2, X2

mean_stc1, X1, mean_stc2, X2 = mem.cache(load_data)(stcs1_fname, stcs2_fname, dec)

template_stc = copy.deepcopy(mean_stc1)

stc_diff = copy.deepcopy(template_stc)
stc_diff.data = mean_stc1.data - mean_stc2.data
stc_diff.save('/cluster/kuperberg/SemPrMM/MEG/results/source_space/cluster_stats/' + prefix + 'diff_of_means')

if time_interval is not None:  # squash time interval
    tmin, tmax = time_interval
    times = mean_stc1.times
    mask = (times >= tmin) & (times <= tmax)
    X1 = np.mean(X1[:, :, mask], axis=2)[:, :, None]
    X2 = np.mean(X2[:, :, mask], axis=2)[:, :, None]
    template_stc = copy.deepcopy(template_stc)
    template_stc.crop(tmin, tmin + template_stc.tstep)

assert X1.shape == X2.shape
n_samples, n_vertices, n_times = X1.shape

X1 = np.ascontiguousarray(np.swapaxes(X1, 1, 2).reshape(n_samples, -1))
X2 = np.ascontiguousarray(np.swapaxes(X2, 1, 2).reshape(n_samples, -1))

connectivity = mne.spatio_temporal_src_connectivity(src, n_times)

for t in thresholds:
    from time import time
    t0 = time()
    T_obs, clusters, cluster_pv, H0 = mem.cache(permutation_cluster_1samp_test,
                                                ignore=['n_jobs'])(X1 - X2,
                                                threshold=t,
                                                n_permutations=n_permutations,
                                                tail=0,
                                                stat_fun=stat_fun,
                                                connectivity=connectivity,
                                                n_jobs=n_jobs, seed=0)
    print "Time elapsed : %s (s)" % (time() - t0)

    clusters = [c.reshape(n_times, n_vertices).T for c in clusters]
	#you get a cluster for every single thing that crossed the first-stage threshold

    # stc_log_pv_cluster = copy.deepcopy(mean_stc1)
    # stc_log_pv_cluster.data = np.zeros_like(stc_log_pv_cluster.data)
    # for pv, c in zip(cluster_pv, clusters):
    #     stc_log_pv_cluster.data[c] = -np.log10(pv)
    # 
    # stc_log_pv_cluster.save(prefix + 'clusters_pv_%s_%s' % (stat_name, t))
    
    stc_cluster = copy.deepcopy(template_stc)
    #you only write out a cluster to an stc file if it crosses the second-stage threshold
    for k, c in enumerate(clusters):
        stc_cluster.data = c
        if cluster_pv[k] < 0.09:  ##This is the threshold for saving an stc file with cluster
            stc_cluster.save('/cluster/kuperberg/SemPrMM/MEG/results/source_space/cluster_stats/' + prefix + '%d-%d_cluster%d_%s_thresh_%s_pv_%.3f' \
                                        % (time_interval[0]*1000,time_interval[1]*1000,k, stat_name, t, cluster_pv[k]))

    print 'pv : %s' % np.sort(cluster_pv)[:5]
