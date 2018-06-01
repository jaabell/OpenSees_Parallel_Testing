// Control parameters
is_h = Exists(h);

Printf ("Exists(h) = %f", is_h);

If (!Exists(h) )
    h = 8;
EndIf


//h = 16;            // [m] Element side length 
//h = 8;            // [m] Element side length 
//h = 4;            // [m] Element side length 

H1 = 8;            // Depth to rock at base of slope
H2 = 18;            // Depth to rock at top of slope
m = 0.5;            // Slope
m1 = 0.0;           // Slope at downhill
m2 = 0.0;           // Slope at tophill
mr = 0.0;           // Slope of rock stratum
L = 40;             // Horizontal distance to free field

vertical_offset = 0; // separate parts... useful to debug mesh

// Derived parameters
l = (H2-H1)/m;      // Horizontal length of slope

Nx1 = Ceil(L/h)+1;
Nx2 = Ceil(l/h)+1;
Nx3 = Ceil(0.5*L/h)+1;

Ny1 = Ceil(H1/h)+1;
Ny2 = Ceil((H2-H1)/h)+1;

Point(1)  = {0       , 0                , 0 , h};
Point(2)  = {L       , mr*L             , 0 , h};
Point(3)  = {L+l     , mr*(L+l)         , 0 , h};
Point(4)  = {1.5*L+l , mr*(L+l)         , 0 , h};
Point(5)  = {2*L+l   , mr*(2*L+l)       , 0 , h};

Point(6)  = {0       , H1               , 0 , h};

Point(7)  = {L       , H1+mr*L          , 0 , h};
Point(8)  = {L+l     , H1+mr*(L+l)      , 0 , h};
Point(9)  = {1.5*L+l , H1+mr*(L+l)      , 0 , h};
Point(10)  = {2*L+l   , H1+mr*(2*L+l)    , 0 , h};

Point(11) = {L+l     , H2+mr*(L+l)      , 0 , h};
Point(12) = {1.5*L+l , H2+mr*(L+l)+m2*L , 0 , h};
Point(13) = {2*L+l   , H2+mr*(L+l)+m2*L , 0 , h};

Point(14)  = {L       , H1+mr*L       +vertical_offset , 0 , h};
Point(15)  = {L+l     , H1+mr*(L+l)   +vertical_offset , 0 , h};
Point(16)  = {1.5*L+l , H1+mr*(L+l)   +vertical_offset , 0 , h};
Point(17)  = {2*L+l   , H1+mr*(2*L+l) +vertical_offset , 0 , h};

p7d = 14;
p8d = 15;
p9d = 16;
p10d = 17;



Printf ("Nx1 = %f ", Nx1);
Printf ("Nx2 = %f ", Nx2);
Printf ("Nx3 = %f ", Nx3);
Printf ("Ny1 = %f ", Ny1);
Printf ("Ny2 = %f ", Ny2);


l1  = 1;
l2  = 2;
l3  = 3;
l4  = 4;
l5  = 5;
l6  = 6;
l6d = 7;
l7  = 8;
l7d = 9;
l8  = 10;
l8d = 11;
l9  = 12;
l10 = 13;
l11 = 14;
l12 = 15;
l13 = 16;
l14 = 17;
l15 = 18;
l16 = 19;
l17 = 20;



//X-lines
Line(l1) = {1, 2};
Line(l2) = {2, 3};
Line(l3) = {3, 4};
Line(l4) = {4, 5};
Line(l5) = {6, 7};
Line(l6) = {7, 8};
Line(l6d) = {p7d, p8d};
Line(l7) = {8, 9};
Line(l7d) = {p8d, p9d};
Line(l8) = {9, 10};
Line(l8d) = {p9d, p10d};
Line(l9) = {11, 12};
Line(l10) = {12, 13};
Line(l11) = {1, 6};
Line(l12) = {5, 10};
Line(l13) = {p7d, 11};
Line(l14) = {p9d, 12};
Line(l15) = {p10d, 13};


Line Loop(1) = {l11, l5, l6, l7, l8, -l12, -l4, -l3, -l2, -l1};
Plane Surface(1) = {1};
Line Loop(2) = {l13, l9, -l14, -l7d, -l6d};
Plane Surface(2) = {2};
Line Loop(3) = {l14, l10, -l15, -l8d};
Plane Surface(3) = {3};

Lslope = Sqrt((H2-H1)^2 + l^2);
Nslope = Ceil(Lslope/h)+1;

Transfinite Line{l1, l5} = Nx1;

Transfinite Line{l2, l6, l6d} = Nx2;
//Transfinite Line{l2, l6} = Nx2;

Transfinite Line{l3, l4, l7, l7d, l8, l8d, l10} = Nx3;
//Transfinite Line{l3, l4, l7, l8, l10} = Nx3;


Transfinite Line{l11, l12} = Ny1;
Transfinite Line{l14, l15} = Ny2;


// Option 0
//refinement = 1;
//adjust = -1;
//Transfinite Line{l13} = refinement*Nslope + adjust;
//Transfinite Line{l9} = refinement*Nx3 ;

// Option 1
Transfinite Line{l9} = Nx2 + Nx3 -1 ;
Transfinite Line{l13} = Ny2;
Transfinite Surface {2} = {14, 16, 12, 11};

////Option 2
//Transfinite Line{l9} =  Nx3;
//Transfinite Line{l13} = Nx2;
//Transfinite Surface {2} = {14, 16, 12};


Transfinite Surface {1} = {1, 5, 10, 6};
Transfinite Surface {3} = {p9d, p10d, 13, 12};

Recombine Surface "*";

Periodic Line {l6d, l7d, l8d} = {l6, l7, l8};



Physical Surface("WetSoil") = {1};
Physical Surface("DrySoil") = {2, 3};
Physical Line("Sides") = {14, 15, 18};
Physical Line("Bottom") = {1, 2, 3, 4};
Physical Line("PhreaticLine") = {5, 6, 8, 10};
