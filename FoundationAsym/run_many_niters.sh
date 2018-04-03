#!/bin/bash

./clean.sh

NITERMAX=30
NITERSTEP=1
PESO=$1
NPARTS=4
echo "Bash version ${BASH_VERSION}..."
NITERLIST=(00 01 05 10 50)
pesofile="pesos"$PESO".txt"
echo "pesofile = ${pesofile}"
echo "PESO = ${PESO}"
echo "NPARTS = ${NPARTS}"


# for (( NITER=0; NITER<=NITERMAX; NITER+=NITERSTEP ))
for NITER in "${NITERLIST[@]}"
do
    echo "NITER = $NITER"
    echo "${NITER}" > niter.metis.option
    cat niter.metis.option $pesofile > inputs.txt
    mpirun -np $NPARTS pops main.tcl < inputs.txt  2> log
    
    evalstring="gmsh view_and_print.geo -setnumber NPARTS $NPARTS -setnumber NITER $NITER -setnumber PESO $PESO"
    echo "evalstring = ${evalstring}"
    eval $evalstring
done