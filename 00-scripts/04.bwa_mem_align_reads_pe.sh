#!/bin/bash

# Global variables
GENOMEFOLDER="08-genome"
GENOME="Lp2_sperm-8.fa"
DATAFOLDER="03-demultiplex"
OUTFOLDER="04-bam_files"
if [ ! -d ${OUTFOLDER} ]
then
    echo "creating bam folder"
    mkdir $OUTFOLDER
fi

NCPU=$1

# Test if user specified a number of CPUs
if [[ -z "$NCPU" ]]
then
    NCPU=4
fi

# Index genome if not alread done
# bwa index -p $GENOMEFOLDER/$GENOME $GENOMEFOLDER/$GENOME.fasta
#verify that your sample contain the R1 and R2 pattern
#verify that the samtools flag satisfy your criterion

for file in $(ls -1 $DATAFOLDER/*.R1.fastq.gz)
do
    # Name of uncompressed file
    file2=$(echo "$file" | perl -pe 's/.R1.fastq/.R2.fastq/')
    echo "Aligning file $file $file2"

    name=$(basename $file)
    name2=$(basename $file2)
    ID="@RG\tID:ind\tSM:ind\tPL:Illumina"

    # Align reads 1 step
    bwa mem -t "$NCPU"  \
        -R $ID $GENOMEFOLDER/$GENOME \
	$DATAFOLDER/"$name" $DATAFOLDER/"$name2" 2> /dev/null |
        samtools view -Sb -q 20 -F 4 -F 256 -F 2048 - |
    samtools sort - > $OUTFOLDER/"${name%.fastq.gz}".bam
    #samtools index $DATAFOLDER/"${name%.fastq.gz}".sorted.bam
done
