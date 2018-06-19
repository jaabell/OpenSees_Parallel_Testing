import numpy as np
import scipy as sp
import matplotlib.pylab as plt
import glob
import scipy.linalg as lin

numfiles = len(glob.glob("vectX_*.txt"))

N = 19

for i in range(1,N):
    vectX = sp.loadtxt("vectX_{}.txt".format(i))
    vectB = sp.loadtxt("vectB_{}.txt".format(i))
    result = sp.loadtxt("result_{}.txt".format(i))

    c = float(i)/N
    cc = [c, c, c]

    plt.subplot(211)
    plt.plot(vectX, color=cc)
    plt.subplot(212)
    plt.plot(vectB, color=cc)
    # plt.subplot(313)
    # plt.plot(result)
    print "i = {}  norm(X) = {} norm(B) = {}".format(i, lin.norm(vectX), lin.norm(vectB))
plt.show()