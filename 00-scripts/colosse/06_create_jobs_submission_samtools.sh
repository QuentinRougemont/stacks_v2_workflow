#!/bin/bash

# Create list of samples
ls 04-raw/*fq.gz | split -l 3 - temp.list.

#change directory in gsnap template job
i=$(pwd)
sed "s#__PWD__#$i#g" 00-scripts/colosse_jobs/samtools_stacks_template.sh > 00-scripts/colosse_jobs/samtools_stacks.sh

# Create list of jobs
for base in $(ls temp.list.*)
do
    toEval="cat 00-scripts/colosse_jobs/samtools_stacks.sh | sed 's/__LIST__/$base/g'"
    eval $toEval > 00-scripts/colosse_jobs/samtools_$base.sh
done

# Submit jobs
for i in $(ls 00-scripts/colosse_jobs/samtools_*.sh)
do
    msub $i
done

