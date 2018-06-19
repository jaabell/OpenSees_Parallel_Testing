import numpy as np
import scipy as sp
import matplotlib.pylab as plt
import glob

plt.style.use("ggplot")

# dirs = ["balancer_off/",  "balancer_on/"]
dirs = ["balancer_on/",  "balancer_on_shm/"]
# dirs = ["balancer_on/",  "./"]

globs = ["global.updatetime.*.out", "timing_solution_*.out", "timing_assembly_*.out", "timing_repartitioning.txt"]
titles = ["Update Time", "Solution Time", "Assembly Time", "Repartitioning Time"]

ylims = [0.1, 0.20, 0.016, 0.20]


for g, tit, ylim in zip(globs, titles, ylims):

    plt.figure()
    i = 1
    for d in dirs:
        print g

        files = glob.glob(d+g)
        files.sort()

        plt.subplot(2,1,i)
        for f in files:
            data = sp.loadtxt(f)
            if len(data.shape) == 2:
                t = data[:,0]
                u = data[:,1]
                plt.plot(t, u)#,label=f.replace("updatetime","").replace("..","").replace(".out",""))
            else:
                u = data[:]
                plt.plot(u)#,label=f.replace("updatetime","").replace("..","").replace(".out",""))
            plt.ylim([0, ylim])
            plt.ylabel("Time (s)")
        i += 1


    plt.xlabel("Analysis Pseudo-Time, [s]")
    plt.suptitle(tit)
    # plt.legend()


plt.show()
