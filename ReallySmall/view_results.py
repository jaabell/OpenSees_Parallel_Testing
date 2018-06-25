import numpy as np
import scipy as sp
import matplotlib.pylab as plt
import glob
import scipy.linalg as lin

numfiles = len(glob.glob("vectX_*.txt"))

start = 0
end = 8

for i in range(start,end):
    
    vectX = sp.loadtxt("vectX_{}.txt".format(i))
    vectX0 = sp.loadtxt("vectX0_{}.txt".format(i))
    vectX1 = sp.loadtxt("vectX1_{}.txt".format(i))
    
    vectB = sp.loadtxt("vectB_{}.txt".format(i))
    vectB0 = sp.loadtxt("vectB0_{}.txt".format(i))
    vectB00 = sp.loadtxt("vectB0_{}_0.txt".format(i))
    vectB01 = sp.loadtxt("vectB0_{}_1.txt".format(i))
    # result = sp.loadtxt("result_{:5.3f}.txt".format(i))
    plt.figure(i/2)
    plt.subplot(2,2,1+2*(i%2))
    plt.plot(vectX0)
    plt.plot(vectX)
    plt.plot(vectX1,"--")
    plt.title("X")
    plt.xticks(sp.arange(18))
    plt.grid("on")
    plt.subplot(2,2,2+2*(i%2))
    plt.plot(vectB00,"--",label="B00")
    plt.plot(vectB01,label="B01")
    plt.plot(vectB0,label="B0")
    plt.plot(vectB,"--",label="B",linewidth=2)
    plt.xticks(sp.arange(18))
    plt.grid("on")
    plt.title("B")
    plt.legend(loc="best",frameon=False)
    # plt.subplot(313)
    # plt.plot(result)
    nb = lin.norm(vectB)
    print "i = {:5.3f} \n    norm(X) = {:5.3f}\n    norm(B) = {:5.3f}  norm(B0) = {:5.3f}\n  norm(B00) = {:5.3f} norm(B01) = {:5.3f} ".format(i, lin.norm(vectX), nb, lin.norm(vectB0), lin.norm(vectB00), lin.norm(vectB01))
    # if nb > 1e-6:
        # end = i+1
        # break


for i in range(start,end):
    
    K00 = sp.loadtxt("K0_{}_0.txt".format(i))
    K01 = sp.loadtxt("K0_{}_1.txt".format(i))
    K0 = sp.loadtxt("K0_{}.txt".format(i))
    K = sp.loadtxt("K_{}.txt".format(i))
    
#     plt.figure(end/2+i/2)
#     plt.subplot(2,1,1+i%2)
#     plt.plot(K00,"--",label="K00")
#     plt.plot(K01,label="K01")
#     plt.plot(K0,label="K0")
#     # plt.plot(K,"--",label="K")

    print "i = {:5.3f} sumK00 = {:5.3f} sumK01 = {:5.3f} sumK0 = {:5.3f} sumK = {:5.3f}".format(i, K00[:].sum(), K01[:].sum(), K0[:].sum(), K[:].sum())

#     # plt.xticks(sp.arange(36))
#     plt.title("K")


plt.show()