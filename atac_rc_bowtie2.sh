#!/bin/bash

#$ -N align_RC             # name of the job
#$ -o /som/sborrego/2018_ATACSEQ_RC_DATA/atac_rc_alignments/alignments_RC.out   # contains what would normally be printed to stdout (the$
#$ -e /som/sborrego/2018_ATACSEQ_RC_DATA/atac_rc_alignments/alignments_RC.err  # file name to print standard error messages to. These m$
#$ -q free64,som,asom       # request cores from the free64, som, asom queues.
#$ -pe openmp 8-32          # request parallel environment. You can include a minimum and maximum core count.
#$ -m beas                  # send you email of job status (b)egin, (e)rror, (a)bort, (s)uspend
#$ -ckpt blcr               # (c)heckpoint: writes a snapshot of a process to disk, (r)estarts the process after the checkpoint is complete

module load blcr
module load bowtie2/2.2.7
module load samtools/1.9

set -eoux pipefail

# This is the directory containing the referece genome index(HPC, mm10)
REF_IDX=/pub/share/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome

# The main directory the project files are in
PROJECT_DIR=/som/sborrego/2018_ATACSEQ_RC_DATA
# The directory where the data we want to analyze is located
DATA_DIR=${PROJECT_DIR}/raw_data_fastq
# The directory where we want the result files to go
ALIGNMENTS_DIR=${PROJECT_DIR}/atac_rc_alignments

mkdir -p ${ALIGNMENTS_DIR}

RUNLOG=${ALIGNMENTS_DIR}/alignment_runlog.txt
echo "Run by `echo $USER` on `date`" >> ${RUNLOG}

FLAG=${ALIGNMENTS_DIR}/alignment_errors.flagstat
echo "Run by `echo $USER` on `date`" >> ${FLAG}

for FILE in `find ${DATA_DIR} -name PGC\*`; do
	echo $FILE
	PREFIX=`basename ${FILE} .fastq.gz`
	BAM_FILE=${ALIGNMENTS_DIR}/${PREFIX}.sorted.bam

	echo "*** Aligning: ${FILE}"
	echo "Alignment summary ${FILE}" >> ${RUNLOG}

	bowtie2 \
	-p 8 \
	-x ${REF_IDX} \
	-U ${FILE} 2>> ${RUNLOG} \
	| samtools view -bS - | samtools sort -@ 8 - > ${BAM_FILE}

	samtools index ${BAM_FILE}
	samtools flagstat ${BAM_FILE} >> ${FLAG}
done

#### TESTING



## Can we capture the file names?
# for FILE in `find ${DATA_DIR} -name PGC\*`; do
# 	echo $FILE
# done

# ### Can we correctly perform tasks on the file names?
# for FILE in `find ${DATA_DIR} -name PGC\*`; do
# 	echo $FILE
# 	PREFIX=`basename ${FILE} .fastq.gz`
# 	BAM_FILE=${ALIGNMENTS_DIR}/${PREFIX}.sorted.bam
	
# 	echo $PREFIX
# 	echo $BAM_FILE
# done
