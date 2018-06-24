set G0        150.   ;# [Adimensional]
set nu_static        0.25   ;# [Adimensional]
set nu_dynamic        0.05   ;# [Adimensional]
set e_init    0.5862 ;# [Adimensional]! Chris, este se llamaba vR
set Mc        1.14   ;# [Adimensional]
set c         0.78   ;# [Adimensional]
set lambda_c  0.027  ;# [Adimensional]
set e0        0.83   ;# [Adimensional]
set ksi       0.45   ;# [Adimensional]
set P_atm     100    ;# [kPa]
set m         0.02   ;# [Adimensional]
set h0        9.7    ;# [Adimensional]
set ch        1.02   ;# [Adimensional]
set nb        2.56   ;# [Adimensional]
set A0        0.81   ;# [Adimensional] ! Chris
set nd        1.05   ;# [Adimensional]
set z_max     5      ;# [Adimensional]
set cz        800    ;# [Adimensional]
set Den       1.683  ;# [Mg/m^3]

set INT_ModifiedEuler 1
set INT_BackwardEuler 2
set INT_RungeKutta    3
set INT_ForwardEuler  5

# set intScheme $INT_ModifiedEuler
set intScheme $INT_BackwardEuler
set TanType   2      ;#0: elastic stiffness, 1: continuum elastoplastic stiffness, 2: consistent elastoplastic stiffness 
# set TanType   1      ;#0: elastic stiffness, 1: continuum elastoplastic stiffness, 2: consistent elastoplastic stiffness 
set JacoType  1
set TolF      1.0e-10
set TolR      1.0e-10

set fBulk 2.2e6 
set fDen 1.
set k1 1.0e-3 
set k2 1.0e-3 
set void 0.7 
set alpha 6.0e-5 

set b1_dry 0.0
set b2_dry [expr -9.81*$Den]
set b1_wet 0.0
set b2_wet -9.81

set soil_matTag 1

nDMaterial ManzariDafalias $soil_matTag $G0 $nu_static $e_init $Mc $c $lambda_c $e0 $ksi $P_atm $m $h0 $ch $nb $A0 $nd $z_max $cz $Den $intScheme $TanType $JacoType $TolF $TolR
