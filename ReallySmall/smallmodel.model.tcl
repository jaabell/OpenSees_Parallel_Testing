node 1 -4.0 0.0
fix 1 1 1
node 2 0.0 0.0
fix 2 1 1
node 3 4.0 0.0
fix 3 1 1
node 4 -4.0 -4.0
fix 4 1 1
node 5 0.0 -4.0
node 6 4.0 -4.0
fix 6 1 1
node 7 -4.0 -8.0
fix 7 1 1
node 8 0.0 -8.0
fix 8 1 1
node 9 4.0 -8.0
fix 9 1 1
node 10 -4.0 -1.99999999999
fix 10 1 1
node 11 -4.0 -6.0
fix 11 1 1
node 12 -2.00000000001 -8.0
fix 12 1 1
node 13 1.99999999999 -8.0
fix 13 1 1
node 14 4.0 -6.0
fix 14 1 1
node 15 4.0 -2.00000000001
fix 15 1 1
node 16 2.00000000001 0.0
fix 16 1 1
node 17 -1.99999999999 0.0
fix 17 1 1
node 18 -2.00000000001 -4.0
node 19 1.99999999999 -4.0
node 20 0.0 -6.0
node 21 0.0 -2.00000000001
node 22 -2.0 -2.0
node 23 -2.00000000001 -6.0
node 24 1.99999999999 -6.0
node 25 2.0 -2.00000000001
element quad 17 1 10 22 17 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 18 17 22 21 2 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 19 10 4 18 22 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 20 22 18 5 21 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 21 4 11 23 18 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 22 18 23 20 5 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 23 11 7 12 23 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 24 23 12 8 20 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 25 8 13 24 20 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 26 20 24 19 5 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 27 13 9 14 24 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 28 24 14 6 19 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 29 5 19 25 21 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 30 21 25 16 2 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 31 19 6 15 25 1.0 PlaneStrain $matnum 0 0 $fx $fy
element quad 32 25 15 3 16 1.0 PlaneStrain $matnum 0 0 $fx $fy


set topline [list 1 2 3 16 17 ]


set elements [list 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 ]
