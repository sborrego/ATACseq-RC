#!/bin/bash

#$ -N fastQC_RC             # name of the job
#$ -o /som/sborrego/2018_ATACSEQ_RC_DATA/atac_rc_fastqc/fastqc_RC.out   # contains what would normally be printed to stdout (the$
#$ -e /som/sborrego/2018_ATACSEQ_RC_DATA/atac_rc_fastqc/fastqc_RC.err   # file name to print standard error messages to. These m$
#$ -q free64,som,asom       # request cores from the free64, som, asom queues.
#$ -pe openmp 8-16         # request parallel environment. You can include a minimum and maximum core count.
#$ -m beas                  # send you email of job status (b)egin, (e)rror, (a)bort, (s)uspend
#$ -ckpt blcr               # (c)heckpoint: writes a snapshot of a process to disk, (r)estarts the process after the checkpoint is c$

module load blcr
module load fastqc/0.11.7

# The directory where the data we want to analyze is located
DATA_DIR=/som/sborrego/2018_ATACSEQ_RC_DATA/raw_data_fastq
# The directory where we want the result files to go
QC_OUT_DIR=/som/sborrego/2018_ATACSEQ_RC_DATA/atac_rc_fastqc/fastqc

# Making the result file directory
mkdir -p ${QC_OUT_DIR}

# Here we are performing a loop that will use each file in our data directory as input, "*" is a wild card symbol and in this context matches any file in the indicated directory
# Each file will be processed with the program "fastqc", "\" symbol indicates that more options for the program are on the next line 
# (--outdir) indicates the output directory for the result files
for FILE in `find ${DATA_DIR} -name PGC\*`; do
    fastqc $FILE \
    --outdir ${QC_OUT_DIR}
done
