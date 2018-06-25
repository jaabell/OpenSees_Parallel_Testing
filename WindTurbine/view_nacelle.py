import numpy as np
import scipy as sp
import matplotlib.pylab as plt

d = sp.loadtxt("disp_nacelle.out")
v = sp.loadtxt("velo_nacelle.out")
a = sp.loadtxt("accel_nacelle.out")

plt.figure()
plt.subplot(3,1,1)
plt.plot(d[:,0], d[:,1])
plt.subplot(3,1,2)
plt.plot(v[:,0], v[:,1])
plt.subplot(3,1,3)
plt.plot(a[:,0], a[:,1])

plt.show()