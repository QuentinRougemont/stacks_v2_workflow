#!/bin/bash
#PBS -A youraccount
#PBS -N bwa
##PBS -o bwa.out
##PBS -e bwa.err
#PBS -l walltime=48:00:00
#PBS -l nodes=1:ppn=8
#PBS -M quentinrougemont@orange.fr
##PBS -m ea 
#
./00-scripts/04.bwa_mem_align_reads_pe.sh
