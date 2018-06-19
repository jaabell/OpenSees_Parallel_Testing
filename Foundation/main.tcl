model BasicBuilder -ndm 3 -ndf 3

set rank [getPID]
set nproc [getNP]

puts "rank   =   $rank"
puts "nproc   =   $nproc"

source "units.tcl"
source "foundation.parameters.tcl"
source "foundation.nodes.tcl"
source "foundation.fixities.tcl"
source "foundation.materials.tcl"
source "foundation.elements.tcl"


# recorder gmsh output disp
recorder gmsh global updatetime
recorder gmsh eleoutput eleResponse updatetime



if {$nproc > 1} {
    # Parallel processing mode
    constraints Plain
    numberer Plain
    # system Mumps
    system SparseGEN
    partitioner MetisWithTopology
    balancer TopologicalBalancer
} else {
    # Sequential processing mode
    constraints Plain
    numberer RCM
    system UmfPack
}


updateMaterialStage -material $mat_Soil_tag -stage 0


test NormDispIncr 1.0e-6 25 2
algorithm Newton
set Nsteps_grav 1

set first_step_factor 0.001


puts "Self weight stage Nsteps=$Nsteps_grav"
integrator LoadControl $first_step_factor 
analysis Static
analyze 1

integrator LoadControl [expr (1-$first_step_factor)/$Nsteps_grav]
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
puts $parameterchangestring
eval $parameterchangestring

updateMaterialStage -material $mat_Soil_tag -stage 1


loadConst
setTime 0.0


puts "Vertical loading stage"

if {$nproc == 1} {
    # recorder pvd disp2 disp
}

pattern Plain 2 "Linear" {
    source "foundation.loads_axial.tcl"
}


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

loadConst
setTime 0.0

# timeSeries Triangle $tag $tStart $tEnd $period <-shift $shift> <-factor $cFactor>
timeSeries Triangle    10     0      10     1.0    -factor 0.1

pattern Plain 3 10 {
    source "foundation.loads_cyclic.tcl"
}

set dT 0.01
set tmax 4
set Nsteps [expr int($tmax/$dT)]
integrator LoadControl $dT

for {set step 0} {$step < $Nsteps} {incr step} {
    puts "Step $step of $Nsteps"
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
 
