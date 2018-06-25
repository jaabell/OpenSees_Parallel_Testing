model BasicBuilder -ndm 3 -ndf 3

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

puts "Reading units.tcl"
source "units.tcl"
puts "Reading parameters.tcl"
source "parameters.tcl"
puts "Reading materials.tcl"
source "materials.tcl"

puts "Reading ./model_foundation_${MESHSIZE}/foundation_${MESHSIZE}.nodes.tcl"
source "./model_foundation_${MESHSIZE}/foundation_${MESHSIZE}.nodes.tcl"
puts "Reading ./model_foundation_${MESHSIZE}/foundation_${MESHSIZE}.fixities.tcl"
source "./model_foundation_${MESHSIZE}/foundation_${MESHSIZE}.fixities.tcl"
puts "Reading ./model_foundation_${MESHSIZE}/foundation_${MESHSIZE}.elements.tcl"
source "./model_foundation_${MESHSIZE}/foundation_${MESHSIZE}.elements.tcl"


# recorder gmsh output disp
recorder gmsh timing updatetime
# recorder gmsh eleoutput eleResponse updatetime

# recorder Node -closeOnWrite -file "nodedisp.out" -time -node 1 -dof 1 2 3 disp

if {$nproc > 1} {
    # Parallel processing mode
    constraints Plain
    numberer Plain
    #system Mumps
    system SparseGEN -npRow 1 -npCol $nproc
    partitioner MetisWithTopology

    if {$max_unbalance > 0} {
        balancer TopologicalBalancer $max_unbalance $nsteps_balance $strategy
    }
} else {
    # Sequential processing mode
    constraints Plain
    numberer RCM
    system UmfPack
}


updateMaterialStage -material $mat_Soil_tag -stage 0


test NormDispIncr 1.0e-6 50 2
algorithm Newton
set Nsteps_grav 1

set first_step_factor 0.001


# timeSeries Triangle $tag $tStart $tEnd $period <-shift $shift> <-factor $cFactor>
# timeSeries Triangle    5     1      10     4.0    -factor 1.0
timeSeries Path 5 -time [list 0 1 2 10000] -values [list 0 0 1 1]  -factor 1.0

pattern Plain 2 5 {
    source "./model_foundation_${MESHSIZE}/foundation_${MESHSIZE}.loads_axial.tcl"
}

# timeSeries Path tag -time list_of_times -values list_of_values <-factor cFactor>
timeSeries Path 10 -time [list 0 2 2.25 2.50 2.75 3 3.25 3.50 3.75 4 4.25 4.50 4.75 5] -values [list 0 0 1 0 -1 0 1 0 -1 0 1 0 -1 0 ] -factor 2.0
# timeSeries Triangle $tag $tStart $tEnd $period <-shift $shift> <-factor $cFactor>
# timeSeries Triangle    10     2      10     1.0    -factor 0.5

pattern Plain 3 10 {
    source "./model_foundation_${MESHSIZE}/foundation_${MESHSIZE}.loads_cyclic.tcl"
}



puts "Self weight stage Nsteps=$Nsteps_grav"
integrator LoadControl [expr 1./$Nsteps_grav]
analysis Static
set errflag [analyze $Nsteps_grav]


puts "Done self weight"


if {$errflag != 0} {
    puts "Self weight failed!"
    exit 0
} else {
    puts "Self weight finished successfully!"
}

set nu_dynamic 0.05
set parameterchangestring "setParameter -val $nu_dynamic -ele ${eles}  poissonRatio 1"
# puts $parameterchangestring
eval $parameterchangestring

updateMaterialStage -material $mat_Soil_tag -stage 1


# loadConst
# setTime 0.0


puts "Vertical loading stage"


set Nsteps_load 50

integrator LoadControl $first_step_factor 
set errflage [analyze 1]


if {$errflag != 0} {
    puts "First step vertical failed!"
    exit 0
}

integrator LoadControl [expr (1-$first_step_factor)/$Nsteps_load]


set errflag [analyze $Nsteps_load]

if {$errflag != 0} {
    puts "Vertical failed!"
    exit 0
} else {
    puts "Vertical finished successfully!"
}




puts "Cyclic loading stage"

# loadConst
# setTime 0.0



set dT 0.01
set tmax 2
set Nsteps [expr int($tmax/$dT)]
integrator LoadControl $dT

for {set step 0} {$step < $Nsteps} {incr step} {
    puts "\n\n\n"
    puts "Step $step of $Nsteps"
    puts [nodeDisp 1]
    set errrfalg [analyze 1]
    if {$errrfalg != 0} {
        break
    }
}

# set dT 1.
# set numStep 100
# # Analyze and use substepping if needed
# set curStep 0
# set remStep $numStep
# set success 0
# integrator  LoadControl $dT
# proc subStepAnalyze {dT subStep} {
#     if {$subStep > 4} {
#         return -10
#     }
#     for {set i 1} {$i < 3} {incr i} {
#         puts "Try dT = $dT"
#         # set success [analyze 1 $dT]
#         integrator  LoadControl $dT
#         set success [analyze 1]
#         if {$success != 0} {
#             set success [subStepAnalyze [expr $dT/2.0] [expr $subStep+1]]
#             if {$success == -10} {
#                 puts "Did not converge. substep > $subStep"
#                 return -10
#             }
#         } else {
#             if {$i==1} {
#                 puts "Substep $subStep : Left side converged with dT = $dT"
#             } else {
#                 puts "Substep $subStep : Right side converged with dT = $dT"
#             }
#         }
#     }
#     return success
# }
 
# puts "Start analysis"
# set startT [clock seconds]

# while {$success != -10} {
#     set subStep 0
#     set success [analyze $remStep  $dT]
#     if {$success == 0} {
#         puts "Analysis Finished"
#         break
#     } else {
#         set curTime  [getTime]
#         puts "Analysis failed at $curTime . Try substepping."
#         set success  [subStepAnalyze [expr $dT/2.0] [incr subStep]]
#         set curStep  [expr int(($curTime-20000)/$dT + 1)]
#         set remStep  [expr int($numStep-$curStep)]
#         puts "Current step: $curStep , Remaining steps: $remStep"
#     }
# }
# set endT [clock seconds]
# puts "loading analysis execution time: [expr $endT-$startT] seconds."
 
