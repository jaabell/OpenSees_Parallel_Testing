import numpy as np
import scipy as sp
import matplotlib.pylab as plt

E = 2100.
nu = 0.25
G = E//(2*(1+nu))

H = 0.5*G



s0 = 480
sinf = 420

delta = 200

xi = sp.linspace(0, 1e-2, 100)

q1 = s0 + (sinf - s0)*sp.exp(-delta*xi)
q2 = s0 + H*xi
q3 = s0 + (sinf - s0)*sp.exp(-delta*xi) + H*xi
q4 = s0 + G*xi

plt.plot(xi, q1)
plt.plot(xi, q2)
plt.plot(xi, q3)
plt.plot(xi, q4)

plt.show()
