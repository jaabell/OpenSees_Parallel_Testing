import numpy as np
import scipy as sp
import matplotlib.pylab as plt

from gmshPostTools.gmshPostTools import write_nodes_vector_data

data = sp.loadtxt("disps.out")

u = data[:,1:]

Nt = data.shape[0]
Ndata = data.shape[1]
Nnodes = (Ndata-1)/3
print Nt
print 

write_nodes_vector_data(open("disps.msh","w"), "Displacements", sp.arange(1,Nnodes+1), u[-1,:].reshape((-1,3)))

