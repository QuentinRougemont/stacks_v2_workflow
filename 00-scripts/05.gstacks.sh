#!/bin/bash

#script to run gstacks by Q. Rougemont
#LAST UPDATE: 15-04-2019
:q

#GENERAL SETTINGS:
TIMESTAMP="$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT="$0
NAME=$(basename $0)
LOG_FOLDER="666-log"
INFO_FILES="01-sample_info"
POP_MAP="${INFO_FILES}/population_map.txt"

cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"
cp $POP_MAP $LOG_FOLDER/"$TIMESTAMP"_"$POP_MAP"

#CREATE DIR 
OUTFOLDER="05_gstacks"

if [ ! -d "${OUTFOLDER}" ]
    echo "creating output dir"
    mkdir "${OUTFOLDER}"
fi

#### RUNNING GSTACKS #########################
# Parameters for GSTACKS
# IMPORTANT: RTFM !
# Option For both modes:
I="-I ./04-bam_files/"   #folder with bam
M="-M ${POP_MAP}"        #path to a population map giving the list of samples
O="-O ${OUTFOLDER} "       #output directory (default: none with -B; with -P same as the input directory)
t="-t 8"                 #--threads — number of threads to use (default: 1)
#i="--ignore-pe-reads"   #ignore paired-end reads even if present in the input

#Model options:
m="--model marukilow"    #model to use to call variants and genotypes; one of marukilow (default), marukihigh, or snp
v="--var-alpha 0.05"     #alpha threshold for discovering SNPs (default: 0.05 for marukilow)
gt="--gt-alpha 0.05"     #alpha threshold for calling genotypes (default: 0.05)

#Advanced options: (De novo mode)
km="--kmer-length 31"       # kmer length for the de Bruijn graph (default: 31, max. 31)
mkm="--min-kmer-cov 2"      # minimum coverage to consider a kmer (default: 2)
rmu="--rm-unpaired-reads"   # discard unpaired reads
rmpc="--rm-pcr-duplicates"  # remove read pairs of the same insert length (implies --rm-unpaired-reads)

#Advanced options: (Reference-based mode)
mapq="--min-mapq 20"                           #minimum PHRED-scaled mapping quality to consider a read (default: 10)
maxcl="--max-clipped 0.2"                      #maximum soft-clipping level, in fraction of read length (default: 0.20)
maxin="--max-insert-len"                       #maximum allowed sequencing insert length (default: 1000)
d="--details"                                  # write a heavier output
#pcoo="--phasing-cooccurrences-thr-range 1,2"  # range of edge coverage thresholds to iterate over when building the graph of allele cooccurrences for SNP phasing (default: 1,2)
#phet="--phasing-dont-prune-hets"              #don't try to ignore dubious heterozygote genotypes during phasing


gstaks $I $M $O $t $m $v $gt $km $mkm $rmu $rmpc \
    $mapq $maxcl $maxin $d $pcoo $phet 2>&1 |tee 666-log/"$TIMESTAMP"_gstacks.log

exit

#OLD way:
gstacks -I ./04_bam_files_sorted \
    -M  "$popmap"\
    -O "$OUTFOLDER" \
    -t 8 \
    --min-mapq 20 #\
    #--details
    #--rm-pcr-duplicates \
exit
