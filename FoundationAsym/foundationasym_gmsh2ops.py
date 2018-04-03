from gmshtranslator import gmshTranslator

mshfname = "foundationasym.msh"

gt = gmshTranslator(mshfname)


fid_nodes =    open(mshfname.replace(".msh", ".nodes.tcl"),"w")
fid_elements = open(mshfname.replace(".msh", ".elements.tcl"),"w")
fid_fixities = open(mshfname.replace(".msh", ".fixities.tcl"),"w")

fid_loads_gravity = open(mshfname.replace(".msh", ".loads_gravity.tcl"),"w")
fid_loads_axial = open(mshfname.replace(".msh", ".loads_axial.tcl"),"w")
fid_loads_cyclic = open(mshfname.replace(".msh", ".loads_cyclic.tcl"),"w")

apply_gravity_to_these_elements = []
apply_surfaceLoad_to_these_elements = []

def is_node(tag,x,y,z,physgroups):
    return True

def add_node(tag,x,y,z):
    fid_nodes.write("node {} {} {} {}\n".format(tag, x, y, z))

def fix_ux(tag,x,y,z):
    fid_fixities.write("fix {} 1 0 0 \n".format(tag))

def fix_uy(tag,x,y,z):
    fid_fixities.write("fix {} 0 1 0\n".format(tag))

def fix_uz(tag,x,y,z):
    fid_fixities.write("fix {} 0 0 1\n".format(tag))

def load_CornersLeft(tag,x,y,z):
    fid_loads_axial.write("load {} -$qx0 -$qy0 -$qz0\n".format(tag))
    fid_loads_cyclic.write("load {} -$qx -$qy -$qz\n".format(tag))

def load_CornersRight(tag,x,y,z):
    fid_loads_axial.write("load {} -$qx0 -$qy0 -$qz0\n".format(tag))
    fid_loads_cyclic.write("load {}  $qx $qy $qz\n".format(tag))

def load_Top(eletag,eletype,physgrp,nodes):
    fid_elements.write("element SurfaceLoad  {eleTag} {node1} {node2} {node3} {node4} -$q \n".format(eleTag=eletag,
        node1=nodes[0],
        node2=nodes[1],
        node3=nodes[2],
        node4=nodes[3]))
    apply_surfaceLoad_to_these_elements.append(eletag)

def load_FoundationBottom(eletag,eletype,physgrp,nodes):
    fid_elements.write("element SurfaceLoad  {eleTag} {node1} {node2} {node3} {node4} $q \n".format(eleTag=eletag,
        node1=nodes[0],
        node2=nodes[1],
        node3=nodes[2],
        node4=nodes[3]))
    apply_surfaceLoad_to_these_elements.append(eletag)

def add_Soil_element(eletag,eletype,physgrp,nodes):
    fid_elements.write("element $BRICKTYPE {eleTag} {node1} {node2} {node3} {node4} {node5} {node6} {node7} {node8} {matTag} {b1} {b2} {b3} \n".format(
        eleTag=eletag,
        node1=nodes[0],
        node2=nodes[1],
        node3=nodes[2],
        node4=nodes[3],
        node5=nodes[4],
        node6=nodes[5],
        node7=nodes[6],
        node8=nodes[7],
        matTag="$mat_Soil_tag",
        b1="$b1_Soil",
        b2="$b2_Soil",
        b3="$b3_Soil"))
    apply_gravity_to_these_elements.append(eletag)
    
def add_Footing_element(eletag,eletype,physgrp,nodes):
    fid_elements.write("element $BRICKTYPE {eleTag} {node1} {node2} {node3} {node4} {node5} {node6} {node7} {node8} {matTag} {b1} {b2} {b3} \n".format(
        eleTag=eletag,
        node1=nodes[0],
        node2=nodes[1],
        node3=nodes[2],
        node4=nodes[3],
        node5=nodes[4],
        node6=nodes[5],
        node7=nodes[6],
        node8=nodes[7],
        matTag="$mat_Footing_tag",
        b1="0",
        b2="0",
        b3="0"))
    # apply_gravity_to_these_elements.append(eletag)
    


gt.add_nodes_rule(is_node, add_node)
gt.add_nodes_rule(gt.is_node_in("SidesX"), fix_ux)
gt.add_nodes_rule(gt.is_node_in("SidesY"), fix_uy)
gt.add_nodes_rule(gt.is_node_in("Bottom"), fix_uz)
gt.add_nodes_rule(gt.is_node_in("CornersLeft"), load_CornersLeft)
gt.add_nodes_rule(gt.is_node_in("CornersRight"), load_CornersRight)

gt.add_elements_rule(gt.is_element_in("Soil"), add_Soil_element)
gt.add_elements_rule(gt.is_element_in("Footing"), add_Footing_element)
gt.add_elements_rule(gt.is_element_in("Top"), load_Top)
gt.add_elements_rule(gt.is_element_in("FoundationBottom"), load_FoundationBottom)

gt.parse()

eles = ''
for tag in apply_gravity_to_these_elements:
    eles += str(tag) + " "

fid_loads_gravity.write("""
eleLoad -ele {} -type -selfWeight 0 0 1
""".format(eles))

eles = ''
for tag in apply_surfaceLoad_to_these_elements:
    eles += str(tag) + " "

fid_loads_gravity.write("""
eleLoad -ele {} -type -surfaceLoad
""".format(eles))



fid_nodes.close()
fid_elements.close()
fid_fixities.close()
fid_loads_cyclic.close()
fid_loads_gravity.close()
fid_loads_axial.close()