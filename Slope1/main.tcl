set MESHSIZE [lindex $::argv 0] 
set max_unbalance [lindex $::argv 1] 
set nsteps_balance [lindex $::argv 2] 
set strategy [lindex $::argv 3] 


puts "MESHSIZE = $MESHSIZE"
puts "max_unbalance = $max_unbalance"
puts "nsteps_balance = $nsteps_balance"
puts "strategy = $strategy"


set BALANCE_ALWAYS 0 
set BALANCE_ALWAYS_NSTEPS 1
set BALANCE_EXCEED 2
set BALANCE_EXCEED_NTIMES 3
set BALANCE_EXCEED_NTIMES_CONSEC 4

set rank [getPID]
set nproc [getNP]

puts "rank   =   $rank"
puts "nproc   =   $nproc"


#Read case and meshsize selection from command line
set CASE "slope01"; #[lindex $::argv 0]
# set MESHSIZE "coarse"; # [lindex $::argv 1]
set a0 0.1; #[lindex $::argv 2]


puts "Working on ${CASE}_${MESHSIZE} "


#Erase old output dirs and create new appropriate ones
set OUTDIRNAME "output_${CASE}_${MESHSIZE}_${nproc}_${max_unbalance}_${nsteps_balance}_${strategy}"
set INDIRNAME "model_${CASE}_${MESHSIZE}"

puts "Deleting directory $OUTDIRNAME"
file delete -force -- $OUTDIRNAME
puts "Creating directory $OUTDIRNAME"
file mkdir $OUTDIRNAME
file mkdir "${OUTDIRNAME}_disp"


 # ================================================================================================
 # ================================================================================================
 #  Read and create model
 # ================================================================================================
 # ================================================================================================


model BasicBuilder -ndm 2 -ndf 2
source "materials.tcl"

source "./${INDIRNAME}/${CASE}_${MESHSIZE}.drynodes.tcl"
source "./${INDIRNAME}/${CASE}_${MESHSIZE}.dryelements.tcl"

# model BasicBuilder -ndm 2 -ndf 3

# source "./${INDIRNAME}/${CASE}_${MESHSIZE}.wetnodes.tcl"
# source "./${INDIRNAME}/${CASE}_${MESHSIZE}.wetelements.tcl"
source "./${INDIRNAME}/${CASE}_${MESHSIZE}.fixities.tcl"
# source "./${INDIRNAME}/${CASE}_${MESHSIZE}.phreaticnodes.tcl"


set eles [getEleTags]
set nods [getNodeTags]
puts [open "${OUTDIRNAME}/elements.txt" w] "${eles}"
puts [open "${OUTDIRNAME}/nodes.txt" w] "${nods}"


# ================================================================================================
# ================================================================================================
#  Gravity stage with elastic material response
# ================================================================================================
# ================================================================================================
# For paraview:
# Displacement_X*iHat+Displacement_Y*jHat
# recorder pvd "${OUTDIRNAME}_disp" disp
# recorder Node -file "${OUTDIRNAME}/pressure.out" -time -node 1 -dof 3 vel
# record 

updateMaterialStage -material $soil_matTag -stage 0


set gamma           0.5
set beta            0.25
# constraints Transformation
constraints Plain
test        NormDispIncr 1e-7 40 2
algorithm   Newton
# algorithm   Linear
numberer    RCM


#Set appropriate SOE depending on whether running sequential or parallel
set rank [getPID]
set nproc [getNP]
if {$nproc == 1} {
    system      SparseGEN

    # system      UmfPack


} else {
    # system      Mumps
    partitioner MetisWithTopology

    if {$max_unbalance > 0} {
        balancer TopologicalBalancer $max_unbalance $nsteps_balance $strategy
    }
    recorder gmsh timing updatetime eleupdatetime
    system      SparseGEN -npRow 1 -npCol $nproc
}
# integrator  Newmark $gamma $beta

# Run gravity and print pressure at lower left corner to check for pressure convergence
set Nsteps 100
integrator LoadControl [expr 1./$Nsteps] 
analysis    Static
set pref [format {%0.2f} [expr 8. * 9.81 * 1] ]
for {set i 0} {$i < $Nsteps} {incr i} {

    set errflag [analyze     1];# 1e1]
    # set p1 [format {%0.2f} [nodeDisp 1 3] ]
    # set pv1 [format {%0.2f} [nodeVel 1 3] ]
    # puts "  P1 = $pv1 ($pref) "
    if {$errflag < 0} {
        puts "Failed on static!"
        exit 0 
    }
}

# exit 0 


# ================================================================================================
# ================================================================================================
#  Dynamic stage with elastoplastic material response
# ================================================================================================
# ================================================================================================


updateMaterialStage -material $soil_matTag -stage 1

proc listFromFile {filename} {
    set f [open $filename r]
    set data [split [string trim [read $f]]]
    close $f
    return $data
}
# set wetnodes [listFromFile "${INDIRNAME}/wetnodes.txt"]



set parameterchangestring "setParameter -val $nu_dynamic -ele ${eles}  poissonRatio 1"
puts $parameterchangestring
eval $parameterchangestring


setTime 0 
loadConst


#Set Recorders
recorder Node -node  11 -time -file ${OUTDIRNAME}/topnode.out -closeOnWrite -dof 1 2  disp
# set recstring "recorder Element -ele  ${eles} -time -file ${OUTDIRNAME}/stress.out  stress"
# eval $recstring
# set recstring "recorder Element -ele  ${eles} -time -file ${OUTDIRNAME}/strain.out  strain"
# eval $recstring
# set recstring "recorder Node -node  ${wetnodes} -time -file ${OUTDIRNAME}/pressure_all.out -dof 3 vel"
# eval $recstring
# set recstring "recorder Node -node  ${nods} -time -file ${OUTDIRNAME}/disp.out -dof 1 2 disp"
# eval $recstring


#Set loading (harmonic)
#timeSeries Trig $tag $tStart $tEnd $period <-factor $cFactor> <-shift $shift>

timeSeries   Trig   1     0.     5.    1.     -factor [expr $a0*9.81]
pattern UniformExcitation 1 1 -accel 1



wipeAnalysis

constraints Plain
test        NormDispIncr 1e-7 40 2
algorithm   Newton
numberer    RCM

# analysis    VariableTransient
# test        NormDispIncr 1e-7 40 0

set Nsteps 5000
# set Nsteps 1
system      SparseGEN -npRow 1 -npCol $nproc
integrator  Newmark $gamma $beta 
analysis    Transient
partitioner MetisWithTopology

if {$max_unbalance > 0} {
    balancer TopologicalBalancer $max_unbalance $nsteps_balance $strategy
}

puts "Start transient"
# analyze 1000 0.001
for {set i 0} {$i < $Nsteps} {incr i} {
    puts "Step $i (t = [getTime]s)"
    analyze 1 0.001 
    # analyze 1 0.001 0.0001 0.01 10
}
