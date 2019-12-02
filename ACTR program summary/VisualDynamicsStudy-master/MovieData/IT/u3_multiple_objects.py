"""
A model for extended visual interface: multiple objects at the same time, vision checks them all and stores them.
"""

import string
import random
import warnings

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
            object_info = [object_type, prob, mid_X, mid_Y]
            list_of_objects_per_frame[frame_no].append(object_info)
            #obj_cnt += 1
    return list_of_objects_per_frame


if __name__ == "__main__":

    stochastic_avg_file_path = "./Bladerunner_eyegaze_avg.csv"
    avg_file = open(stochastic_avg_file_path, "w")
    file_path = "./IT_2fps_Detected_objects.csv" # File name in the same folder (csv file to parse)
    list_of_obj = read_obj_log_file(file_path) # list_of_obj[i] has the list of objects [[obj1, probability, middlepointX, middlepointY],[obj2,...],...] for frame number i
    old_stdout = sys.stdout 
    #log_file = open("message.log", "w")
    #sys.stdout = log_file
    sys.stdout = log_line = StringIO()
    #stim_d = {key: {'text': x, 'position': (random.randint(10,630), random.randint(10, 310))} for key, x in enumerate(string.ascii_uppercase)}
    #print(stim_d)
    #stim_d = [{1: {'text': 'X', 'position': (10, 10)}, 2: {'text': 'Y', 'position': (10, 20)}, 3:{'text': 'Z', 'position': (10, 30)}},{1: {'text': 'A', 'position': (10, 40)}, 2: {'text': 'B', 'position': (10, 50)}, 3:{'text': 'C', 'position': (10, 60)}}]
    #stim_d = [{1: {'text': 'X', 'position': (10, 10)}, 2: {'text': 'Y', 'position': (10, 20)}, 3:{'text': 'Z', 'position': (10, 30)}, 4: {'text': 'A', 'position': (10, 40)}, 5: {'text': 'B', 'position': (10, 50)}, 6:{'text': 'C', 'position': (10, 60)}}]
    gaze_data_all = np.ndarray(shape=(len(list_of_obj),1), dtype=float)
    for i in tqdm(range(len(list_of_obj))):
        gaze_data = np.zeros(1)
        # for trial in range(10):
        stim_d = {key: {'text':x[0], 'position': (x[2], x[3])} for key,x in enumerate(list_of_obj[i])}
        #print(stim_d)
        environ = actr.Environment(focus_position=(0,0))
        m = Model(environ, subsymbolic=True, latency_factor=0.4, decay=0.5, retrieval_threshold=-2, instantaneous_noise=0, automatic_visual_search=True, eye_mvt_scaling_parameter=0.05, eye_mvt_angle_parameter=10) #If you don't want to use the EMMA model, specify emma=False in here
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
            #avg_file.write("0.05")
        #avg_file.write(",")
        # mean = np.mean(gaze_data[:10])
        # std = np.std(gaze_data[:10])
        # gaze_data[10] = mean
        # gaze_data[11] = std
        gaze_data_all[i] = gaze_data
        #np.savetxt(avg_file, gaze_data, delimiter= ",")
        #avg_file.write("\n")
        #avg_file.write("\n")
    #print("#####Delimiter#####\n")
    # print(check)
    # print(len(stim_d))
    sys.stdout = old_stdout
    the_line = log_line.getvalue()[-2]
    np.savetxt("All_log.csv", gaze_data_all, delimiter=",")
    print(log_line.getvalue())
    print(the_line)
    avg_file.close()
    #log_file.close()