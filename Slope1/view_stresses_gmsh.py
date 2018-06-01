import numpy as np
import scipy as sp
import matplotlib.pylab as plt
from gmshPostTools.gmshPostTools import write_element_scalar_data
import sys

if len(sys.argv) != 4:
    print "Usage {} [case] [meshsize] [usestep]".format(sys.argv[0].split("/")[-1])
    exit( -1)

case = sys.argv[1]
meshsize = sys.argv[2]
usestep = sp.int32(sys.argv[3])

filename = "./output_{}_{}/stress.out".format(case, meshsize)

elements = sp.loadtxt("./output_{}_{}/elements.txt".format(case, meshsize))

print "Working on ", filename, " usestep = ", usestep, " nelem = ", elements.size

fid_sx = open( "./output_{}_{}/stress_sx.msh".format(case, meshsize), "w")
fid_sy = open( "./output_{}_{}/stress_sy.msh".format(case, meshsize), "w")
fid_sxy = open( "./output_{}_{}/stress_sxy.msh".format(case, meshsize), "w")
fid_K0 = open( "./output_{}_{}/stress_K0.msh".format(case, meshsize), "w")

skip = 0
if usestep < 0:
    skip = -usestep    
    usestep  = 0

writeheader = True
for step, line in enumerate(open(filename)):
    if step == usestep:
        print line
        data = sp.fromstring(line, sep=" ")
        time = data[0]
        ndata = data.size -1 
        print "step = {} time = {} ndata = {}".format(step, time, ndata)
        sx = data[1::3]
        sy = data[2::3]
        sxy = data[3::3]
        K0 = sx / sy

        write_element_scalar_data(fid_sx, "sx", elements, sx, time=time, step=step, writeheader=writeheader)
        write_element_scalar_data(fid_sy, "sy", elements, sy, time=time, step=step, writeheader=writeheader)
        write_element_scalar_data(fid_sxy, "sxy", elements, sxy, time=time, step=step, writeheader=writeheader)
        write_element_scalar_data(fid_K0, "K0", elements, K0, time=time, step=step, writeheader=writeheader)

        writeheader = False
        if skip > 0:
            usestep += skip

fid_sx.close()
fid_sy.close()
fid_sxy.close()
fid_K0.close()