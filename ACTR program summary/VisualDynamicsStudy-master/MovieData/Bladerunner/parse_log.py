import os 
import numpy as np
import matplotlib.pyplot as plt

file_path = "./message.log"

file = open(file_path, 'r')

time_log = np.empty(6752)
cnt = 0
cnt_vis = 0
cnt_none = 0

line_prev = ""
for line in file:
	line = line.strip()
	if line == "#####Delimiter#####":
		if (line_prev[:7] == "_visual"):
			#print(line_prev)
			tmp = line_prev.split()
			time = float(tmp[-1][:-1])
			
			#print(time)
			cnt_vis += 1
		elif line_prev[0] == "(":
			tmp = line_prev.split(',')
			time = float(tmp[0][1:])
			cnt_none +=1
		time_log[cnt] = time

		cnt +=1

	line_prev = line
#print (cnt, cnt_vis, cnt_none)
print(time_log)
print(len(time_log))

plt.plot(range(len(time_log)), time_log)
plt.show()