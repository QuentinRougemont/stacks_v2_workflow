#!/bin/bash
#SBATCH -J "populations"
#SBATCH -o log_%j
#SBATCH -c 8
#SBATCH -p large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=07-10:00
#SBATCH --mem=20G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

module load gcc/6.2.0
#
./00-scripts/06.populations_single_end.sh
