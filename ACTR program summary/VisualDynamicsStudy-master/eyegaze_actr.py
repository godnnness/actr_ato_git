"""
A model for extended visual interface: multiple objects at the same time, vision checks them all and stores them.
"""

import string
import random
import warnings
import math

from io import StringIO
import pyactr as actr
import numpy as np

import sys 
from tqdm import tqdm

class Model(object):
    """
    Model searching and attending to various stimuli.
    """

    def __init__(self, env, **kwargs):
        self.m = actr.ACTRModel(environment=env, **kwargs)

        actr.chunktype("pair", "probe answer")
        
        actr.chunktype("goal", "state")

        self.dm = self.m.decmem

        self.m.visualBuffer("visual", "visual_location", self.dm, finst=30)

        start = actr.makechunk(nameofchunk="start", typename="chunk", value="start")
        actr.makechunk(nameofchunk="attending", typename="chunk", value="attending")
        actr.makechunk(nameofchunk="done", typename="chunk", value="done")
        self.m.goal.add(actr.makechunk(typename="read", state=start))
        self.m.set_goal("g2")
        self.m.goals["g2"].delay=0.2

        self.m.productionstring(name="find_probe", string="""
        =g>
        isa     goal
        state   start
        ?visual_location>
        buffer  empty
        ==>
        =g>
        isa     goal
        state   attend
        ?visual_location>
        attended False
        +visual_location>
        isa _visuallocation
        screen_x closest""") #this rule is used if automatic visual search does not put anything in the buffer

        self.m.productionstring(name="check_probe", string="""
        =g>
        isa     goal
        state   start
        ?visual_location>
        buffer  full
        ==>
        =g>
        isa     goal
        state   attend""")  #this rule is used if automatic visual search is enabled and it puts something in the buffer

        self.m.productionstring(name="attend_probe", string="""
        =g>
        isa     goal
        state   attend
        =visual_location>
        isa    _visuallocation
        ?visual>
        state   free
        ==>
        =g>
        isa     goal
        state   reading
        +visual>
        isa     _visual
        cmd     move_attention
        screen_pos =visual_location
        ~visual_location>""")


        self.m.productionstring(name="encode_probe_and_find_new_location", string="""
        =g>
        isa     goal
        state   reading
        =visual>
        isa     _visual
        value   =val
        ?visual_location>
        buffer  empty
        ==>
        =g>
        isa     goal
        state   attend
        ~visual>
        ?visual_location>
        attended False
        +visual_location>
        isa _visuallocation
        screen_x closest""")

def read_obj_log_file(filename):
    file = open(filename, "r")
    list_of_objects_per_frame = []
    frame_no = 0
    #obj_cnt = 0

    ''' Dummy frame #0 : Nothing in it '''
    list_of_objects_per_frame.append([])


    for line in file:
        split_string = line.split(",")
        if len(split_string) == 1:  #This is frame number line
            frame_no = int(split_string[0])
            list_of_objects_per_frame.append([])
            #print(frame_no)
        else: # This is object information line
            object_type = split_string[1]
            prob = int(split_string[2])
            left_X = int(split_string[3])
            right_X = int(split_string[4])
            top_Y = int(split_string[5])
            bottom_Y = int(split_string[6])

            mid_X = (left_X + right_X)//2
            mid_Y = (top_Y + bottom_Y)//2

            width = right_X - left_X
            height = bottom_Y - top_Y
            area = width*height
            tmp_var = prob/2000
            delay = -math.log(float(tmp_var))
            object_info = [object_type, prob, mid_X, mid_Y, area, delay]
            list_of_objects_per_frame[frame_no].append(object_info)
            #obj_cnt += 1
    return list_of_objects_per_frame


if __name__ == "__main__":

    aspect_ratio_list = {"20thCWomen": (1920,960), "2days1night":(1280,688), "AfricanCats":(720,400), "AgeofShadows":(1280,720),"AmericanHustle":(1920,800), "BabyDriver":(1278,536),
    "Bladerunner": (1920,800),  "Childrenofmen":(1920,1040),"Dark_knight":(1920,802),"GOTRS07E04":(1920,1080), "Gravity":(1280,534), "IT":(1280,536),"Kingsman2":(1280,720),
    "Merciless":(1280,720), "Moonlight":(1920,808), "Mother":(1920,808), "Once":(720,390), "TokyoKazoku":(1024,560), "VIP":(1280,540), "ZeroDarkThirty":(1280,688), "MidnightinParis":(720,384), 
    "UsualSuspects" : (1920,816), "KingsSpeech":(1280,720), "Moneyball":(720,400),"Basterds":(1280,536),
    "Oldboy":(1024,440), "BatmanBegins":(1280,536), "HarryPotter1":(672,272), "100thlove":(1920,1080), "HarryPotter7":(720,304), "Wallflower":(1280,720),
    "KickAss":(1024,426), "Seven":(1280,534), "LateAutumn":(720,400), "Dongmakgol":(1280,548), "500Summer":(848,352), "Shame":(1280,544), "CrazyStupidLove":(1280,536),
    "HarryPotter3":(672,272), "BeforeSunset":(1272,720), "NoCountryforOldMen":(800,336), "ChoIn":(1280,720), "KillingMeSoftly":(1920,800),
    "BatvSup":(1916, 796), "SuicideSquad":(1916, 796), "Stoker":(1280, 536), "TheRoom":(1920,1080), "MemoriesofMurder":(1920,1040), "Madeo":(1920,816), 
    "AllaboutMyWife":(720,306), "ColdEyes":(1920, 804), "OurSunhi":(1280, 720)}

    argument = sys.argv[1]
    write_file_name = argument.split("/")[-1]
    write_file_path = "./" + write_file_name + "/" + write_file_name + "_eyegaze.csv"
    print(write_file_name)
    read_file_path = "./" + argument +"/"+argument + "_2fps_Detected_objects.csv" # File name in the same folder (csv file to parse)
    aspect_ratio = aspect_ratio_list[write_file_name]

    list_of_obj = read_obj_log_file(read_file_path) # list_of_obj[i] has the list of objects [[obj1, probability, middlepointX, middlepointY],[obj2,...],...] for frame number i
    old_stdout = sys.stdout 
    sys.stdout = log_line = StringIO()


    gaze_data_all = np.ndarray(shape=(len(list_of_obj),1), dtype=float)
    for i in tqdm(range(len(list_of_obj))):
        gaze_data = np.zeros(1)
        # for trial in range(10):
        stim_d = {key: {'text':key, 'position': (x[2], x[3]), 'vis_delay': x[5]} for key,x in enumerate(sorted(list_of_obj[i], key=lambda objs: objs[4],reverse=True))}
        print(stim_d)
        environ = actr.Environment(size=aspect_ratio, simulated_display_resolution=aspect_ratio, simulated_screen_size=(60, 34), viewing_distance=60)
        m = Model(environ, subsymbolic=True, latency_factor=0.4, decay=0.5, retrieval_threshold=-2, instantaneous_noise=0, automatic_visual_search=True, 
        eye_mvt_scaling_parameter=0.05, eye_mvt_angle_parameter=10, emma_landing_site_noise=True) #If you don't want to use the EMMA model, specify emma=False in here
        sim = m.m.simulation(realtime=False, trace=True,  gui=False, environment_process=environ.environment_process, stimuli=stim_d, triggers='X', times=10)
        sim.run(10)
        check = 0
        for key in m.dm:
            if key.typename == '_visual':
                print(key, m.dm[key])
                check += 1
        
        if log_line.getvalue()[-2] == "]":
            
            the_line = log_line.getvalue()[-50:-2]
            eye_gaze_this = the_line.split()[-1]
            #avg_file.write(eye_gaze_this)
            gaze_data[0] = float(eye_gaze_this)
        else:
            gaze_data[0] = 0.05

        gaze_data_all[i] = gaze_data

    sys.stdout = old_stdout
    # the_line = log_line.getvalue()[-2]
    np.savetxt(write_file_path, gaze_data_all, delimiter=",")
    print("Done writing to file: "+ write_file_path)
