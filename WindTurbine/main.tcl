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
set PGA 1.5

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
#                          0         1         2         3          4          5
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

set f 1.6778170479140695  ;# hit the resonant frequency  Period = 0.59601   peaks at t = 0.14900,  0.44701, 0.74501, 1.04302, 1.34102, 1.63903  (end at T= 1.78803)
set Period [expr 1/$f]    ;# hit the resonant frequency
set NPeriods 3           ;# how many periods to do
set tEnd [expr $NPeriods*$Period]

puts "Loading info"
puts "========================================"
puts "f=$f"
puts "Period=$Period"
puts "NPeriods=$NPeriods"
puts "tEnd=$tEnd"
puts "PGA=$PGA"


# timeSeries Trig $tag $tStart $tEnd $period <-factor $cFactor> <-shift $shift>
# timeSeries   Trig   1     0.     $tEnd    $Period     -factor 1
timeSeries Path 1 -dt 0.001 -filePath "acc2.txt" 
pattern UniformExcitation 1 1 -accel 1 


set pi 3.14159
set w1 [expr 2*$pi*0.3]
set w2 [expr 2*$pi*4]

set zeta 0.025;     # percentage of critical damping
set a0 [expr $zeta*2.0*$w1*$w2/($w1 + $w2)];    # mass damping coefficient based on first and second modes
set a1 [expr $zeta*2.0/($w1 + $w2)];            # stiffness damping coefficient based on first and second modesSee Zareian & Medina 2010.

puts "Rayleigh info"
puts "========================================"
puts "w1=$w1"
puts "w2=$w2"
puts "zeta=$zeta"
puts "a0=$a0"
puts "a1=$a1"

rayleigh $a0 $a1 0. 0.  

puts "Setup analysis..."


recorder Node -file "disp_nacelle.out" -time -node $NacelleNode -dof 1 2 3 4 5 6 disp
recorder Node -file "velo_nacelle.out" -time -node $NacelleNode -dof 1 2 3 4 5 6 vel
recorder Node -file "accel_nacelle.out" -time -node $NacelleNode -dof 1 2 3 4 5 6 accel


# print


set rank [getPID]
set nproc [getNP]

# 2.50000

if {$nproc > 1} {
    recorder gmsh timing updatetime eleupdatetime
    # recorder gmsh disp disp
} else {
    # Displacement_XX*iHat+Displacement_YY*jHat+Displacement_ZZ*kHat
    recorder pvd disp disp
    # sqrt(UnknownMovableObjectstresses_0^2+UnknownMovableObjectstresses_1^2+UnknownMovableObjectstresses_2^2)
    # sqrt(UnknownMovableObjectmaterial1fiber1stresses_0^2+UnknownMovableObjectmaterial1fiber1stresses_1^2+UnknownMovableObjectmaterial1fiber1stresses_2^2)
    # sqrt(UnknownMovableObjectmaterial1fiber1stresses_0^2+UnknownMovableObjectmaterial1fiber1stresses_1^2+UnknownMovableObjectmaterial1fiber1stresses_2^2)
    recorder pvd stresses eleResponse material 1 fiber 1 stresses
    # sqrt(UnknownMovableObjectstresses_0^2+UnknownMovableObjectstresses_1^2+UnknownMovableObjectstresses_2^2)
    recorder pvd strains eleResponse material 1 fiber 1 strains
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
test NormDispIncr  1e-6 200 2
algorithm Newton 
# algorithm ModifiedNewton 
# algorithm SecantNewton 
# algorithm NewtonLineSearch -type Bisection
# algorithm NewtonLineSearch 
# algorithm BFGS
# algorithm Broyden 5

# algorithm NewtonLineSearch -type Bisection
integrator Newmark 0.5 0.25
analysis Transient
# analysis VariableTransient
if {$nproc > 1} {
    partitioner MetisWithTopology
    if {$max_unbalance > 0} {
        balancer TopologicalBalancer $max_unbalance $nsteps_balance $strategy
    }
}


if {$nproc == 1} {
    #Perform eigen analysis
    puts "\n---> Eigenanalysis"
    set eigvals [eigen  $Nmodes]

    #Postproc eigenvalues
    set w_vec [list]
    set f_vec [list]
    set T_vec [list]

    set fid [open "eigenfrequencies.txt" w]

    set pi 3.14159
    set mode 1
    foreach w2 $eigvals {
        set w [expr sqrt($w2)]
        set f [expr $w/2/$pi]
        set T [expr 1/$f]
        puts "Mode $mode"
        # puts "   w = $w"
        puts "   f = $f"
        # puts "   T = $T"
        incr mode

        #Write to file
        puts $fid "$f"
    }
}

set nincr 20
set NSTEPS [expr 600/$nincr]

# 24.52500
# exit

puts "Start transient..."
# analyze 1000 0.01
for {set i 0} {$i < $NSTEPS} {incr i} {
    puts "Step $i t = [getTime]"
    # set err [analyze $nincr 0.01 0.0001 0.02 6]
    set err [analyze $nincr 0.01]
    if {$err != 0} {
        puts "....failure"
        exit 0
    }
}
