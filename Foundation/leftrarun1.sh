#!/bin/bash

rm -rf out*10

MESHSIZE=coarse
UNBAL=0.2
NSTEPS=5
STRATEGY=5

host=leftraru

unset OPENSEES_USE_SHM

for p in 2 4 8 10 20 40 80 100 120
do
    NP="$p"
    dir1="out_${host}_${MESHSIZE}_${NP}_${UNBAL}_${NSTEPS}_${STRATEGY}_BALANCE_NO_1l"
    dir2="out_${host}_${MESHSIZE}_${NP}_${UNBAL}_${NSTEPS}_${STRATEGY}_BALANCE_YES_1l"
    dir3="out_${host}_${MESHSIZE}_${NP}_${UNBAL}_${NSTEPS}_${STRATEGY}_BALANCE_YESSHM_1l"

    echo "$p"
    echo "$NP"
    echo "$dir1"
    echo "$dir2"
    echo "$dir3"
    mkdir $dir1
    cd $dir1
    ln -s ../* .
    sbatch -n $p -J fou$p --time="00:10:00" --error="bops_$p.err" --output="bops_$p.out" <<< $'#!/bin/bash\n srun pops main1.tcl coarse 0 $NSTEPS $STRATEGY'
    cd ..

    mkdir $dir2
    cd $dir2
    ln -s ../* .
    sbatch -n $p -J fou$p --time="00:10:00" --error="bops_$p.err" --output="bops_$p.out" <<< $'#!/bin/bash\n srun pops main1.tcl coarse $UNBAL $NSTEPS $STRATEGY'
    cd ..
    
    OPENSEES_USE_SHM=True
    mkdir $dir3
    cd $dir3
    ln -s ../* .
    sbatch -n $p -J fou$p --time="00:10:00" --error="bops_$p.err" --output="bops_$p.out" <<< $'#!/bin/bash\n srun pops main1.tcl coarse $UNBAL $NSTEPS $STRATEGY'
    cd ..
    unset OPENSEES_USE_SHM
done


# mkdir case_coarse_4
# cd case_coarse_4
# ln -s ../* .
# sbatch -n 4 -J fou4 --time="00:10:00" --error="bops_4.err" --output="bops_4.out" <<< $'#!/bin/bash\n srun pops main.tcl coarse 0 5 3'
# cd ..
# mkdir case_coarse_8
# cd case_coarse_8
# ln -s ../* .
# sbatch -n 8 -J fou8 --time="00:10:00" --error="bops_8.err" --output="bops_8.out" <<< $'#!/bin/bash\n srun pops main.tcl coarse 0 5 3'
# cd ..
# mkdir case_coarse_16
# cd case_coarse_16
# ln -s ../* .
# sbatch -n 16 -J fou16 --time="00:10:00" --error="bops_16.err" --output="bops_16.out" <<< $'#!/bin/bash\n srun pops main.tcl coarse 0 5 3'
# cd ..
# mkdir case_coarse_20
# cd case_coarse_20
# ln -s ../* .
# sbatch -n 20 -J fou20 --time="00:10:00" --error="bops_20.err" --output="bops_20.out" <<< $'#!/bin/bash\n srun pops main.tcl coarse 0 5 3'
# cd ..
# mkdir case_coarse_40
# cd case_coarse_40
# ln -s ../* .
# sbatch -n 40 -J fou40 --time="00:10:00" --error="bops_40.err" --output="bops_40.out" <<< $'#!/bin/bash\n srun pops main.tcl coarse 0 5 3'
# cd ..

