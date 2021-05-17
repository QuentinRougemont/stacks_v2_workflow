#!/bin/bash

#script to run gbsx
#see full documentation at: https://github.com/GenomicsCoreLeuven/GBSX
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
NCPU=8 #number of CPU, can be set to any number

#can be customized very easily
if [ ! -d "03-demultiplex/" ]  ; then  
    echo "creation du dossier" ; 
    mkdir 03-demultiplex/; 
fi

outfile="03-demultiplex"
folder="02-data/cutadapt"
path="./GBSX/releases/GBSX_v1.3" #update according to your path
barcode="your_barcodes.txt"
rad="-rad true"
gzip="-gzip true"
#qual="-q Illumina1.8"

ls -l $folder/*R1.fq.gz |
parallel -j $NCPU java -jar "$path"/GBSX_v1.3.jar \
    --Demultiplexer \
    -f1 "$folder"/{} \
    -f2 "$folder"/"${i%.R1.fq.gz}.R2.fq.gz \
    -i "$barcode" \
     $gzip \
     $rad \
     $qual -o "$outfile"&>> 666-log/"$TIMESTAMP"_gbsx_"${i%.R1.fq.gz}".log
