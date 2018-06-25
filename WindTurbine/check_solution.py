import numpy as np
import scipy as sp
import matplotlib.pylab as plt

d = sp.loadtxt("disp_nacelle.out")
v = sp.loadtxt("velo_nacelle.out")
a = sp.loadtxt("accel_nacelle.out")

dr = sp.loadtxt("./reference_solution/disp_nacelle.out")
vr = sp.loadtxt("./reference_solution/velo_nacelle.out")
ar = sp.loadtxt("./reference_solution/accel_nacelle.out")

a0 = 0.8*9.81*sp.sin(2*sp.pi*d[:,0])*0
a0r = 0.8*9.81*sp.sin(2*sp.pi*dr[:,0])*0

plt.figure()
plt.subplot(3,1,1)
plt.plot(d[:,0], d[:,1])
plt.plot(dr[:,0], dr[:,1], "--")
plt.ylabel("Disp, $d$ (m)")
plt.subplot(3,1,2)
plt.plot(v[:,0], v[:,1])
plt.plot(vr[:,0], vr[:,1], "--")
plt.ylabel("Vel, $v$ (m/s)")
plt.subplot(3,1,3)
plt.plot(a[:,0], a[:,1]+a0)
plt.plot(ar[:,0], ar[:,1]+a0r, "--")
plt.ylabel("Acc, $a$ (m/s^2)")

plt.xlabel("Time, $t$ (s)")

plt.show()