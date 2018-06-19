import numpy as np
import scipy as sp
import matplotlib.pylab as plt
import glob

globs = ["global.updatetime.*.out", "timing_solution_*.out", "timing_assembly_*.out", "timing_repartitioning.txt"]
titles = ["Update Time", "Solution Time", "Assembly Time", "Repartitioning Time"]


for g, tit in zip(globs, titles):

    print g

    files = glob.glob(g)
    files.sort()

    plt.figure()
    for f in files:
        data = sp.loadtxt(f)
        if len(data.shape) == 2:
            t = data[53:,0]
            u = data[53:,1]
            plt.plot(t,u,label=f.replace("updatetime","").replace("..","").replace(".out",""))
        else:
            u = data[:]
            plt.plot(u)#,label=f.replace("updatetime","").replace("..","").replace(".out",""))


    plt.xlabel("Analysis Pseudo-Time, [s]")
    plt.ylabel("Time (s)")
    plt.title(tit)
    plt.legend()


plt.show()
