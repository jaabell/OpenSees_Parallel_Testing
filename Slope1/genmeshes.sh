#!/bin/bash

case="slope01"

gmsh -setnumber h 4 -2 ${case}.geo -o  "./meshes/"${case}_coarse.msh
gmsh -setnumber h 1.26491 -2 ${case}.geo -o  "./meshes/"${case}_medium.msh
gmsh -setnumber h 0.40000 -2 ${case}.geo -o  "./meshes/"${case}_fine.msh

rm -rf "./model_${case}_coarse"
rm -rf "./model_${case}_medium"
rm -rf "./model_${case}_fine"

mkdir "./model_${case}_coarse"
mkdir "./model_${case}_medium"
mkdir "./model_${case}_fine"

python gmsh2ops_dry.py $case coarse
python gmsh2ops_dry.py $case medium
python gmsh2ops_dry.py $case fine