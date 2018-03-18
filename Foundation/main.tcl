model BasicBuilder -ndm 3 -ndf 3


if {[llength $argv] > 0} {
    set PARALLEL [lindex $argv 0]
} else {
    set PARALLEL 0
}

source "units.tcl"
source "foundation.parameters.tcl"
source "foundation.nodes.tcl"
source "foundation.fixities.tcl"
source "foundation.materials.tcl"
source "foundation.elements.tcl"

# pattern Plain 1 "Linear" {
#     source "foundation.loads_gravity.tcl"
# }



# recorder gmsh output disp
recorder gmsh eleoutput eleResponse updatetime



if {$PARALLEL == 1} {
    system SparseGEN
    constraints Plain
    numberer Plain
} else {
    system UmfPack
    constraints Plain
    numberer RCM    
    set recid [recorder pvd disp disp]
}



# recorder Node -file "disps.out" -nodeRange 1 [llength [getNodeTags]] -time -dof 1 2 3 disp
# recorder Element -file "stresses.out" -eleRange 1 [llength [getEleTags]] -time stresses 
# recorder Element -file "time.out" -eleRange 1 [llength [getEleTags]] -time updatetime 



pattern Plain 1 "Linear" {
    source "foundation.loads_gravity.tcl"
}


test NormDispIncr 1.0e-6 25 1
algorithm Newton
# algorithm NewtonLineSearch -type Bisection
# algorithm ModifiedNewton
set Nsteps_grav 1

set first_step_factor 0.001

puts "Self weight stage Nsteps=$Nsteps_grav"
integrator LoadControl $first_step_factor 
analysis Static
analyze 1

exit 0



integrator LoadControl [expr (1-$first_step_factor)/$Nsteps_grav]
analyze $Nsteps_grav

if {$PARALLEL == 1} {
} else {
remove recorder $recid
}

loadConst
setTime 0.0


puts "Vertical loading stage"

if {$PARALLEL == 1} {
    
} else {
    recorder pvd disp2 disp
}

pattern Plain 2 "Linear" {
    source "foundation.loads_axial.tcl"
}


set Nsteps_load 50

integrator LoadControl $first_step_factor 
analysis Static
analyze 1

integrator LoadControl [expr (1-$first_step_factor)/$Nsteps_load]
analyze $Nsteps_load



# puts "Cyclic loading stage"

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
 
