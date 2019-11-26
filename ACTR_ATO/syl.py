#!/usr/bin/env python

# -*- coding: utf-8 -*-
# @Time : 2019/11/17 21:24
# @Author : Yulong Sun
# @Site : 
# @File : syl.py
# @Software: PyCharm
import numpy as np
import numbers
import matplotlib.pyplot as plt

ts= [40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 39, 38, 38, 38, 38, 38, 38, 38, 38, 37, 37, 37, 37, 37, 37, 36, 36, 36, 36, 36, 36, 35, 35, 35, 35, 35, 34, 34, 34, 34, 34, 33, 33, 33, 33, 32, 32, 32, 32, 31, 31, 31, 31, 30, 30, 30, 29, 29, 29, 29, 28, 28, 28, 27, 27, 27, 26, 26, 26, 25, 25, 25, 24, 24, 24, 23, 23, 22, 22, 22, 21, 21, 21, 20, 20, 19, 19, 19, 18, 18, 18, 17, 17, 16, 16, 16, 15, 15, 15, 14, 14, 14, 13, 13, 13, 12, 12, 12, 11, 11, 11, 11, 10, 10, 10, 9, 9, 9, 9, 8, 8, 8, 8, 7, 7, 7, 7, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1]
acs=  ['40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '40', '38', '40', '38', '40', '38', '40', '38', '40', '38', '40', '38', '40', '38', '38', '38', '38', '38', '38', '38', '38', '36', '38', '36', '38', '36', '38', '36', '36', '36', '36', '36', '36', '34', '36', '34', '36', '34', '34', '34', '34', '34', '34', '32', '34', '32', '34', '32', '32', '32', '32', '30', '32', '30', '32', '30', '30', '30', '28', '30', '28', '30', '28', '28', '28', '26', '28', '26', '26', '26', '26', '24', '26', '24', '24', '24', '24', '22', '24', '22', '22', '22', '20', '22', '20', '20', '20', '18', '20', '18', '18', '18', '18', '16', '18', '16', '16', '16', '14', '16', '14', '14', '14', '14', '12', '14', '12', '12', '12', '12', '10', '12', '10', '12', '10', '10', '10', '8', '10', '8', '10', '8', '8', '8', '8', '6', '8', '6', '8', '6', '6', '6', '6', '6', '4', '6', '4', '6', '4', '4', '4', '4', '4', '4', '4', '2', '4', '2', '4', '2', '4', '2', '2', '2', '2', '2', '2', '2', '2', '0', '2', '0', '2', '0']
# acs_1=[""]*188
acs_1=list(acs)
time =[]
for i in range(188):
    i = i+1
    time.append(i)
    # acs_1.append(acs[i])
print(time,len(ts),len(acs),acs_1)

print(len(ts))
# x = np.arange(0, 350)
# plt.figure(1)
# plt.subplot(1,2,1)
# plt.plot(time, ts, color="r", linestyle="-", marker="^", linewidth=1)
# plt.xlabel("时间")
# plt.ylabel("目标速度")
#
# plt.figure(2) # 生成第二个图，且当前要处理的图为fig.2
# plt.plot(time, acs, color="k", linestyle="-", marker="s", linewidth=1) # 画图，fig.2是一张整图，没有子图，默认subplot(1, 1, 1)
#
# plt.xlabel("时间")
# plt.ylabel("实际速度")
#
# plt.show()
x = np.linspace(0, 190, 188)
plt.figure(num=3, figsize=(8, 5))
l1 = plt.plot(x, ts,  'r', label='targetspeed')
l2 = plt.plot(x,acs,  'g', label='actualspeed')
# plt.plot(time, ts, 'ro-', time, acs,  'g+-')
plt.title('Speed ​​tracking')
plt.xlabel('time')
plt.ylabel('speed value')
plt.ylim((0, 50))
plt.xlim((0,190))
my_y_ticks = np.arange(0, 50, 1)
my_x_ticks = np.arange(0, 190, 1)
plt.yticks(my_y_ticks)
plt.xticks(my_x_ticks)
plt.legend()
plt.show()

# ax1 = plt.subplot(311)
# plt.plot(time, ts)
# plt.setp(ax1.get_xticklabels(), fontsize=6)
#
# # share x only
# ax2 = plt.subplot(312, sharex=ax1)
# plt.plot(time, acs)
# # make these tick labels invisible
# plt.setp(ax2.get_xticklabels(), visible=False)
#
# # share x and y
# ax3 = plt.subplot(313, sharex=ax1, sharey=ax1)
# plt.plot(time, ts)
# plt.plot(time, acs)
# plt.xlim(0.01, 200)
# plt.show()
