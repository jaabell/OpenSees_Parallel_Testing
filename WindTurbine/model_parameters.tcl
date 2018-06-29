

#Compute this number of modes
set Nmodes 10


# --------------------------------------------------------------------------------------------------
#Units
# --------------------------------------------------------------------------------------------------

set m 1.
set kg 1.
set s 1.
set mm [expr 1e-3*$m]
set inch  [expr 0.0254*$m]

set N [expr $m*$kg/$s/$s]

set Pa [expr $N/$m/$m]
set kPa [expr 1e3*$Pa]
set MPa [expr 1e6*$Pa]
set GPa [expr 1e9*$Pa]

set kgmm3 [expr $kg/$mm/$mm/$mm]
set kgm3 [expr $kg/$m/$m/$m]

set factor 1.; #[expr 300/373.304241737] ;#  So that blades weigh about 300kg.

# --------------------------------------------------------------------------------------------------
# Blades
# --------------------------------------------------------------------------------------------------

set nu_composites 0.3

set thk_Atiesador1 [expr 10*$mm*$factor]
set thk_Atiesador2 [expr 10*$mm*$factor]
set thk_Snit1 [expr 10*$mm*$factor]
set thk_Snit2 [expr 10*$mm*$factor]
set thk_AlasViga [expr 20*$mm*$factor]
set thk_EntreVigas [expr 10*$mm*$factor]
set thk_LeadingEdge [expr 10*$mm*$factor]
set thk_Intermedio [expr 12*$mm*$factor]
set thk_TrailingEdge [expr 10*$mm*$factor]
set thk_Tip [expr 20*$mm*$factor]

set E_Atiesador1    [expr 9.500*$GPa]  
set E_Atiesador2    [expr 9.500*$GPa]  
set E_Snit1         [expr 34.413*$GPa] 
set E_Snit2         [expr 34.413*$GPa] 
set E_AlasViga      [expr 22.838*$GPa] 
set E_EntreVigas    [expr 32.360*$GPa] 
set E_LeadingEdge   [expr 10.000*$GPa] 
set E_Intermedio    [expr 20.000*$GPa] 
set E_TrailingEdge  [expr 34.413*$GPa] 
set E_Tip           [expr 10.000*$GPa] 

set nu_Atiesador1     $nu_composites
set nu_Atiesador2     $nu_composites
set nu_Snit1          $nu_composites
set nu_Snit2          $nu_composites
set nu_AlasViga       $nu_composites
set nu_EntreVigas     $nu_composites
set nu_LeadingEdge    $nu_composites
set nu_Intermedio     $nu_composites
set nu_TrailingEdge   $nu_composites
set nu_Tip            $nu_composites

set rho_Atiesador1    [expr  1.46e-6*$kgmm3]
set rho_Atiesador2    [expr  1.46e-6*$kgmm3]
set rho_Snit1         [expr 1.84e-6*$kgmm3]
set rho_Snit2         [expr 1.84e-6*$kgmm3]
set rho_AlasViga      [expr 1.79e-6*$kgmm3]
set rho_EntreVigas    [expr 1.69e-6*$kgmm3]
set rho_LeadingEdge   [expr 1.46e-6*$kgmm3]
set rho_Intermedio    [expr 1.69e-6*$kgmm3]
set rho_TrailingEdge  [expr 1.84e-6*$kgmm3]
set rho_Tip           [expr 1.69e-6*$kgmm3]

# --------------------------------------------------------------------------------------------------
# Tower
# --------------------------------------------------------------------------------------------------

set nu_steel 0.25
set E_steel         [expr 200.*$GPa ]  
set rho_steel         [expr 7800.*$kgm3]

set thk_Consola [expr 76*$mm*$factor]
set thk_Level1 [expr 6*$mm*$factor]
set thk_Level2 [expr 6*$mm*$factor]
set thk_Level3 [expr 6*$mm*$factor]
set thk_Level4 [expr 6*$mm*$factor]
set thk_Level5 [expr 6*$mm*$factor]

set E_Consola $E_steel
set E_Level1 $E_steel;#[expr $E_steel*1.4]
set E_Level2 $E_steel
set E_Level3 $E_steel
set E_Level4 $E_steel
set E_Level5 $E_steel

set nu_Consola $nu_steel
set nu_Level1 $nu_steel
set nu_Level2 $nu_steel
set nu_Level3 $nu_steel
set nu_Level4 $nu_steel
set nu_Level5 $nu_steel

set rho_Consola $rho_steel
set rho_Level1 $rho_steel
set rho_Level2 $rho_steel
set rho_Level3 $rho_steel
set rho_Level4 $rho_steel
set rho_Level5 $rho_steel

# --------------------------------------------------------------------------------------------------
# Point masses at nacelle
# --------------------------------------------------------------------------------------------------
# M_blade1 = 303.  #kg
# M_blade2 = 308.  #kg
# M_blade3 = 333.  #kg
set NacelleMass  2400.
set HubMass 916.
set GearBoxMass [expr 0.4*$NacelleMass]
set GeneratorMass [expr 0.6*$NacelleMass]
set inch [expr 0.0254]
set feet [expr 12*$inch]
set ConsolaLy [expr (4*$feet+10*$inch)/2]
set ConsolaLx [expr (91*$inch)/2]
set VolConsola [expr 4*$thk_Consola*$ConsolaLy*$ConsolaLx]

set rho_Consola [expr $rho_Consola + ($GearBoxMass+$GeneratorMass+$HubMass)/$VolConsola]


# --------------------------------------------------------------------------------------------------
# Beams at Nacelle and hub (mainly rigid)
# --------------------------------------------------------------------------------------------------
set pi 3.14159
set beam_r [expr 8.5*$inch]
set beam_esp [expr 8*$mm]
set beam_A [expr $pi*(pow($beam_r, 2) - pow($beam_r - $beam_esp, 2))]
set beam_E [expr 200*$GPa]
set beam_G [expr $beam_E/(2*(1-$nu_steel))]
set beam_J [expr $pi*(pow($beam_r, 4) - pow($beam_r - $beam_esp, 4))/4.]
set beam_Iy [expr $beam_J/2]
set beam_Iz [expr $beam_J/2]