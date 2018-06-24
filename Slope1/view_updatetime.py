import numpy as np
import scipy as sp
import matplotlib.pylab as plt
import glob

plt.style.use("ggplot")

dirs = ["medium_balancer_on/",  "medium_balancer_on_shm/"]
# dirs = ["medium_balancer_off/",  "medium_balancer_on/"]
# dirs = ["balancer_off/",  "balancer_on/"]
# dirs = ["balancer_on/",  "balancer_on_shm/"]
# dirs = ["balancer_on/",  "./"]

globs = ["timing.updatetime.*.out", "timing_solution_*.out", "timing_assembly_*.out", "timing_repartitioning.txt"]
titles = ["Update Time", "Solution Time", "Assembly Time", "Repartitioning Time"]

ylims = [0.025, 0.0012, 0.00012, 0.0035]


for g, tit, ylim in zip(globs, titles, ylims):

    plt.figure().set_size_inches([12,5], forward=True)
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
                plt.subplot(2,2,i)
                plt.plot(t, u)#,label=f.replace("updatetime","").replace("..","").replace(".out",""))
                cumu = sp.cumsum(u)
                # ax=plt.gca()
                # plt.ylim([0, ylim])
                
                plt.subplot(2,2,i+1)
                # ax2 = ax.twinx()
                plt.plot(t, cumu)
                # plt.set_ylabel("Cumulative Time [s]")
                # ax.set_ylabel("Update Time [s]")
            else:
                plt.subplot(2,2,i)
                u = data[:]
                plt.plot(u)#,label=f.replace("updatetime","").replace("..","").replace(".out",""))
            # ax.set_ylim([0, ylim])
            plt.ylabel("Time (s)")
        i += 2


    plt.xlabel("Analysis Pseudo-Time, [s]")
    plt.suptitle(tit)
    # plt.legend()


plt.show()
