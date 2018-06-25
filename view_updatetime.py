#!/usr/bin/python

import numpy as np
import scipy as sp
import matplotlib.pylab as plt
import glob
import sys

plt.style.use("ggplot")


if len(sys.argv) < 3 :
    print "Usage: view_updatetime.py [dir1] [dir2] <outfigsbasename>"
    exit(-1)
else:
    dir1 = sys.argv[1] 
    dir2 = sys.argv[2] 

if len(sys.argv) == 4 :
    outfigsbasename = sys.argv[3] 
else:
    outfigsbasename = ""



dirs = [dir1, dir2]

globs = ["timing.updatetime.*.out", "timing_solution_*.out", "timing_assembly_*.out", "timing_repartitioning.txt"]
titles = ["Update Time", "Solution Time", "Assembly Time", "Repartitioning Time"]

fignum = 1
for g, tit in zip(globs, titles):

    plt.figure(fignum).set_size_inches([12,5], forward=True)
    i = 1
    for d in dirs:
        print g

        files = glob.glob(d+g)
        files.sort()

        for f in files:
            data = sp.loadtxt(f)
            if len(data.shape) == 2:
                t = data[:,0]
                u = data[:,1]
                if i == 1:
                    ax1 = plt.subplot(2,2,i)
                if i == 3:
                    plt.subplot(2,2,i,sharex=ax1, sharey=ax1)
                plt.plot(t, u)
                plt.ylabel("Time (s)")
                if i == 1:
                    plt.title("Incremental", size="medium")
                if i == 3:
                    plt.xlabel("Analysis Time, [s]")
                if i == 1:
                    ax2 = plt.subplot(2,2,i+1)
                if i == 3:
                    plt.subplot(2,2,i+1,sharex=ax1, sharey=ax2)                
                cumu = sp.cumsum(u)
                plt.plot(t, cumu)
                if i == 1:
                    plt.title("Cumulative", size="medium")
                if i == 3:
                    plt.xlabel("Analysis Time, [s]")

        i += 2


    plt.suptitle(tit)
    fignum += 1

if outfigsbasename == "":
    plt.show()
else:
    for i, tit in enumerate(titles):
        plt.figure(i+1)
        plt.savefig(outfigsbasename+tit.lower().replace(" ", "_")+".png")