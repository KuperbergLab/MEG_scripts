import os
import numpy as np
import pylab as pl

from mne import fiff
from mne.stats import permutation_1d_cluster_test
from mne.layouts import Layout


from joblib import Memory

#cache directory
mem = Memory(cachedir="/home/scratch/")


type = "EEG" #EEG or MEG
plot_type = "data" #data or f
par = "BaleenHP_All"
use_joblib = True
cond = 0 #index to the dictionary
do_plot = True

#Baleen(HP or LP)_All - 0,1 is direct/unrelated 2,3 is filler direct/unrelated
#MaskedMM_All 0,2 is direct/unrelated
#AXCPT_All 0,2 is AY/BY and 1,2 is BX/BY
con_dict = dict({"BaleenHP_All":[[(0,1),("Rel","Unrel")],[(2,3),("RelFill","UnrelFill")]],
				"MaskedMM_All":[[(0,2),("Rel","Unrel")]],
				"BaleenLP_All":[[(0,1),("Rel","Unrel")]],
				"AXCPT_All":[[(0,2),("AY","BY")],[(4,5),("A","B")]]})
				
conditions = con_dict[par][cond][0]
cond_names = con_dict[par][cond][1]

title = '{0}: {1} - {2}'.format(par,cond_names[0],cond_names[1])
suffix = '%s-%s' % cond_names
subj_dict = dict({"BaleenLP_All":[1, 3, 4, 5, 6, 9, 12, 13, 15, 16, 17, 19, 18,21],
	"BaleenHP_All":[1, 3, 4, 5, 6, 9, 12, 13, 15, 16, 17, 19, 18,21],
	"MaskedMM_All": [5, 6, 9, 12, 13, 15, 16, 17, 19, 18, 21],
	"AXCPT_All": [3, 6, 5, 9, 12, 13, 15, 17, 18, 19 ,21]})
subjects = subj_dict[par]

ch_idx = range(306)

# list EEG channels
eeg_names = ['FP1', 'FPZ', 'FP2', 'AF7', 'AF3', 'AFZ', 'AF4', 'AF8', 'F7', 'F5', 'F3', 'F1', 'FZ',
'F2', 'F4', 'F6', 'F8', 'FT9', 'FT7', 'FC5', 'FC3', 'FC1', 'FCZ', 'FC2', 'FC4', 'FC6', 'FT8', 'FT10', 'T9',
'T7', 'C5', 'C3', 'C1', 'CZ', 'C2', 'C4', 'C6', 'T8', 'T10', 'TP9', 'TP7', 'CP5', 'CP3', 'CP1', 'CPZ', 'CP2',
'CP4', 'CP6', 'TP8', 'TP10', 'P9', 'P7', 'P5', 'P3', 'P1', 'PZ', 'P2', 'P4', 'P6', 'P8', 'P10', 'PO7', 'PO3', 'POZ', 'PO4', 'PO8', 'O1', 'OZ', 'O2', 'IZ']

# list MEG channels
meg_names = ['MEG 0113','MEG 0112','MEG 0111','MEG 0122','MEG 0123','MEG 0121','MEG 0132',
'MEG 0133','MEG 0131','MEG 0143','MEG 0142','MEG 0141','MEG 0213','MEG 0212','MEG 0211','MEG 0222',
'MEG 0223','MEG 0221','MEG 0232','MEG 0233','MEG 0231','MEG 0243','MEG 0242','MEG 0241','MEG 0313',
'MEG 0312','MEG 0311','MEG 0322','MEG 0323','MEG 0321','MEG 0333','MEG 0332','MEG 0331','MEG 0343',
'MEG 0342','MEG 0341','MEG 0413','MEG 0412','MEG 0411','MEG 0422','MEG 0423','MEG 0421','MEG 0432',
'MEG 0433','MEG 0431','MEG 0443','MEG 0442','MEG 0441','MEG 0513','MEG 0512','MEG 0511','MEG 0523',
'MEG 0522','MEG 0521','MEG 0532','MEG 0533','MEG 0531','MEG 0542','MEG 0543','MEG 0541','MEG 0613',
'MEG 0612','MEG 0611','MEG 0622','MEG 0623','MEG 0621','MEG 0633','MEG 0632','MEG 0631','MEG 0642',
'MEG 0643','MEG 0641','MEG 0713','MEG 0712','MEG 0711','MEG 0723','MEG 0722','MEG 0721','MEG 0733',
'MEG 0732','MEG 0731','MEG 0743','MEG 0742','MEG 0741','MEG 0813','MEG 0812','MEG 0811','MEG 0822',
'MEG 0823','MEG 0821','MEG 0913','MEG 0912','MEG 0911','MEG 0923','MEG 0922','MEG 0921','MEG 0932',
'MEG 0933','MEG 0931','MEG 0942','MEG 0943','MEG 0941','MEG 1013','MEG 1012','MEG 1011','MEG 1023',
'MEG 1022','MEG 1021','MEG 1032','MEG 1033','MEG 1031','MEG 1043','MEG 1042','MEG 1041','MEG 1112',
'MEG 1113','MEG 1111','MEG 1123','MEG 1122','MEG 1121','MEG 1133','MEG 1132','MEG 1131','MEG 1142',
'MEG 1143','MEG 1141','MEG 1213','MEG 1212','MEG 1211','MEG 1223','MEG 1222','MEG 1221','MEG 1232',
'MEG 1233','MEG 1231','MEG 1243','MEG 1242','MEG 1241','MEG 1312','MEG 1313','MEG 1311','MEG 1323',
'MEG 1322','MEG 1321','MEG 1333','MEG 1332','MEG 1331','MEG 1342','MEG 1343','MEG 1341','MEG 1412',
'MEG 1413','MEG 1411','MEG 1423','MEG 1422','MEG 1421','MEG 1433','MEG 1432','MEG 1431','MEG 1442',
'MEG 1443','MEG 1441','MEG 1512','MEG 1513','MEG 1511','MEG 1522','MEG 1523','MEG 1521','MEG 1533',
'MEG 1532','MEG 1531','MEG 1543','MEG 1542','MEG 1541','MEG 1613','MEG 1612','MEG 1611','MEG 1622',
'MEG 1623','MEG 1621','MEG 1632','MEG 1633','MEG 1631','MEG 1643','MEG 1642','MEG 1641','MEG 1713',
'MEG 1712','MEG 1711','MEG 1722','MEG 1723','MEG 1721','MEG 1732','MEG 1733','MEG 1731','MEG 1743',
'MEG 1742','MEG 1741','MEG 1813','MEG 1812','MEG 1811','MEG 1822','MEG 1823','MEG 1821','MEG 1832',
'MEG 1833','MEG 1831','MEG 1843','MEG 1842','MEG 1841','MEG 1912','MEG 1913','MEG 1911','MEG 1923',
'MEG 1922','MEG 1921','MEG 1932','MEG 1933','MEG 1931','MEG 1943','MEG 1942','MEG 1941','MEG 2013',
'MEG 2012','MEG 2011','MEG 2023','MEG 2022','MEG 2021','MEG 2032','MEG 2033','MEG 2031','MEG 2042',
'MEG 2043','MEG 2041','MEG 2113','MEG 2112','MEG 2111','MEG 2122','MEG 2123','MEG 2121','MEG 2133',
'MEG 2132','MEG 2131','MEG 2143','MEG 2142','MEG 2141','MEG 2212','MEG 2213','MEG 2211','MEG 2223',
'MEG 2222','MEG 2221','MEG 2233','MEG 2232','MEG 2231','MEG 2242','MEG 2243','MEG 2241','MEG 2312',
'MEG 2313','MEG 2311','MEG 2323','MEG 2322','MEG 2321','MEG 2332','MEG 2333','MEG 2331','MEG 2343',
'MEG 2342','MEG 2341','MEG 2412','MEG 2413','MEG 2411','MEG 2423','MEG 2422','MEG 2421','MEG 2433',
'MEG 2432','MEG 2431','MEG 2442','MEG 2443','MEG 2441','MEG 2512','MEG 2513','MEG 2511','MEG 2522',
'MEG 2523','MEG 2521','MEG 2533','MEG 2532','MEG 2531','MEG 2543','MEG 2542','MEG 2541','MEG 2612',
'MEG 2613','MEG 2611','MEG 2623','MEG 2622','MEG 2621','MEG 2633','MEG 2632','MEG 2631','MEG 2642',
'MEG 2643','MEG 2641']




def extract_data(s, setno, ch_names):
	data = fiff.read_evoked(s,setno=setno,baseline=(None, 0))
	sel = [data['info']['ch_names'].index(c) for c in ch_names]
	times = data['evoked']['times']
	mask = times > 0
	print "-------------- " + str(data['info']['bads'])
	epochs = data['evoked']['epochs'][sel][:, mask]
	bads = [k for k, _ in enumerate(sel) if ch_names[k] in data['info']['bads']]
	bads_name = [ch_names[k] for k, _ in enumerate(sel) if ch_names[k] in data['info']['bads']]
	return epochs, times[mask], bads, bads_name

if type == "MEG":
	chans_to_proc = meg_names
	img_dir = "img_meg"
	layout = Layout()
elif type == "EEG":
	chans_to_proc = eeg_names
	img_dir = "img_eeg"
	layout = Layout("sample-EEG",path="/cluster/kuperberg/SemPrMM/MEG/scripts/")
img_dir = "cluster_results/"+"{0}_{1}".format(par,type)
layout.pos[:,2:] *= 0.85



n_subjects = len(subjects)
n_sensors = len(chans_to_proc)
X0a = []
X1a = []
bads = []
bads_name = []
for s in subjects:
	fif = '/cluster/kuperberg/SemPrMM/MEG/data/ya{0}/ave_projoff/ya{0}_{1}-ave.fif'.format(s,par)
	if use_joblib:
		x0, times, bads_s, bads_name_s = mem.cache(extract_data)(fif, conditions[0], chans_to_proc)
		x1, times, bads_s, bads_name_s = mem.cache(extract_data)(fif, conditions[1], chans_to_proc)
	else:
		x0, times, bads_s, bads_name_s = extract_data(fif, conditions[0], chans_to_proc)
		x1, times, bads_s, bads_name_s = extract_data(fif, conditions[1], chans_to_proc)
	X0a.append(x0)
	X1a.append(x1)
	bads.append(bads_s)
	bads_name.append(bads_name_s)

X0 = np.array(X0a)
X1 = np.array(X1a)

n_times = len(times)
n_channels = X0.shape[1]

# compute the good subjects for each channel
chan_to_subj = []
for c, name in enumerate(chans_to_proc):
	chan_to_subj.append([s for s, _ in enumerate(subjects) if not c in bads[s]])


# if 0:
#	 X0_flat = X0.reshape(X0.shape[0], -1)
#	 X1_flat = X1.reshape(X1.shape[0], -1)
#	 threshold = 6.0
#	 T_obs, clusters, cluster_p_values, H0 = \
#					 permutation_1d_cluster_test([X0_flat, X1_flat],
#								 n_permutations=1000, threshold=threshold, tail=1)
#	 T_obs = T_obs.reshape(n_channels, n_times)
# else:

threshold = 5.0
T_obs = []
clusters = []
cluster_p_values = []
good0 = []
good1 = []
for c in range(n_channels):
	print 'processing channel %d / %d ' % (c+1, n_channels)
	condition0 = np.squeeze(X0[chan_to_subj[c],c,:])
	good0.append(condition0)
	condition1 = np.squeeze(X1[chan_to_subj[c],c,:])
	good1.append(condition1)
	if use_joblib:
		T_obs_c, clusters_c, cluster_p_values_c, H0 = mem.cache(permutation_1d_cluster_test)\
							([condition0, condition1],n_permutations=1000, threshold=threshold, tail=1)
	else:
		T_obs_c, clusters_c, cluster_p_values_c, H0 = permutation_1d_cluster_test\
							([condition0, condition1],n_permutations=1000, threshold=threshold, tail=1)
	T_obs.append(T_obs_c)
	clusters += [(start + c*n_times, stop + c*n_times) for start, stop in
				clusters_c]
	cluster_p_values += list(cluster_p_values_c)
T_obs = np.array(T_obs)


###############################################################################
# Plot
if type == "EEG":
	ydata_scale = 5e-6
	ydata_scale_txt = "5"+u"\u00B5"+"V"
else:
	ydata_scale = 50e-15
	ydata_scale_txt = "50 fT / m"
yLim = [0, 1.1 * T_obs.max()]
means0 = [np.mean(x,axis=0) for x in good0]
means1 = [np.mean(x,axis=0) for x in good1]
ylim_data = [ydata_scale * -2,ydata_scale*2]
lent = means0[0].shape[0]
xt = np.arange(0,times[lent-1]+.02,.1) #xtick mark locations
ymarks = np.ones(xt.shape[0])*ydata_scale*.25 #xtick mark lengths
xt2 = np.array([0])	#yaxis scale location (t=0)
ymarks2 = np.array([ydata_scale]) #yaxis scale
xmark = .005 #length of ytick mark


if not os.path.exists(img_dir):
	os.mkdir(img_dir)

def plot_channel(ax, c, clusters, cluster_p_values,plot_type,full=False):
	for i_c, (start, stop) in enumerate(clusters):
		if start / n_times == c:
			start -= c*n_times
			stop -= c*n_times
			if cluster_p_values[i_c] <= 0.05:
				h = ax.axvspan(times[start], times[stop-1], color='r', alpha=0.3)
			else:
				ax.axvspan(times[start], times[stop-1], color=(0.3, 0.3, 0.3),
						   alpha=0.3)
	pl.axhline(y=0,linewidth=1,color="black")	
	if plot_type == "data":
		hf = ax.plot(times, -1*means0[c],"r",times,-1*means1[c],"g")
		if not full:		
			pl.text(-0.035,ydata_scale*.9,ydata_scale_txt)
			pl.legend(hf,(cond_names[0],cond_names[1]),loc="upper right")
	elif plot_type == "f":
		hf = ax.plot(times, T_obs[c], 'g')
	pl.vlines(x=xt,ymin=ymarks*-1,ymax=ymarks)
	pl.vlines(x=xt2,ymin=np.array([0]),ymax=ymarks2,linewidth=1)
	pl.hlines(ydata_scale,xmark*-1,xmark)
	pl.xlim([0,times[lent-1]])
	return hf


pl.figure(-conditions[1], facecolor='w')
pl.clf()
if do_plot:
	for c in range(n_channels):
		for name in layout.names:
			if name == chans_to_proc[c]:
				idx = chans_to_proc.index(name)
				pl.figure(-conditions[1], facecolor='w')
				ax = pl.axes(layout.pos[idx],frameon=False)
				hf = plot_channel(ax, c, clusters, cluster_p_values,plot_type,True)
				pl.axis('off')
				if plot_type == "data":
					pl.ylim(ylim_data)
				else:
					pl.ylim(yLim)
				if type == "EEG":
					fs = 8
				elif type == "MEG":
					fs = 2
				ax.text(0.1, 0.85, chans_to_proc[c],fontsize=fs,
						horizontalalignment='left',verticalalignment='top',
						transform = ax.transAxes)
				#this plots f for each channel
				pl.figure(idx, facecolor='w')
				pl.clf()
				ax1 = pl.axes(frameon=False)
				hf = plot_channel(pl, c, clusters, cluster_p_values,plot_type)
				pl.axis('off')
				if plot_type == "data":
					pl.ylim(ylim_data)
				else:
					pl.ylim(yLim)
				pl.title('Channel : ' + chans_to_proc[c] + " (%d subjects)" % len(chan_to_subj[c]))
				fo = '%s/%s_%s_%s.png' % (img_dir,chans_to_proc[c].replace(" ","_"), suffix,plot_type)
				#print("Saved %s" % fo)
				pl.savefig(fo,dpi=150)
	pl.figure(-conditions[1], facecolor='w')
	pl.figtext(0.03, 0.93, title, fontsize=18)
	pl.legend(hf,(cond_names[0],cond_names[1]),loc=(4,14.5))
	fo = '%s/full_%s_%s.png' % (img_dir,suffix,plot_type)
	pl.savefig(fo,dpi=150)
	print("Saved %s" % fo)
	#pl.show()
