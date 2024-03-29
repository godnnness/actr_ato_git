## ================================================================ ##
## STROOP.PY                                                        ##
## ================================================================ ##
## A simple ACT-R device for the Stroop task                        ##
## -----------------------------------------                        ##
## This is a device that showcases the unique capacities of the new ##
## JSON-RPC-based ACT-R interface. The device is written in Python, ##
## and interacts with ACT-R entirely through Python code.           ##
## The Stroop task is modeled after Tim Verstynen's (2014)          ##
## neuroimaging paper on the Stroop task.                           ##
## ================================================================ ##


import os
import actr
import random
import numpy as np
import scipy.optimize as opt


# 在这个版本的Stroop中，单词以三种颜色(红色、蓝色和绿色)中的一种出现，
# 用右手按三个对应的键(index =红色、middle =蓝色、ring =绿色)中的一个给出响应。
# 这个任务由120个试验组成:42个是一致的，42个是中性的，36个是不一致的。

# 该设备被实现为一个Python对象(' StroopTask ')，它控制一个ACT-R实验窗口。
# 实验窗口为ACT-R预定义的屏幕代理，并提供了本地支持，可将GUI元素(文本、图像、按钮和行)转换为预定义的ACT-R块集。
# 这个存储库包含四个不同的模型。
# 第一个模型是一个简单的测试模型，用于测试和调试与实验窗口的交互。这个模型被称为“response-monkey”。当它看到一个刺激时，它只是随机的点击。模型连续执行以下动作:
# 1. 如果模型没有查看任何内容，它将在屏幕上查找对象
#
# 2. 如果模型看着一个固定十字架，它什么也不做会继续寻找。
#
# 3.如果模型正在观察一个刺激(一个红色、绿色或蓝色，然后它随机响应的食指(“j”)，中指(“k”)或无名指(“l”)。
#
# 4. 如果模型看到一个黑色的单词“done”，它就会使用' !stop!”命令停止ACT-R
#
#第二个模型，`stroop-well.lisp`，实际上正确地执行了任务，尽管不自然。它拥有颜色名称的知识，正确地检索与屏幕上的每个单词相关联的颜色名称，并按适当的响应按钮。
#第三个模特，”stroop-jim.lisp’，也合并了一个简单的斯特鲁干扰的形式
#第四种，'stroop-better.lisp'，合并了一种更复杂的干扰形式，以替代颜色名称来竞争检索。

COLORS = ("red", "blue", "green")
CONDITIONS = ("congruent", "neutral", "incongruent")

NAMES = ("chair", "table")

COLOR_MAPPINGS = {"red" : "j",
                  "blue" : "k",
                  "green" : "l"}

# 判断颜色和单词是否一致，如果相同就一致，如果不同就不一致，如果不在表里就是中性
class StroopStimulus:
    """An abstract Stroop task stimulus"""
    def __init__(self, word, color):
        if color in COLORS:
            self.word = word
            self.color = color

    @property
    def word(self):
        return self._word

    @word.setter
    def word(self, val):
        self._word = val

    @property
    def color(self):
        return self._color

    @color.setter
    def color(self, val):
        self._color = val

    @property
    def congruent(self):
        if self.color in COLORS and self.word == self.color:
            return True
        else:
            return False

    @property
    def incongruent(self):
        if self.color in COLORS and self.word in COLORS and \
           self.color is not self.word:
            return True
        else:
            return False

    @property
    def neutral(self):
        if self.color in COLORS and self.word not in COLORS:
            return True
        else:
            return False

    def __str__(self):
        return "<'%s' in %s>" % (self.word, self.color)

    def __repr__(self):
        return self.__str__()

# 相应时间、精确度、是否正确相应
class StroopTrial:
    """A class for recording a Stroop trial"""
    def __init__(self, stimulus):
        """Inits a stroop trial"""
        self.stimulus = stimulus
        self.setup()

    def setup(self):
        "Sets up properly"
        self.color = self.stimulus.color
        self.word = self.stimulus.word
        self.onset = 0.0
        self.offset = 0.0
        self.response = None

    @property
    def correct_response(self):
        return COLOR_MAPPINGS[self.color]
        
    @property
    def accuracy(self):
        if self.response is not None and \
           self.response == self.correct_response:
            return 1.0
        else:
            return 0.0

    @property
    def response_time(self):
        return self.offset - self.onset

# 随机生成14个一致，7个中性，6个不一致
def generate_stimuli(shuffle = True):
    "Generates stimuli according to the Verstynen (2014) paradigm" 
    congr = [(x, x) for x in COLORS]
    incongr = [(x, y) for x in COLORS for y in COLORS if x is not y]
    neutr = [(x, y) for x in NAMES for y in COLORS]

    lst = congr * 14 + neutr * 7 + incongr * 6

    if shuffle:  # Randomized if needed
        random.shuffle(lst)
    
    return [StroopStimulus(word = x[0], color = x[1]) for x in lst]



class StroopTask:
    """A simple version of the Stroop task"""
    def __init__(self, stimuli=generate_stimuli(), setup=False):
        """Initializes a Stroop task (if there are stimuli)""" 
        if len(stimuli) > 0:
            self.stimuli = stimuli
            if setup:
                self.setup()

        
    def setup(self, win=None):
        """Sets up and prepares for first trial"""
        self.window = win
        self.index = 0
        self.log = []
        self.phase = "fixation"
        self.current_trial = StroopTrial(self.stimuli[self.index])
        self.update_window()
        actr.schedule_event_relative(1, "stroop-next")

        
    def run_stats(self):
        """Runs some basic analysis"""
        if len(self.log) > 0:
            cong = [x for x in self.log if x.stimulus.congruent]
            incn = [x for x in self.log if x.stimulus.incongruent]
            neut = [x for x in self.log if x.stimulus.neutral]

            R = {}
            for cond, data in zip(CONDITIONS,
                                  [cong, neut, incn]):
                if len(data) > 0:
                    acc = sum([x.accuracy for x in data]) / len(data)
                    rt = sum([x.response_time for x in data]) / len(data)
                    
                    R[cond] = (len(data), acc, rt)
            
            return R


    def print_stats(self, stats={}):
        """Pretty prints stats about the experiment"""
        for cond in stats.keys():
            n, acc, rt = stats[cond]
            print("%s (N=%d): Accuracy = %.2f, Response Times = %.2f ms" % \
                  (cond, n, acc, rt * 1000))

            
    def update_window(self):
        """Updates the experiment window"""
        if self.window is not None:
            # First, clean-up
            actr.clear_exp_window()

            # Then, add new elements
            if self.phase == "fixation":
                item = actr.add_text_to_exp_window(self.window, "+",
                                                   x = 400, y = 300,
                                                   color = "black")
            
            elif self.phase == "stimulus":
                color = self.current_trial.color
                word = self.current_trial.word
                item = actr.add_text_to_exp_window(self.window, word,
                                                   x=395, y= 300,
                                                   color = color)

                for i, col in enumerate(COLOR_MAPPINGS):
                    item = actr.add_text_to_exp_window(self.window,
                                                       COLOR_MAPPINGS[col],
                                                       x = 600 + i * 50,
                                                       y = 500,
                                                       color = col)
                print(type(COLOR_MAPPINGS))

            elif self.phase == "done":
                color = self.current_trial.color
                word = self.current_trial.word
                item = actr.add_text_to_exp_window(self.window, "done",
                                                   x=395, y= 300,
                                                   color = "black")

                
    def accept_response(self, model, response):
        """A valid response is a key pressed during the 'stimulus' phase"""
        if self.phase == "stimulus":
            self.current_trial.response = response
            actr.schedule_event_now("stroop-next")

            
    def next(self):
        """Moves on in th task progression"""
        if self.phase == "fixation":
            self.phase = "stimulus"
            self.current_trial.onset = actr.mp_time()

        elif self.phase == "stimulus":
            self.current_trial.offset = actr.mp_time()
            self.index += 1
            self.log.append(self.current_trial)
            if self.index >= len(self.stimuli):
                self.phase = "done"

            else:
                self.current_trial = StroopTrial(self.stimuli[self.index])
                self.phase = "fixation"
                actr.schedule_event_relative(1, "stroop-next")

        actr.schedule_event_now("stroop-update-window")


def run_experiment(model_name="response-monkey.lisp",
                   time=200,
                   verbose=True,
                   visible=True,
                   trace=True,
                   params=[]):
    """Runs an experiment"""
    actr.reset()
    # current directory
    curr_dir = os.path.dirname(os.path.realpath(__file__))
    actr.load_act_r_model(os.path.join(curr_dir, model_name))

    # Set then model parameters
    for name, val in params:
        actr.set_parameter_value(name, val)
    
    win = actr.open_exp_window("* STROOP TASK *", width = 800,
                               height = 600, visible=visible)

    actr.install_device(win)

    task = StroopTask(setup=False)
    #task.window = win

    actr.add_command("stroop-next", task.next,
                     "Updates the internal task")
    actr.add_command("stroop-update-window", task.update_window,
                     "Updates the window")
    actr.add_command("stroop-accept-response", task.accept_response,
                     "Accepts a response for the Stroop task")

    actr.monitor_command("output-key",
                         "stroop-accept-response")

    task.setup(win)
    if not trace:
        actr.set_parameter_value(":V", False)
    actr.run(time)
    if verbose:
        print("-" * 80)
        task.print_stats(task.run_stats())

    # Cleans up the interface
    # (Removes all the links between ACT-R and this object).

    actr.remove_command_monitor("output-key",
                                "stroop-accept-response")
    actr.remove_command("stroop-next")
    actr.remove_command("stroop-update-window")
    actr.remove_command("stroop-accept-response")
    
    # Returns the task as a Python object for further analysis of data
    return task


def simulate_behavior(model, params=[], n=100):
    """Simulates N runs of the model"""
    res = np.zeros((n, 3))
    for j in range(n):
        #print("Run #%03d" % j)
        task = run_experiment(model,
                              visible=False,
                              verbose=False,
                              trace=False,
                              params=params)
        stats = task.run_stats()
        res[j] = np.array([stats[x][2] for x in CONDITIONS])

    return res.mean(0) # Column mean


VERSTYNEN = [0.720, 0.755, 0.810]


def model_error(model, n=100, params=[], observed=VERSTYNEN):
    """Loss function for the model (RMSE)"""
    predicted = simulate_behavior(model, params, n)
    sqerr = (predicted - observed)**2
    return np.sqrt(np.mean(sqerr))

def jim_model_error(param_values, param_names=[":BLC"]):
    params = list(zip(param_names, param_values))
    print(params)
    return model_error("stroop-jim.lisp", n=50, params=params)
if __name__ == '__main__':
    # print("**********************************stroop.lisp************************************************")
    # run_experiment(model_name="stroop.lisp", time=200)
    print("**********************************stroop-well.lisp********************************************")
    run_experiment(model_name="stroop-well.lisp", time = 200)
    # print("**********************************stroop-better.lisp******************************************")
    # run_experiment(model_name="stroop-better.lisp", time=200)
    # print("***********************************stroop-jim.lisp********************************************")
    # run_experiment(model_name="stroop-jim.lisp", time=200,verbose=True,
    #                visible=True,
    #                trace=True,
    #                params=[])
# Example:
#
#     res = opt.minimize(jim_model_error, [1.5],
#                   method='nelder-mead',
#                   options={'disp':True})
