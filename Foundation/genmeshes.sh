#!/bin/bash

case="foundation"

gmsh -setnumber h 2 -3 ${case}.geo -o  "./meshes/"${case}_coarse.msh
gmsh -setnumber h 0.2 -3 ${case}.geo -o  "./meshes/"${case}_medium.msh
gmsh -setnumber h 0.02 -3 ${case}.geo -o  "./meshes/"${case}_fine.msh
# gmsh -setnumber h 0.001 -3 ${case}.geo -o  "./meshes/"${case}_superfine.msh

rm -rf "./model_${case}_coarse"
rm -rf "./model_${case}_medium"
rm -rf "./model_${case}_fine"
# rm -rf "./model_${case}_superfine"

mkdir "./model_${case}_coarse"
mkdir "./model_${case}_medium"
mkdir "./model_${case}_fine"
# mkdir "./model_${case}_superfine"

python gmsh2ops.py $case coarse
python gmsh2ops.py $case medium
python gmsh2ops.py $case fine
# python gmsh2ops.py $case superfine

echo "NUMBER OF NODES===="
tail -n 1 model_foundation_*/foundation_*.nodes.tcl
# echo "NUMBER OF ELEMENTS===="
# tail -n 1 model_foundation_*/foundation_*.elements.tcl