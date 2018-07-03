#!/bin/bash

if [ "$#" -ne 7 ]; then
    echo "Usage: leftrarun.sh  MESHSIZE UNBAL NSTEPS STRATEGY PARTLEVEL NPLIST TIMEREQ "
    echo "Example: "
    echo "sh leftrarun.sh coarse 0.1 5 3 1 \"1 2 3\" \"00:10:00\""
    echo "narg = $#"
    exit
fi

MESHSIZE=$1
UNBAL=$2
NSTEPS=$3
STRATEGY=$4
PARTLEVEL=$5
NPLIST=$6
TIMEREQ=$7

host=leftraru

unset OPENSEES_USE_SHM

export OMP_NUM_THREADS=1

for p in ${NPLIST}
do
    NP="$p"
    dir1="out_${host}_${MESHSIZE}_${NP}_${UNBAL}_${NSTEPS}_${STRATEGY}_BALANCE_NO_${PARTLEVEL}l"
    dir2="out_${host}_${MESHSIZE}_${NP}_${UNBAL}_${NSTEPS}_${STRATEGY}_BALANCE_YES_${PARTLEVEL}l"
    dir3="out_${host}_${MESHSIZE}_${NP}_${UNBAL}_${NSTEPS}_${STRATEGY}_BALANCE_YESSHM_${PARTLEVEL}l"

    jobname1="${PARTLEVEL}lNO_${MESHSIZE}_${UNBAL}_${NSTEPS}_${STRATEGY}"
    jobname2="${PARTLEVEL}lYES_${MESHSIZE}_${UNBAL}_${NSTEPS}_${STRATEGY}"
    jobname3="${PARTLEVEL}lYESSHM_${MESHSIZE}_${UNBAL}_${NSTEPS}_${STRATEGY}"

    rm -rf $dir1
    rm -rf $dir2
    rm -rf $dir3

    echo "p=$p"
    echo "NP=$NP"
    echo "dir1=$dir1"
    echo "dir2=$dir2"
    echo "dir3=$dir3"
    mkdir $dir1
    cd $dir1
    ln -s ../* .
    echo "sbatch -n $p -J $jobname1" --time="${TIMEREQ}" --error="pops.stderr" --output="pops.stdout" "<<<" $'#!/bin/'"bash\\n srun pops main.tcl ${MESHSIZE} 0 ${NSTEPS} ${STRATEGY} ${PARTLEVEL}"
    sbatch -n $p -J $jobname1 --time="${TIMEREQ}" --error="pops.stderr" --output="pops.stdout" <<< $'#!/bin/bash\n '"srun pops main.tcl ${MESHSIZE} 0 ${NSTEPS} ${STRATEGY} ${PARTLEVEL}"
    cd ..

    mkdir $dir2
    cd $dir2
    ln -s ../* .
    echo "sbatch -n $p -J $jobname2" --time="${TIMEREQ}" --error="pops.stderr" --output="pops.stdout" "<<<" $'#!/bin/bash\\n '"srun pops main.tcl ${MESHSIZE} ${UNBAL} ${NSTEPS} ${STRATEGY} ${PARTLEVEL}"
    sbatch -n $p -J $jobname2 --time="${TIMEREQ}" --error="pops.stderr" --output="pops.stdout" <<< $'#!/bin/bash\n '"srun pops main.tcl ${MESHSIZE} ${UNBAL} ${NSTEPS} ${STRATEGY} ${PARTLEVEL}"
    cd ..
    
    OPENSEES_USE_SHM=True
    mkdir $dir3
    cd $dir3
    ln -s ../* .
    echo "sbatch -n $p -J $jobname3" --time="${TIMEREQ}" --error="pops.stderr" --output="pops.stdout" "<<<" $'#!/bin/bash\\n '"srun pops main.tcl ${MESHSIZE} ${UNBAL} ${NSTEPS} ${STRATEGY} ${PARTLEVEL}"
    sbatch -n $p -J $jobname3 --time="${TIMEREQ}" --error="pops.stderr" --output="pops.stdout" <<< $'#!/bin/bash\n '"srun pops main.tcl ${MESHSIZE} ${UNBAL} ${NSTEPS} ${STRATEGY} ${PARTLEVEL}"
    cd ..
    unset OPENSEES_USE_SHM
done
