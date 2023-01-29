#!/bin/bash

#script to run cutadapt on paired-end rad sequencing data
#remove adatapter and trim sequenced to a desired length
#BEFORE doing that, do not forget to have a look at the quality of the data (use fastqc for instance)
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
NCPU=8 #number of CPU, can be set to any number

mkdir 02-data/trimmed
if [ ! -d "99-logfolder/" ]  ; then  
    echo "creation du dossier" ; 
    mkdir 99-logfolder; 
fi

adapters1="-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"    #name of the first adapter
adapters2="-A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"     #name of the second adapter
error="-e 0.1" #error rate 
m="-m 130" #length at which we want to trim the data

if [[ -z "$NCPU" ]]
then
   NCPU=8
fi

rm 99-logfolder/"$TIMESTAMP"_02_rmbarcode"${i%.fastq.gz}".log 2> /dev/null
ls -1 02-data/*R1.fastq.gz |perl -pe 's/R[12]\.fastq\.gz//g' |
parallel -j $NCPU cutadapt  $adapters1 $adapters2 \
          -o 02-data/trimmed/{/}R1.fastq.gz -p 02-data/trimmed/{/}R2.fastq.gz \
          "$error" \
          "$m" \
          02-raw/{/}R1.fastq.gz 02-raw/{/}R2.fastq.gz '2>&1' '>>' 99-logfolder/"$TIMESTAMP"_02_rmbarcode"${i%.fastq.gz}".log


#All information on cutadapt is available here: http://cutadapt.readthedocs.org/en/stable/guide.html
#can be cloned from github at: git clone https://github.com/marcelm/cutadapt.git
#for dependencies see: http://cutadapt.readthedocs.org/en/stable/installation.html
