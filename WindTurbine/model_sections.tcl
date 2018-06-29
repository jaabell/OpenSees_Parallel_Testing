set sectag_Level1 1
set sectag_Level2 2
set sectag_Level3 3
set sectag_Level4 4
set sectag_Level5 5
set sectag_LevelAll 1

set matTag 1
set matPlateTag 2
set plateTag 1

# $K  bulk modulus
# $G  shear modulus
# $sig0   initial yield stress
# $sigInf final saturation yield stress
# $delta  exponential hardening parameter
# $H  linear hardening parameter

set K [expr $E_steel/(3*(1.-2*$nu_steel))]
set G [expr $E_steel/(2*(1.+$nu_steel))]

# set sig0   [expr 420*$MPa]
# set sigInf 0;#[expr 200.*$GPa]
# set delta 0.000
# set H [expr 0.1*$G]

set sig0   [expr 480*$MPa]
set sigInf [expr 420.*$GPa]
set delta 200
set H [expr 0.1*$G]


# nDMaterial ElasticIsotropic $matTag $E_steel $nu_steel $rho_steel

# puts "J2"
#nDMaterial J2Plasticity $matTag $K $G $sig0 $sigInf $delta $H

nDMaterial J2Plasticity $matTag $K $G $sig0 $sigInf $delta $H 0 $rho_steel

section PlateFiber $sectag_Level1 $matTag $thk_Level1
section PlateFiber $sectag_Level2 $matTag $thk_Level2
section PlateFiber $sectag_Level3 $matTag $thk_Level3
section PlateFiber $sectag_Level4 $matTag $thk_Level4
section PlateFiber $sectag_Level5 $matTag $thk_Level5

# nDMaterial J2Feap $matTag $K $G $sigInf $Hiso
# nDMaterial PlateFiber $matPlateTag $matTag

# section PlateFiber $sectag_Level1 $matPlateTag $thk_Level1
# section PlateFiber $sectag_Level2 $matPlateTag $thk_Level2
# section PlateFiber $sectag_Level3 $matPlateTag $thk_Level3
# section PlateFiber $sectag_Level4 $matPlateTag $thk_Level4
# section PlateFiber $sectag_Level5 $matPlateTag $thk_Level5

# exit 0
# print