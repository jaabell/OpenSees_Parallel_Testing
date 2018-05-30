#!/bin/bash -l
#SBATCH -n 40 # Debe de ser un número múltiplo de 20
#SBATCH -p debug
#SBATCH --ntasks-per-node=20 # Con esto se fuerza a que se lancen 20 tareas MPI en cada uno de los nodos, ocupando de este modo nodos completos. En este caso 6 nodos completos
#SBATCH -J foundASYM
#SBATCH --time=00:04:00  #Time requested
#SBATCH --error=job.%A.err 
#SBATCH --output=job.%A.out
#SBATCH --mail-type=ALL # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=ja.abell@gmail.com # Email to which notifications will be sent

srun /home/jabell/OpenSees_parallel_jaabell/bin/opensees main.tcl < inputs.txt 
