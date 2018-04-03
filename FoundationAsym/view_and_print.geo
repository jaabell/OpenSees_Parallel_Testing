Printf ("NPARTS  = %.0f", NPARTS);
Printf ("PESO  = %.0f", PESO);
Printf ("NITER  = %.0f", NITER);


//NPARTS = 4;
For i In {0:(NPARTS-1)}
    Merge Sprintf("eleoutput.mesh.%.0f.msh", i);
EndFor

General.TrackballHyperbolicSheet = 1;
General.TrackballQuaternion0 = 0.3453665950247434;
General.TrackballQuaternion1 = 0.09104024188486744;
General.TrackballQuaternion2 = 0.1606793449308118;
General.TrackballQuaternion3 = 0.9201172411769946;
General.TranslationX = 0;
General.TranslationY = 0;
General.TranslationZ = 0;
Mesh.Color.Zero      = {  255 , 255   , 255  } ;
Mesh.Color.One       = {  235 , 235   , 235  } ;
Mesh.Color.Two       = {  215 , 215   , 215  } ;
Mesh.Color.Three     = {  195 , 195   , 195  } ;
Mesh.Color.Four      = {  175 , 175   , 175  } ;
Mesh.Color.Five      = {  155 , 155   , 155  } ;
Mesh.Color.Six       = {  135 , 135   , 135  } ;
Mesh.Color.Seven     = {  115 , 115   , 115  } ;
Mesh.Color.Eight     = {  95  , 95    , 95   } ;
Mesh.Color.Nine      = {  75  , 75    , 75   } ;
Mesh.Color.Ten       = {  55  , 55    , 55   } ;
Mesh.Color.Eleven    = {  35  , 35    , 35   } ;
Mesh.Color.Twelve    = {  15  , 15    , 15   } ;
Mesh.Color.Thirteen  = {  0   , 0  , 0   } ;
Mesh.Color.Fourteen  = {  0   , 0  , 0   } ;
Mesh.Color.Fifteen   = {  0   , 0  , 0   } ;
Mesh.Color.Sixteen   = {  0   , 0  , 0   } ;
Mesh.Color.Seventeen = {  0   , 0  , 0   } ;
Mesh.Color.Eighteen  = {  0   , 0  , 0   } ;
Mesh.Color.Nineteen  = {  0   , 0  , 0   } ;

Print Sprintf("nparts_%.0f_peso_%.0f_niter_%.0f.png", NPARTS,  PESO, NITER); 

Exit;