//+
SetFactory("OpenCASCADE");



factor = 3*(h^(1/3));



dx = 0.2*factor;
N1 = Ceil(20/factor);
N2 = Ceil(10/factor);

LX1 = N1*dx;
LY1 = N1*dx;
LZ1 = N1*dx;

LX2 = N2*dx;
LY2 = N2*dx;
LZ2 = dx;

Nl =5;


Point(1) = {-LX2/2,-LY2/2, LZ1 + LZ2};//+
Extrude {LX2, 0, 0} {
  Point{1}; 
  Layers{N2};
  Recombine;
}
//+
Extrude {0, LY2, 0} {
  Line{1}; 
  Layers{N2};
  Recombine;
}
//+
Extrude {0, 0, -LZ2} {
  Surface{1}; 
  Layers{1};
  Recombine;
}

//+
Extrude {0, 0, -LZ1} {
  Surface{6}; 
  Layers{N1};
  Recombine;
}
//+
Extrude {LX1, 0, 0} {
  Surface{8}; 
  Layers{N1};
  Recombine;
}



//+
Extrude {-LX1, 0, 0} {
  Surface{7}; 
  Layers{N1};
  Recombine;
}
//+
Extrude {0, -LY1, 0} {
  Surface{17}; Surface{9}; Surface{12}; 
  Layers{N1};
  Recombine;
}
//+
Extrude {0, LY1, 0} {
  Surface{13}; Surface{10}; Surface{18}; 
    Layers{N1};
    Recombine;
}
//+
Physical Surface("Bottom") = {32, 15, 36, 29, 23, 11, 20, 42, 45};
//+
Physical Surface("SidesX") = {33, 16, 38, 25, 21, 46};
//+
Physical Surface("SidesY") = {26, 30, 34, 39, 43, 47};
//+
Physical Surface("Top") = {31, 28, 22, 19, 44, 41, 35, 14};

Physical Surface("FoundationBottom") = {6};
//+
Physical Surface("FoundationTop") = {1};
//+
Physical Volume("Soil") = {7, 3, 6, 8, 2, 5, 9, 4, 10};
//+
Physical Volume("Footing") = {1};
//+
Physical Point("CornersLeft") = {1, 2};
Physical Point("CornersRight") = {4, 3};
