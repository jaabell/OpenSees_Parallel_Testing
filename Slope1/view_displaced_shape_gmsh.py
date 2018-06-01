import numpy as np
import scipy as sp
import matplotlib.pylab as plt
from gmshPostTools.gmshPostTools import write_nodes_vector_data
import sys

if len(sys.argv) < 5:
    print "Usage {} [case] [meshsize] subtract_step step1 step2 step3 .....".format(sys.argv[0].split("/")[-1])
    exit( -1)

case = sys.argv[1]
meshsize = sys.argv[2]
subtract_step = sp.int32(sys.argv[3])
usestep = sp.int32(sys.argv[4])

filename = "./output_{}_{}/disp.out".format(case, meshsize)

nodes = sp.loadtxt("./output_{}_{}/nodes.txt".format(case, meshsize))

print "Working on ", filename, " usestep = ", usestep, " nelem = ", nodes.size

fid_u = open( "./output_{}_{}/disp.msh".format(case, meshsize), "w")

skip = 0
if usestep < 0:
    skip = -usestep    
    usestep  = 0

if subtract_step >= 0:
    for step, line in enumerate(open(filename)):
        if step == subtract_step:
            data = sp.fromstring(line, sep=" ")
            time = data[0]
            ndata = data.size - 1
            u0 = data[1:]
            continue


writeheader = True
for step, line in enumerate(open(filename)):
    if step == usestep:
        # print line
        data = sp.fromstring(line, sep=" ")
        time = data[0]
        ndata = data.size - 1
        print "step = {} time = {} ndata = {}".format(step, time, ndata)
        u = data[1:]
        if subtract_step >= 0:
            u = u - u0

        write_nodes_vector_data(fid_u, "Displacement", nodes, u.reshape(-1,2), time=time, step=step, writeheader=writeheader)

        writeheader = False
        if skip > 0:
            usestep += skip

fid_u.close()
