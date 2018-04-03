Printf ("NPARTS  = %.0f", NPARTS);
Printf ("PESO  = %.0f", PESO);
Printf ("NITER  = %.0f", NITER);


//NPARTS = 4;
For i In {0:(NPARTS-1)}
    Merge Sprintf("eleoutput.mesh.%.0f.msh", i);
EndFor

Print Sprintf("nparts_%.0f_peso_%.0f_niter_%.0f.png", NPARTS,  PESO, NITER); 

Exit;