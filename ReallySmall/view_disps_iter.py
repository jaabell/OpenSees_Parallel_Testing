import numpy as np
import scipy as sp
import matplotlib.pylab as plt

data_good = sp.loadtxt("node_disp_good.out")
data_check = sp.loadtxt("node_disp.out")

Nt = min(data_good.shape[0], data_check.shape[0])

# for i in range(Nt):
for i in range(0,1):
    plt.figure(i)
    plt.subplot(2,1,1)
    plt.plot(data_good[i,1:])
    plt.plot(data_check[i,1:])
    plt.subplot(2,1,2)
    plt.plot(data_good[i,1:] - data_check[i,1:])
plt.show()