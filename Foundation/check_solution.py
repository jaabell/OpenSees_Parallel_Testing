import numpy as np
import scipy as sp
import matplotlib.pylab as plt

plt.style.use("ggplot")

d = sp.loadtxt("./out_grond_coarse_4_0.1_5_3_BALANCE_YES/nodedisp.out")
dr = sp.loadtxt("./reference_solution/nodedisp.out")

#Convert to mm
d[:,1:] *= 1000
dr[:,1:] *= 1000

offx = 1e-3
offy = 1

dx = d[:,1::3]
dy = d[:,2::3]
dz = d[:,3::3]
drx = dr[:,1::3]
dry = dr[:,2::3]
drz = dr[:,3::3]

plt.figure().set_size_inches([12,10], forward=True)
plt.subplot(1,2,1)
plt.plot(-offx+dx[:,0:2], dz[:,0:2])
plt.plot( offx+dx[:,2: ], dz[:,2: ])
plt.plot(-offx+drx[:,0:2], drz[:,0:2], "--", linewidth=2)
plt.plot( offx+drx[:,2: ], drz[:,2: ], "--", linewidth=2)
plt.ylabel("dz [cm]")
plt.xlabel("dx [cm]")

plt.subplot(1,2,2)
plt.plot(-offy+dy[:,0:2], dz[:,0:2])
plt.plot( offy+dy[:,2: ], dz[:,2: ])
plt.plot(-offy+dry[:,0:2], drz[:,0:2], "--", linewidth=2)
plt.plot( offy+dry[:,2: ], drz[:,2: ], "--", linewidth=2)
plt.xlabel("dy [cm]")

# plt.xlabel("Time, $t$ (s)")

plt.tight_layout()

plt.show()