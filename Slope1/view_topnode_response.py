import numpy as np
import scipy as sp
import matplotlib.pylab as plt

t, ux, uy = sp.loadtxt("output_slope01_coarse/topnode.out", unpack=True)

g = 9.81
a0 = 0.2*g
T = 1.


dt = t[1] - t[0]

ax = sp.zeros(ux.shape)
ay = sp.zeros(ux.shape)
ax[1:-1] = (ux[2::] - 2*ux[1:-1] + ux[0:-2])/dt**2 
ay[1:-1] = (uy[2::] - 2*uy[1:-1] + uy[0:-2])/dt**2 

ax += a0*g*sp.sin(2*sp.pi/T*t)*(t<5.0)

plt.subplot(4,1,1)
plt.plot(t,ux)
plt.ylabel("D_X")
plt.subplot(4,1,2)
plt.plot(t,ax)
plt.ylim([-2*g, 2*g])
plt.ylabel("A_X")
plt.subplot(4,1,3)
plt.plot(t,uy)
plt.ylabel("D_Y")
plt.subplot(4,1,4)
plt.plot(t,ay)
plt.ylim([-2*g, 2*g])
plt.ylabel("A_Y")
plt.show()