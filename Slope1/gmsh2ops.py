import scipy as sp
from gmshtranslator import gmshTranslator
import sys

print sys.argv

# exit(0)

if len(sys.argv) != 3 :
    print "Usage: gmsh2ops.py [case] [meshsize] "
    exit(-1)
else:
    case = sys.argv[1] 
    meshsize = sys.argv[2] 

mshfname = case+"_"+meshsize+".msh"
outdir = "model_" + case + "_" + meshsize + "/"


readmshfile = "./meshes/" + mshfname

print "gmsh2ops.py - Reading: " + readmshfile
print "gmsh2ops.py - Output : " + outdir


gt = gmshTranslator(readmshfile)

fid_wetnodes      = open(outdir+mshfname.replace(".msh", ".wetnodes.tcl"),"w")
fid_drynodes      = open(outdir+mshfname.replace(".msh", ".drynodes.tcl"),"w")
fid_phreaticnodes = open(outdir+mshfname.replace(".msh", ".phreaticnodes.tcl"),"w")
fid_dryelements   = open(outdir+mshfname.replace(".msh", ".dryelements.tcl"),"w")
fid_wetelements   = open(outdir+mshfname.replace(".msh", ".wetelements.tcl"),"w")
fid_fixities      = open(outdir+mshfname.replace(".msh", ".fixities.tcl"),"w")

Nnodes = gt.Nnodes
Nelem = gt.Nelem

Ndof_nodes = sp.zeros(Nnodes+1, dtype=sp.int32)

equaldofs = {}

for periodic_entity in gt.Periodic_nodes:
    for nodes in periodic_entity:
        equaldofs[nodes[1]] = nodes[0]
        # print nodes


def is_wetnode(tag,x,y,z,physgroups): 
    return gt.physical_groups_by_name["WetSoil"] in physgroups

def is_drynode(tag,x,y,z,physgroups): 
    return (gt.physical_groups_by_name["DrySoil"] in physgroups) and (not gt.physical_groups_by_name["PhreaticLine"] in physgroups)

def is_phreaticnode(tag,x,y,z,physgroups): 
    return gt.physical_groups_by_name["PhreaticLine"] in physgroups

def is_interface_node(tag,x,y,z,physgroups): 
    return is_phreaticnode(tag,x,y,z,physgroups) and is_drynode(tag,x,y,z,physgroups)


def add_wetnode(tag,x,y,z):
    fid_wetnodes.write("node {} {} {}\n".format(tag, x, y))
    if equaldofs.has_key(tag):
        othernode = equaldofs[tag]
        fid_phreaticnodes.write("equalDOF {} {}  1 2\n".format(tag, othernode))
    Ndof_nodes[tag] = 3

def add_drynode(tag,x,y,z):
    fid_drynodes.write("node {} {} {}\n".format(tag, x, y))
    Ndof_nodes[tag] = 2

def fix_node_ux(tag,x,y,z):
    ndof = Ndof_nodes[tag]
    if ndof == 2:
        fid_fixities.write("fix {} 1 0\n".format(tag))
    elif ndof == 3:
        fid_fixities.write("fix {} 1 0 0\n".format(tag))
    else:
        print "Node {} has {} dofs, should have 2 or 3".format(tag, ndof)

def fix_node_uy(tag,x,y,z):
    ndof = Ndof_nodes[tag]
    if ndof == 2:
        fid_fixities.write("fix {} 0 1\n".format(tag))
    if ndof == 3:
        fid_fixities.write("fix {} 0 1 0\n".format(tag))
    else:
        print "Node {} has {} dofs, should have 2 or 3".format(tag, ndof)

def fix_node_uxuy(tag,x,y,z):
    ndof = Ndof_nodes[tag]
    if ndof == 2:
        fid_fixities.write("fix {} 1 1\n".format(tag))
    if ndof == 3:
        fid_fixities.write("fix {} 1 1 0\n".format(tag))
    else:
        print "Node {} has {} dofs, should have 2 or 3".format(tag, ndof)


def fix_node_p(tag,x,y,z):
    ndof = Ndof_nodes[tag]
    if ndof == 3:
        fid_fixities.write("fix {} 0 0 1\n".format(tag))
    else:
        print "Node {} has {} dofs, should have 3 !!".format(tag, ndof)


def add_wet_element(eletag,eletype,physgrp,nodes):
    fid_wetelements.write("element SSPquadUP {} {} {} {} {} $soil_matTag 1.0 $fBulk $fDen $k1 $k2 $void $alpha $b1_wet $b2_wet\n".format(eletag, nodes[0], nodes[1], nodes[2], nodes[3]))

def add_dry_element(eletag,eletype,physgrp,nodes):
    fid_dryelements.write("element SSPquad {} {} {} {} {} $soil_matTag PlaneStrain 1.0 $b1_dry $b2_dry\n".format(eletag, nodes[0], nodes[1], nodes[2], nodes[3]))

    

gt.add_nodes_rule(is_wetnode, add_wetnode)
gt.add_nodes_rule(is_drynode, add_drynode)
gt.add_nodes_rule(is_phreaticnode, fix_node_p)
# gt.add_nodes_rule(gt.is_node_in("Bottom"), fix_node_uy)
gt.add_nodes_rule(gt.is_node_in("Bottom"), fix_node_uxuy)
gt.add_nodes_rule(gt.is_node_in("Sides"), fix_node_ux)

gt.add_elements_rule(gt.is_element_in("WetSoil"), add_wet_element)
gt.add_elements_rule(gt.is_element_in("DrySoil"), add_dry_element)

gt.parse()


fid = open(outdir+"/wetnodes.txt", "w")
for tag, ndof in enumerate(Ndof_nodes):
    if ndof == 3:
        fid.write("{} ".format(tag))

fid.close()

fid_wetnodes.close()
fid_drynodes.close()
fid_phreaticnodes.close()
fid_dryelements.close()
fid_wetelements.close()
fid_fixities.close()