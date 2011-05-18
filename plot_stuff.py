close('all')
f = figure(1,facecolor="w")
clf()

ydata_scale = 2e-5

ax = axes(frameon=False)
axhline(y=0,linewidth=2,color="black")
l1,l2 = plot(times,means0[0]*-1,"r",times,means1[0]*-1,"g")

xt = np.arange(0,times[lent-1]+.02,.1)
ymarks = np.ones(xt.shape[0])*ylim_data[0]*.1
xt2 = np.array([0])
ymarks2 = np.array([ydata_scale])
vlines(x=xt,ymin=ymarks*-1,ymax=ymarks)
vlines(x=xt2,ymin=np.array([0]),ymax=ymarks2,linewidth=2)

yt = ydata_scale
xmark = .005
hlines(yt,xmark*-1,xmark)
text(-.035,ydata_scale*.90,"text") 

ylim(-5e-05,5e-5)
xlim([0,times[lent-1]])
axis('off')
legend((l1,l2),(cond_names[0],cond_names[1]))

show()
