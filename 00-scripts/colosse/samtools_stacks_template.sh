#!/bin/bash
#PBS -A ihv-653-aa
#PBS -N bwa__LIST__
#PBS -o bwa__LIST__.out
#PBS -e bwa__LIST__.err
#PBS -l walltime=20:00:00
#PBS -M YOUREMAIL
####PBS -m ea
#PBS -l nodes=1:ppn=8
#PBS -r n

# Global variables
list=__LIST__

# Move to job submission directory
cd $PBS_O_WORKDIR

# Load gmap module
source /clumeq/bin/enable_cc_cvmfs
module load samtools/1.5
module load bwa/0.7.15

# Global variables
DATAFOLDER="04-raw"
GENOMEFOLDER="/path_to_genome/03_genome/"
GENOME="your_genome.fasta"

for file in $(cat $list)
do
    # Name of uncompressed file
    echo "Aligning file $file"

    name=$(basename $file)
    samtools sort  "$DATAFOLDER"/"${name%.fq.gz}".bam \
        > "$DATAFOLDER"/"${name%.fq.gz}".sorted.bam
    # Index:
    samtools index  "$DATAFOLDER"/"${name%.fq.gz}".sorted.bam
    # Remove unsorted bam file
    #rm "$DATAFOLDER"/"${name%.fq.gz}".bam

done

