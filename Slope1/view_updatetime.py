import numpy as np
import scipy as sp
import matplotlib.pylab as plt
import glob


files = glob.glob("timing.updatetime.*.4.out")

files.sort()

plt.figure()
plt.subplot(3,1,1)

do_once = True
for f in files:
    data = sp.loadtxt(f)
    t = data[50:,0]
    u = data[50:,1]
    if do_once:
        umax = u.copy()
        umin = u.copy()
        do_once = False
    else:
        umax = sp.maximum(u, umax)
        umin = sp.minimum(u, umin)
    plt.plot(t,u,label=f.replace(".updatetime.",".").replace(".out",""))

unbalance = (umax - umin)/umin
plt.legend()

plt.subplot(3,1,2)
plt.plot(t, unbalance)
plt.ylim([0, 1.0])

T = 1.0
plt.subplot(3,1,3)
plt.plot(t, 0.4*sp.sin(2*sp.pi/T*t)*(t<5.0))

plt.show()
