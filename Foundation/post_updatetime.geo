Merge "./out_grond_coarse_4_0.1_5_3_BALANCE_YES/timing.mesh.0.msh";
Merge "./out_grond_coarse_4_0.1_5_3_BALANCE_YES/timing.mesh.1.msh";
Merge "./out_grond_coarse_4_0.1_5_3_BALANCE_YES/timing.mesh.2.msh";
Merge "./out_grond_coarse_4_0.1_5_3_BALANCE_YES/timing.mesh.3.msh";
Merge "./out_grond_coarse_4_0.1_5_3_BALANCE_YES/timing.eleupdatetime.0.msh";
Merge "./out_grond_coarse_4_0.1_5_3_BALANCE_YES/timing.eleupdatetime.1.msh";
Merge "./out_grond_coarse_4_0.1_5_3_BALANCE_YES/timing.eleupdatetime.2.msh";
Merge "./out_grond_coarse_4_0.1_5_3_BALANCE_YES/timing.eleupdatetime.3.msh";

//Updatetimes
View[0].Visible=1;
View[2].Visible=1;
View[4].Visible=1;
View[6].Visible=1;

//Partitions
View[1].Visible=0;
View[3].Visible=0;
View[5].Visible=0;
View[7].Visible=0;

For i In {1:7:2}
    //View[i].CustomMax=3;
    //View[i].CustomMin=0;
    //View[i].RangeType=2;    
    View[i].LightTwoSide=1;    
    View[i].ShowElement=1;    
    View[i].ShowScale=0;    
EndFor

View[0].ShowTime=1;

Mesh.Lines=0;
Mesh.SurfaceEdges=0;
Mesh.SurfaceFaces=0;
Mesh.VolumeFaces=0;
Mesh.VolumeEdges=0;

Merge "post_updatetime.geo.opt";

frames = 251;

Print.Background = 1;

// It is possible to nest loops:
For t In {0:frames}

    View[0].TimeStep = t;
    View[2].TimeStep = t;
    View[4].TimeStep = t;
    View[6].TimeStep = t;

    //General.RotationX += 10;
    //General.RotationY = General.RotationX / 3;
    //General.RotationZ += 0.1;

    //Sleep 0.01; // sleep for 0.01 second
    Draw; // draw the scene (one could use DrawForceChanged instead to force the
      // reconstruction of the vertex arrays, e.g. if changing element
      // clipping)

  // The `Print' command saves the graphical window; the `Sprintf' function
  // permits to create the file names on the fly:
  //Print Sprintf("t8-%02g.gif", t);
  //Print Sprintf("t8-%02g.ppm", t);
  Print Sprintf("./partmov/partmov2-%03g.png", t);

EndFor