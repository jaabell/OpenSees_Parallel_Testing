import numpy as np
import scipy as sp
import matplotlib.pylab as plt
import glob
import scipy.linalg as lin

numfiles = len(glob.glob("vectX_*.txt"))

for i in range(1,19):
    vectX = sp.loadtxt("vectX_{}.txt".format(i))
    vectB = sp.loadtxt("vectB_{}.txt".format(i))
    result = sp.loadtxt("result_{}.txt".format(i))
    plt.subplot(211)
    plt.plot(vectX)
    plt.subplot(212)
    plt.plot(vectB)
    # plt.subplot(313)
    # plt.plot(result)
    print "i = {}  norm(X) = {} norm(B) = {}".format(i, lin.norm(vectX), lin.norm(vectB))
plt.show()