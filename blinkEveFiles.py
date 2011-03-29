###SemPrMM
###Adds blink events to eve files from .blinks files

import sys
from glob import glob
import os
import readInput
import writeOutput

def parse_ave(eve):
    """
    pass in an eve, get out a dict with keys being events and values being [tmin,tmax]
    """
    subj_folder = os.path.dirname(os.path.dirname(eve))
    ave = os.path.join(subj_folder,'ave',eve.rpartition('/')[2].rpartition('Mod')[0]+'.ave')
    try:
        with open(ave,'r') as f:
            ave_lines = f.readlines()
    except:
        print("Error in parse_ave")
        exit()
    cat_ind = [i for i,x in enumerate(ave_lines) if "category {" in x]
    event_dict = dict()
    for ind in cat_ind:
        event = ave_lines[ind+2].split()[1]
        tmin = ave_lines[ind+3].split()[1]
        tmax = ave_lines[ind+4].split()[1]
        event_dict[event] = [float(tmin),float(tmax)]
    return event_dict
    
def blinkEveFiles(subjID,preBlinkTime,postBlinkTime,DEBUG=False):
    if not isinstance(preBlinkTime,float):
        preBlinkTime = float(preBlinkTime)
    if not isinstance(postBlinkTime,float):
        postBlinkTime = float(postBlinkTime)
    filePrefix = os.path.join('/cluster/kuperberg/SemPrMM/MEG/data',subjID)
    eves = glob(os.path.join(filePrefix,'eve',subjID+'*Mod.eve'))
    eves = filter(lambda x:(x.find('blink') == -1),eves)
    #eves = filter(lambda x:(x.find('AXCPT') == -1),eves)
    eves.sort()
    blinks = glob(os.path.join(filePrefix,subjID+'*.blinks'))
    #blinks = filter(lambda x:(x.find('AXCPT') == -1),blinks)
    blinks.sort()
    if len(eves) == len(blinks):
        for eve,blink in zip(eves,blinks):
            new_eve = os.path.join(filePrefix,'eve',
                eve.rpartition('/')[2].rpartition('.')[0]+'blink.eve')
            eve_data = readInput.readTable(eve)
            blink_data = readInput.readList(blink)
            blink_data[:] = [int(x) for x in blink_data]
            SR = sum([float(x[0])/float(x[1]) for x in eve_data]) / len(eve_data)
            pre_index = int(SR * preBlinkTime) # will be negative
            post_index = int(SR * postBlinkTime)
            blinks_replaced = 0
            ave_dict = parse_ave(eve)
            for i,event in enumerate(eve_data):
                sample = int(event[0])
                code = event[3]
                if code in ave_dict:
                    eve_min = int(sample+ave_dict[code][0]*SR) #low sample for event
                    eve_max = int(sample+ave_dict[code][1]*SR) #high sample for event
                    low = int(preBlinkTime*SR) #lower(earlier in time) offset for blink
                    up = int(postBlinkTime*SR) #high (later in time) offset for blink
                    # enter crazy logic!!!!
                    # the "windows" overlap iff 
                    #(blink+upper > event(lower) and blink+lower < event(lower) 
                        #(ie blink was in the beginning of event) or 
                    #(blink+lower > event(lower) and blink+upper < event(higher)
                        #(ie blink was right in the middle of event) or 
                    #(blink+lower < event(higher) and blink+upper > blink(higher))
                        #(ie blink was towards end of event)
                    overlap = [x for x in blink_data if ( (x+up > eve_min and x+low < eve_min) or ( x+low > eve_min and x+up < eve_max) or (x+up > eve_max and x+low < eve_max) )]
                    if len(overlap) > 0:
                        eve_data[i] = [event[0],event[1],event[2],'200']
                        blinks_replaced += 1
            writeOutput.writeTable(new_eve,eve_data)
            print('{0} + {1} = {2}, # blinks = {3}'.format(os.path.basename(eve),
                                        os.path.basename(blink),
                                        os.path.basename(new_eve),
                                        blinks_replaced))
            if DEBUG:
                print [(float(blink)-float(eve_data[0][0]))/600 for blink in blink_data]
    else:
        print('unequal amount of .eve and .blinks')
    
if __name__ == "__main__":
    subjID = sys.argv[1]
    preBlinkTime = float(sys.argv[2])
    postBlinkTime = float(sys.argv[3])
    blinkEveFiles(subjID,preBlinkTime,postBlinkTime)