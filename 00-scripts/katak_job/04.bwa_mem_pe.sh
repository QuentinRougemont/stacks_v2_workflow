#!/bin/bash
#SBATCH -J "bwamem"
#SBATCH -o log_%j  
#SBATCH -c 4       
#SBATCH -p small   
#SBATCH --mail-type=FAIL 
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=10:00:00  
#SBATCH --mem=8G             

cd $SLURM_SUBMIT_DIR         

#module prerequis            
module load samtools/1.8     
module load bwa/0.7.17       

./00-scripts/04.bwa_mem_align_reads_pe.sh 
