set E [expr 200.*$GPa]
set nu 0.3


set G0        125.   ;# [Adimensional]
set nu        0.3   ;# [Adimensional]
set e_init    0.673  ;# [Adimensional]! Chris, este se llamaba vR
set Mc        1.25   ;# [Adimensional]
set c         0.712  ;# [Adimensional]  1.0  #Circular deviatoric cross section
set lambda_c  0.019  ;# [Adimensional]
set e0        0.934  ;# [Adimensional]
set ksi       0.7    ;# [Adimensional]
set P_atm     100000.    ;# [kPa]
set m         0.01   ;# [Adimensional]
set h0        7.05   ;# [Adimensional]
set ch        0.968  ;# [Adimensional]
set nb        1.1    ;# [Adimensional]
set A0        0.704  ;# [Adimensional] ! Chris
set nd        3.5    ;# [Adimensional]
set z_max     4      ;# [Adimensional]
set cz        600    ;# [Adimensional]
set Den       $rho_Soil  ;# [Mg/m^3]

set E [expr 2*$G0*(1+$nu)*$P_atm]
set INT_ForwardEuler  5
set INT_ModifiedEuler 1
set INT_BackwardEuler 2
set INT_RungeKutta    3

set intScheme $INT_ModifiedEuler 
set TanType   1      ;#0: elastic stiffness, 1: continuum elastoplastic stiffness, 2: consistent elastoplastic stiffness 
set JacoType  1      ;#Just keep this value
set TolF      1.0e-10
set TolR      1.0e-10
set P_ref $P_atm
 
# nDMaterial ElasticIsotropic $mat_Soil_tag $E $nu $rho_Soil
nDMaterial ManzariDafalias $mat_Soil_tag $G0 $nu $e_init $Mc $c $lambda_c $e0 $ksi $P_atm $m $h0 $ch $nb $A0 $nd $z_max $cz $Den $intScheme $TanType $JacoType $TolF $TolR


set E [expr 200.*$GPa]
set nu 0.3


nDMaterial ElasticIsotropic $mat_Footing_tag $E $nu $rho_Footing
