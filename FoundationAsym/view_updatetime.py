import numpy as np
import scipy as sp
import matplotlib.pylab as plt
import glob


files = glob.glob("updatetime.updatetime.*.32.out")

files.sort()

plt.figure()


for f in files:
    data = sp.loadtxt(f)
    t = data[2:,0]
    u = data[2:,1]
    plt.plot(t,u,label=f.replace("updatetime","").replace("..","").replace(".out",""))

plt.legend()
plt.show()
