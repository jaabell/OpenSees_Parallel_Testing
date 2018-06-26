#!/bin/bash

if [ "$#" -ne 5 ]; then
    echo "Usage: runcase.sh MESHSIZE NP UNBAL NSTEPS STRATEGY "
    exit
fi

MESHSIZE=$1
NP=$2
UNBAL=$3
NSTEPS=$4
STRATEGY=$5

host=$(hostname)

dir1="out_${host}_${MESHSIZE}_${NP}_${UNBAL}_${NSTEPS}_${STRATEGY}_BALANCE_NO"
dir2="out_${host}_${MESHSIZE}_${NP}_${UNBAL}_${NSTEPS}_${STRATEGY}_BALANCE_YES"
dir3="out_${host}_${MESHSIZE}_${NP}_${UNBAL}_${NSTEPS}_${STRATEGY}_BALANCE_YESSHM"

echo "Running main.tcl with parameters MESHSIZE=$MESHSIZE NP=$NP UNBAL=$UNBAL NSTEPS=$NSTEPS STRATEGY=$STRATEGY"
unset OPENSEES_USE_SHM

rm -rf $dir1
rm -rf $dir2
rm -rf $dir3

mkdir $dir1
mkdir $dir2
mkdir $dir3

#Run basic case with no rebalancing UNBAL set to 0
/usr/bin/time -o "${dir1}_systemtiming.txt" mpirun -np $NP pops main.tcl $MESHSIZE 0 $NSTEPS $STRATEGY
mv timing* $dir1
mv nodedisp*out $dir1

#Run case with rebalancing but without SHM optimization
/usr/bin/time -o "${dir2}_systemtiming.txt" mpirun -np $NP pops main.tcl $MESHSIZE $UNBAL $NSTEPS $STRATEGY
mv timing* $dir2
mv nodedisp*out $dir2

#Run case with rebalancing and SHM optimization
export OPENSEES_USE_SHM=True
/usr/bin/time -o "${dir3}_systemtiming.txt" mpirun -np $NP pops main.tcl $MESHSIZE $UNBAL $NSTEPS $STRATEGY
mv timing* $dir3
mv nodedisp*out $dir3

unset OPENSEES_USE_SHM
