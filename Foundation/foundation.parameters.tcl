set mat_Soil_tag 1
set mat_Footing_tag 2
set rho_Soil [expr 1584*$kg/$m3]
set rho_Footing [expr 2700*$kg/$m3]
set Df [expr 0.5*$mts]
set B 2.
set L 2.
set Area [expr $B*$L]
set qx0 [expr 0*$KPa*$Area]
set qy0 [expr 0*$KPa*$Area]
set qz0 [expr 5*$KPa*$Area]
set qx  [expr 0*$KPa*$Area]
set qy  [expr 0*$KPa*$Area]
set qz  [expr 3*$KPa*$Area]
set q  [expr $rho_Soil * $gz * $Df]
set b1_Soil [expr -$rho_Soil * $gx]
set b2_Soil [expr -$rho_Soil * $gy]
set b3_Soil [expr -$rho_Soil * $gz]
set b1_Footing [expr -$rho_Footing * $gx]
set b2_Footing [expr -$rho_Footing * $gy]
set b3_Footing [expr -$rho_Footing * $gz]
# set BRICKTYPE stdBrick
set BRICKTYPE SSPBrick
