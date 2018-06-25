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



#Initialize domain
model BasicBuilder -ndm 3 -ndf 6

set meshsize $MESHSIZE

# set meshsize obese
# set meshsize medium
# set meshsize fine

set shelltype 0
set elastictower 0
set a0 0.8

# if {[llength $::argv] != 4} {
#     puts "Usage: $::argv0 meshsize shelltype elastictower a0"
#     exit 0
# }

# set meshsize [lindex $::argv 0]
# set shelltype [lindex $::argv 1]
# set elastictower [lindex $::argv 2]
# set a0 [lindex $::argv 3]

set DIRNAME "model_turbine_${meshsize}/"

#Import model components
puts "Importing model..."
source "model_parameters.tcl"

set shellnames  [list ShellMITC4 ShellDKGQ ShellDKGT ShellNLDKGQ ShellNLDKGT ShellNL]
set shellnnodes [list     4          4         3          4           3         9]

set SHELLTYPE [lindex $shellnames $shelltype]
set NNODESSHELL [lindex $shellnnodes $shelltype]



source "${DIRNAME}/turbine_nodes.tcl"
source "${DIRNAME}/turbine_fixities.tcl"
source "${DIRNAME}/turbine_elastic_shells.tcl"

if {$elastictower} {
    puts "  ++Elastic tower"
    source "${DIRNAME}/turbine_towershellsE.tcl"
} else {
    puts "  ++Nonlinear tower"
    source "model_sections.tcl"
    if {$NNODESSHELL == 3} {
        puts "  ++Triangle shell = $SHELLTYPE"
        source "${DIRNAME}/turbine_towershellsT.tcl"
    } else {
        puts "  ++Quadrilateral shell = $SHELLTYPE"
        source "${DIRNAME}/turbine_towershellsQ.tcl"
    }
}

# exit 0

source "${DIRNAME}/turbine_beams.tcl"
source "${DIRNAME}/turbine_pointmasses.tcl"

# timeSeries Trig $tag $tStart $tEnd $period <-factor $cFactor> <-shift $shift>
timeSeries   Trig   1     0.     3.    1.     -factor [expr $a0*9.81]
pattern UniformExcitation 1 1 -accel 1

set pi 3.14159
set w1 [expr 2*$pi*0.3]
set w2 [expr 2*$pi*4]

set zeta 0.025;     # percentage of critical damping
set a0 [expr $zeta*2.0*$w1*$w2/($w1 + $w2)];    # mass damping coefficient based on first and second modes
set a1 [expr $zeta*2.0/($w1 + $w2)];            # stiffness damping coefficient based on first and second modesSee Zareian & Medina 2010.

rayleigh $a0 $a1 0. 0.  

puts "Setup analysis..."


recorder Node -file "disp_nacelle.out" -time -node $NacelleNode -dof 1 2 3 4 5 6 disp
recorder Node -file "velo_nacelle.out" -time -node $NacelleNode -dof 1 2 3 4 5 6 vel
recorder Node -file "accel_nacelle.out" -time -node $NacelleNode -dof 1 2 3 4 5 6 accel


# print

# Displacement_XX*iHat+Displacement_YY*jHat+Displacement_ZZ*kHat

set rank [getPID]
set nproc [getNP]

if {$nproc > 1} {
    recorder gmsh timing updatetime eleupdatetime
    # recorder gmsh disp disp
} else {
    recorder pvd disp disp
}

#Setup analysis
# constraints Transformation
constraints Plain
# numberer RCM
numberer Plain



if {$nproc > 1} {
    system SparseGEN -npRow 1 -npCol $nproc
} else {
    system UmfPack
}
test NormDispIncr  1e-6 10 0
algorithm Newton
integrator Newmark 0.5 0.25
analysis Transient
if {$nproc > 1} {
    partitioner MetisWithTopology
    if {$max_unbalance > 0} {
        balancer TopologicalBalancer $max_unbalance $nsteps_balance $strategy
    }
}


set NSTEPS 600

puts "Start transient..."
# analyze 1000 0.01
for {set i 0} {$i < $NSTEPS} {incr i} {
    puts "Step $i"
    analyze 1 0.01
}
