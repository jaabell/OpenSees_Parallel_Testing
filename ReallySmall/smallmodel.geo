LX = 4;
LY = 4;

h = 0.1;

Point(1) = { -LX , 0.    , 0. , h};
Point(2) = {   0 , 0.    , 0. , h};
Point(3) = {  LX , 0.    , 0. , h};
Point(4) = { -LX , -LY   , 0. , h};
Point(5) = {   0 , -LY   , 0. , h};
Point(6) = {  LX , -LY   , 0. , h};
Point(7) = { -LX , -2*LY , 0. , h};
Point(8) = {   0 , -2*LY , 0. , h};
Point(9) = {  LX , -2*LY , 0. , h};

//+
Line(1) = {1, 4};
//+
Line(2) = {4, 7};
//+
Line(3) = {7, 8};
//+
Line(4) = {8, 9};
//+
Line(5) = {9, 6};
//+
Line(6) = {6, 3};
//+
Line(7) = {3, 2};
//+
Line(8) = {2, 1};
//+
Line(9) = {4, 5};
//+
Line(10) = {5, 6};
//+
Line(11) = {8, 5};
//+
Line(12) = {5, 2};
//+
Line Loop(1) = {1, 9, 12, 8};
//+
Plane Surface(1) = {1};
//+
Line Loop(2) = {9, -11, -3, -2};
//+
Plane Surface(2) = {-2};
//+
Line Loop(3) = {11, 10, -5, -4};
//+
Plane Surface(3) = {-3};
//+
Line Loop(4) = {10, 6, 7, -12};
//+
Plane Surface(4) = {4};
//+
Transfinite Line {1,2,3,4,5,6,7,8,9,10,11,12} = 3;
Transfinite Surface {1,2,3,4};
Recombine Surface {1,2,3,4};


//+
Physical Line("Top") = {8, 7};
//+
Physical Line("Bottom") = {3, 4};
//+
Physical Surface("Soil") = {1, 4, 2, 3};
//+
Physical Line("Sides") = {1, 2, 6, 5};
