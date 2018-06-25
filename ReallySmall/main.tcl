model BasicBuilder -ndm 2 -ndf 2

set matnum 1
set bricktype quad

set fx 1
set fy 1

source "materials.tcl"
source "smallmodel.model.tcl"
# source "smallmodel.quadmodel.tcl"

set loadstring "eleLoad -ele $elements -type -selfWeight 1 1 0"
# set loadstring "eleLoad -ele 20 -type -selfWeight 0  1 0"
# set loadstring "eleLoad -ele 23 -type -selfWeight 0  1 0"
puts $loadstring

pattern Plain 1 "Linear"  {
    eval $loadstring
}



set rank [getPID]
set nproc [getNP]
recorder gmsh nodeoutput disp

if {$nproc == 1} {
    recorder Node -file "node_disp_good.out" -time -nodeRange 1 25 -dof 1 2 disp
} else {
    recorder Node -file "node_disp.out" -time -nodeRange 1 25 -dof 1 2 disp
}


# recorder Node -file "node_incrDisp.out" -time -nodeRange 1 25 -dof 1 2 incrDisp
# recorder Node -file "node_incrDeltaDisp.out" -time -nodeRange 1 25 -dof 1 2 incrDeltaDisp 
# recorder Node -file "node_unbalance.out" -time -nodeRange 1 25 -dof 1 2 unbalance

if {$nproc > 1} {
    # Parallel processing mode
    # constraints Plain
    # constraints Transformation
    numberer Plain
    # numberer RCM
    # system Mumps
    system SparseGEN
    # system ProfileSPD
    # system BandGeneral
    partitioner MetisWithTopology
    balancer TopologicalBalancer
} else {
    # Sequential processing mode
    constraints Plain
    numberer RCM
    system UmfPack
}

test NormDispIncr 1.0e-6 2 1
algorithm Newton
integrator LoadControl 0.1
analysis Static

updateMaterialStage -material $matnum -stage 0

analyze 10

# for {set i 0} {$i < 10} {incr i} {
    # analyze 1
# }


# updateMaterialStage -material $matnum -stage 1


puts "---Done self weight"
# foreach tag $elements {
#     print -ele $tag
# }
puts [nodeDisp 5] 
