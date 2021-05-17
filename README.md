# RADseqAnalysis
This repo contains most major script to perform a RADseq Analysis using the new stacks V2 pipeline


## WARNING
SCRIPTS ARE OLD AND NOT REALLY UPDATED ANYMORE
For updated scripts see: [https://github.com/enormandeau/stacks_workflow](https://github.com/enormandeau/stacks_workflow)
Some update still needs to be done and I hope to find some time to add more scripts for pop. gen analysis in addition to script for RADseq genotyping and filtering. 
As some scripts may be missing do not hesitate to contact me at: quentinrougemont@orange.fr

REFERENCES:
REF of stacks here
## Dependencies
```cutadapt``` Download [cutadapt] (https://github.com/marcelm/cutadapt) 

```gbsx``` Download [gbsx] (https://github.com/GenomicsCoreLeuven/GBSX)

```stacks``` Download [stacks] (http://catchenlab.life.illinois.edu/stacks/) (see details of installation on the website)

```vcftools``` Download [vcftools] (http://vcftools.sourceforge.net/)

other requirements:
 
```linux```  

```gnu parallel```  



## First step -- quality check : 


you can check your rad data with fastqc first: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

then I used the script:   
`00-scripts/01.prepare_data.sh`  
to move the raw data and perform some cleaning.  
The cleaning step using some bash code is probably no-longer needed in any Illumina RADseq  project.  

## Remove barcode and trim data:

you can simply run cutadapt after installing it:  

```./00-scripts/02.remove_barcodes.sh```

you'll have to change several parameters according to the length of your read, etc.  
See details in the scripts

## Demultiplexing the data:

I used either gbsx or process radtags to demultiplex the data and obtain individual level data :
```./00-scripts/03.demultiplexing_gbsx.sh ``` 

the option ```barcode="your_barcodes.txt" ``` is important and you must provide the list of barcode for each individual in "your_barcodes.txt" file   

Here you can assess the quality of the data for each individual again using fastqc  

##  Align data:
simply use BWA-MEM:
For PAIRED-END DATA: 
``` ./00-scripts/04.bwa_mem_align_reads_pe.sh ```

For SINGLE-END DATA:
``` .//00-scripts/04.bwa_mem_align_reads_single.sh ```

#it is also a good practice at this stage to look at the mapping rate by counting the number of read in each individual fastq and looking at the total number of read mapped,
individuals with too few reads (e.g mean-2*SD) or low mapping rate should be removed !
some script to count the number of read and mapped reads are present in this folder: ```https://github.com/QuentinRougemont/utility_scripts/tree/master/07.random_scripts```


## CALL SNP:
#simply run gstacks. Adjust parameters within the scripts
./00-scripts/05.gstacks.sh 

#here the most important are the parameters of the marukilow algorithm
#additional custom parameters can be used for paired-end data to exploit haplotype

## Produce vcf file:
then run population to produce a final vcf:
```./00-scripts/06.populations.sh ```

## Filtering : 
In general I filter the script with vcftools/R/awk commands

important filtering criteria are : 
* mean depth (can be obtained from vcftools with --site-mean-depth and with --geno-depth for genotype level depth)
* keeping biallelic SNPs 
* missing rate (can be obtained with vcftools with --missing-indv for individuals and --missing-site for each site)

it is important to explore rate of missing data and remove individuals accordingly  
similarly, genotype with excessive depth needs to be explord to understand the source of excess (e.g. paralogy)  
For demographic reconstruction it is important to avoid using any MAF/MAC as low MAF SNPs are informative regarding past demographic events  

Depending on the goal of the study additional filter may include: 
* HWE/Fis filtering
* MAF/MAC filtering 
