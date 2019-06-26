#!/bin/bash

#script to launch populations in stacks v2
#LAST UPDATE: 15-04-2019
#module load gcc/6.2.0
#
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)

# Copy script as it was run
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="666-log"
INFO_FILES="01-sample_info"
POP_MAP="${INFO_FILES}/population_map.txt"

cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"
cp $POP_MAP $LOG_FOLDER/"$TIMESTAMP"_"$POP_MAP"

OUTFOLDER="06_out_vcf" 
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi


# IMPORTANT: make sure your read about the available options for 'populations'
# in the STACKS papers
# Comment out the options required to run your analysis
#b="-b 1"               # Batch ID to examine when exporting from the catalog
P="-P 05_gstacks"       # Path to the Stacks output files.
O="-O 06_out_vcf"	#Path to directory where to write output
M="-M 01-sample_info/population_map.txt"  # Path to the population map, a
                                         # tab separated file describing
                                         # which individuals belong in
                                         # which population
t="-t 8"         # Number of threads to run in parallel sections of code
b_size="--batch_size" # the number of loci to process in a batch (default: 10,000 in de novo mode; in reference mode, one chromosome per batch). Increase to speed analysis, uses more memory, decrease to save memory).

# Data filtering
r="-r 0.7"   # Minimum percentage of individuals in a population
             # required to process a locus for that population
R="-R 0.2"   #minimum percentage of individuals across populations required to process a locus
p="-p 1"     # Minimum number of populations a locus must be present
             # in to process a locus
H="-H "      #--filter-haplotype-wise: apply the above filters haplotype wise (unshared SNPs will be pruned to reduce haplotype-wise missing data).
#min_maf="--min-maf 0"     # Specify a minimum minor allele frequency required
                           #to process a SNP (0 < min-maf < 0.5)
                           # 'p_value', 'bonferroni_win', or 'bonferroni_gen'
#min_mac="--min-mac 0"     # [int]: specify a minimum minor allele count required to process a SNP.                       
#max_het="--max-obs-het 0.9"        #[float]: specify a maximum observed heterozygosity required to process a SNP.            
#write_single="--write-single-snp"  #: restrict data analysis to only the first SNP per locus (implies --no-haps).        
#write_random="--write-random-snp"  #: restrict data analysis to one random SNP per locus (implies --no-haps).            
#B="-B "                    #/--blacklist: path to a file containing Blacklisted markers to be excluded from the export.          
#W="-W"                     #--whitelist: path to a file containing Whitelisted markers to include in the export.                
#Merging and Phasing:
e="-e pstI " #/    -e,--renz — restriction enzyme name.
m="--merge-sites" #  — merge loci that were produced from the same restriction enzyme cutsite (requires reference-aligned data).
#m_prune_lim="--merge-prune-lim" # — when merging adjacent loci, if at least X% samples posses both loci prune the remaining samples out of the analysis.

#Locus stats:
#hwe="--hwe" #: calculate divergence from Hardy-Weinberg equilibrium for each locus.                            
#Fstats:
#fstats="--fstats"     # Enable SNP and haplotype-based F statistics
#fst_corr="--fst-correction p_value" #: specify a correction to be applied to Fst values: 'p_value', 'bonferroni_win', or 'bonferroni_gen'. Default: off.
#pvaluecut="--p-value-cutoff 0.05"  # [float]: maximum p-value to keep an Fst measurement. Default: 0.05. (Also used as bas for Bonferroni correction.) 
#Kernel-smoothing algorithm:
#k="-k"  #,--smooth: enable kernel-smoothed Pi, Fis, Fst, Fst', and Phi_st calculations.
#smooth_fst="--smooth-fstats" #: enable kernel-smoothed Fst, Fst', and Phi_st calculations. 
#smooth_pop="--smooth-popstats" # : enable kernel-smoothed Pi and Fis calculations.  
#    (Note: turning on smoothing implies --ordered-export.) 
#sigma="--sigma" # [int]: standard deviation of the kernel smoothing weight distribution. Default 150kb.         
#boot="--bootstrap" #: turn on boostrap resampling for all smoothed statistics.                                 
#Nboot="-N 500" #,--bootstrap-reps [int]: number of bootstrap resamplings to calculate (default 100).                
#bootpifis="--bootstrap-pifis" #turn on boostrap resampling for smoothed SNP-based Pi and Fis calculations.        
#bootfst="--bootstrap-fst"  #turn on boostrap resampling for smoothed Fst calculations based on pairwise population comparison of SNPs.                                                                                    
#bootdiv="--bootstrap-div" #: turn on boostrap resampling for smoothed haplotype diveristy and gene diversity calcuations based on haplotypes.
#bootphist="--bootstrap-phist" #: turn on boostrap resampling for smoothed Phi_st calculations based on haplotypes.  
#bootwl="--bootstrap-wl" # [path]: only bootstrap loci contained in this whitelist.                               

# file output options
order_exp="--ordered-export" #: if data is reference aligned, exports will be ordered; only a single representative of each overlapping site.                                                                                
#fasta_loc="--fasta-loci" #: output locus consensus sequences in FASTA format.                                       
#fasta_sample="--fasta-samples" #: output the sequences of the two haplotypes of each (diploid) sample, for each locus, in FASTA format.                                                                                         
vcf="--vcf"                        # Output SNPs and haplotypes results in Variant Call Format (VCF).
#genepop="--genepop"               # Output results in GenePop format
#structure="--structure"           # Output results in Structure format
#radpainter="--radpainter"	   # Output results in fineRADstructure/RADpainter formtat.
#phase="--phase*"                  # Output genotypes in PHASE/fastPHASE format.
#fastphase="--fastphase*"          # Output genotypes in fastPHASE format
#plink="--plink"                   # Output genotypes in PLINK format.
#phylip="--phylip"		   # Output nucleotides that are fixed-within
                                   # and variant among populations in Phylip
                                   # format for phylogenetic tree construction
#phylip_var="--phylip_var"         # Include variable sites in the phylip output
#phylip_var_all="--phylip-var-all*" # include all sequence as well as variable sites in the phylip output encoded using IUPAC"
#hzar="--hzar"                     # Output genotypes in Hybrid Zone Analysis
                                   # using R (HZAR) format.

# Debugging
#h="-h" #,--help: display this help messsage. 
#v="-v" #,--version: print program version.
#verbose="--verbose"            # turn on additional logging.
#log_fst_comp="--log_fst_comp"  # log components of Fst calculations to a file.

# Launch populations

populations $P $M $O $t $_size $r $R $p $H \
    $min_maf $min_mac $max_het \
    $write_single $write_random $W $B \
    $e $m $m_prune_lim \
    $hwe \
    $fstats $fst_corr $pvaluecut $k $smooth_fst $smooth_pop $sigma $Nboot $boot $bootpifis \
    $bootfst $bootdiv $bootphist $bootwl \
    $order_exp $fasta_loc $fasta_sample $vcf $genepop $structure \
    $radpainter $phase $fastphase $plink $phylip $phylip_var $phylipe_var_all $hzar \
    $h $v $verbose $log_fst_comp 2>&1 | tee 666-log/"$TIMESTAMP"_stacks_4_populations.log

