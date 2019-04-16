#!/bin/bash
#SBATCH -J "gstacks"
#SBATCH -o log_%j
#SBATCH -c 8
#SBATCH -p large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=07-10:00
#SBATCH --mem=180G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

module load gcc/6.2.0
### WARNING make sure you've install the last beta version of stacks_v2

# Create stacks catalog
./00-scripts/05.gstacks.sh
