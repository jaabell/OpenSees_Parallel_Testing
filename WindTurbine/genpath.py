import numpy as np
import scipy as sp
import matplotlib.pylab as plt

f = 1.6778170479140695
T = 1/f
PGA = 1.5*9.81

Ncyc = 3
tmax = 3*T

t = sp.arange(0, 10*T, 0.001)
y = sp.sin(2*sp.pi/T*t)*(t <= tmax)*PGA

print t[1] - t[0]

# plt.savetxt("acc.txt", sp.vstack((t,y)).T)
# plt.savetxt("acc2.txt", y)

plt.plot(t, y)
plt.show()