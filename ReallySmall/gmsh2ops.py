from gmshtranslator import gmshTranslator

mshfname = "smallmodel.msh"

gt = gmshTranslator(mshfname)

fid =    open(mshfname.replace(".msh", ".model.tcl"),"w")

def is_node(tag,x,y,z,physgroups):
    return True

def is_in_edge(tag,x,y,z,physgroups):
    return gt.is_node_in("Top")(tag,x,y,z,physgroups) \
    or gt.is_node_in("Sides")(tag,x,y,z,physgroups) \
    or gt.is_node_in("Bottom")(tag,x,y,z,physgroups) 
    # return gt.is_node_in("Bottom")(tag,x,y,z,physgroups) 

def add_node(tag,x,y,z):
    fid.write("node {} {} {}\n".format(tag, x, y))

def fix_node_ux(tag,x,y,z):
    fid.write("fix {} 1 0\n".format(tag))

def fix_node_uy(tag,x,y,z):
    fid.write("fix {} 0 1\n".format(tag))

def fix_node_uxuy(tag,x,y,z):
    fid.write("fix {} 1 1\n".format(tag))


topline = []
elements = []

def store_topline(tag,x,y,z):
    global topline
    topline.append(tag)

def add_element(eletag,eletype,physgrp,nodes):
    global elements
    # fid.write("element SSPquad {} {} {} {} {} $matnum PlaneStrain 1.0 1 1\n".format(eletag, nodes[0], nodes[1], nodes[2], nodes[3]))
    #          element quad 17 1 10 22 17 1.0 PlaneStrain $matnum 0 1 0 -1
    fid.write("element quad {} {} {} {} {} 1.0 PlaneStrain $matnum 0 0 $fx $fy\n".format(eletag, nodes[0], nodes[1], nodes[2], nodes[3]))
    elements.append(eletag)
    

gt.add_nodes_rule(is_node, add_node)
# gt.add_nodes_rule(gt.is_node_in("Sides"), fix_node_ux)
# gt.add_nodes_rule(gt.is_node_in("Bottom"), fix_node_uy)
gt.add_nodes_rule(gt.is_node_in("Top"), store_topline)
gt.add_nodes_rule(is_in_edge, fix_node_uxuy)

gt.add_elements_rule(gt.is_element_in("Soil"), add_element)

gt.parse()

fid.write("\n\nset topline [list ")
for n in topline:
    fid.write(str(n)+" ")
fid.write("]\n")

fid.write("\n\nset elements [list ")
for n in elements:
    fid.write(str(n)+" ")
fid.write("]\n")

fid.close()