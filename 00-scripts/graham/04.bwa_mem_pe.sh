#!/bin/bash
#SBATCH --account=rrg-blouis
#SBATCH --time=1:00:00
#SBATCH --job-name=abc
#SBATCH --output=abc-%J.out
##SBATCH --array=1-33%33
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
##SBATCH --gres=cpu:32
##SBATCH --mail-user=yourmail
##PBS -l nodes=1:ppn=8
##SBATCH --mail-type=EA 

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

module load samtools/1.9
module load bwa/0.7.17
./00-scripts/04.bwa_mem_align_reads_pe.sh
