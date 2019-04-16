#!/bin/bash

#script to run cutadapt on paired-end rad sequencing data
#remove adatapter and trim sequenced to a desired length
#BEFORE doing that, do not forget to have a look at the quality of the data (use fastqc for instance)
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
NCPU=8 #number of CPU, can be set to any number

mkdir 02-data/cutadapt 02-data/cutadapt_2
if [ ! -d "666-log/" ]  ; then  
    echo "creation du dossier" ; 
    mkdir 666-log/; 
fi

input1=$( ls 02-data/*R1.*gz | sed -e 's/02-data\///g' )
#input2=$( ls 02-data/*R2.*gz | sed -e 's/02-data\///g' )
input2="ls -1 02-data/*R2.gz"
output="-o /02-data/cutadapt"
output2="-p /02-data/cutadapt"
adapter="-a AGATCGGAAGAGCG" #name of the first adapter
adapter2="-A AGACCGATCAGAAC" #name of the second adapter 
error="-e 0.1" #error rate 
m="-m 95" #length at which we want to trim the data

if [[ -z "$NCPU" ]]
then
   NCPU=1
fi

ls -1 02-data/*R1
parallel -j $NCPU cutadapt $adapter $adapter2 $output/$input1 $output2/"${input1%.R1.fq.gz}".R2.fq.gz 
        {} $input2 
        $error 
        #$discard_trimmed $untrimmed_output $discard_short
        $m  &>> /666-log/"$TIMESTAMP"_cutadapt_"${i%.fq.gz}".log

#All information on cutadapt is available here: http://cutadapt.readthedocs.org/en/stable/guide.html
#can be cloned from github at: git clone https://github.com/marcelm/cutadapt.git
#for dependencies see: http://cutadapt.readthedocs.org/en/stable/installation.html
