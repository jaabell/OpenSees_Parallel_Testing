node 1 -1.0 0.0
fix 1 1 0
node 2 0.0 0.0
node 3 1.0 0.0
fix 3 1 0
node 4 -1.0 -1.0
fix 4 1 0
node 5 0.0 -1.0
node 6 1.0 -1.0
fix 6 1 0
node 7 -1.0 -2.0
fix 7 1 0
fix 7 0 1
node 8 0.0 -2.0
fix 8 0 1
node 9 1.0 -2.0
fix 9 1 0
fix 9 0 1
node 10 -1.0 -0.499999999999
fix 10 1 0
node 11 -1.0 -1.5
fix 11 1 0
node 12 -0.500000000002 -2.0
fix 12 0 1
node 13 0.499999999999 -2.0
fix 13 0 1
node 14 1.0 -1.5
fix 14 1 0
node 15 1.0 -0.500000000002
fix 15 1 0
node 16 0.500000000002 0.0
node 17 -0.499999999999 0.0
node 18 -0.500000000002 -1.0
node 19 0.499999999999 -1.0
node 20 0.0 -1.5
node 21 0.0 -0.500000000002
node 22 -0.5 -0.5
node 23 -0.500000000002 -1.5
node 24 0.499999999999 -1.5
node 25 0.5 -0.500000000002
element quad 17 1 10 22 17 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 18 17 22 21 2 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 19 10 4 18 22 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 20 22 18 5 21 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 21 4 11 23 18 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 22 18 23 20 5 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 23 11 7 12 23 1.0 PlaneStrain $matnum 0 1 0 -1;#$b2_dry
element quad 24 23 12 8 20 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 25 8 13 24 20 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 26 20 24 19 5 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 27 13 9 14 24 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 28 24 14 6 19 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 29 5 19 25 21 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 30 21 25 16 2 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 31 19 6 15 25 1.0 PlaneStrain $matnum 0 1 0 -1
element quad 32 25 15 3 16 1.0 PlaneStrain $matnum 0 1 0 -1


set topline [list 1 2 3 16 17 ]


set elements [list 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 ]
