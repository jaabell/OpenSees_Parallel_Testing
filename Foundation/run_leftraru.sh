#!/bin/bash
#SBATCH -n 40
#SBATCH -J bops40
#SBATCH --time=00:10:00  #Time requested
#SBATCH --output=bops_%A.out
#SBATCH --error=bops_%A.err
#SBATCH --mail-type=ALL # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ja.abell@gmail.com # Email to which notifications will be sent


module load intel/2018d       
module load impi/2018.3.222   
module load parmetis/4.0.3    
module load metis/5.1.0

# unset I_MPI_PMI_LIBRARY

mkdir case_coarse_40
cd case_coarse_40
ln -s ../* .
srun pops main.tcl coarse 0 5 3
# srun pops main.tcl coarse 0 5 3
cd ..
