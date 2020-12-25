PDIR=$1
fastqDIR=$2
JOBS=$3

# MORE INFO: https://github.com/abearab/QuantSeq-FWD-with-UMIs/blob/main/src/README.md

start_data="`date`"
# make MultiQC report from fastq files 
bash fastqc.sh $PDIR $fastqDIR fastQC $JOBS 
# Process raw FASTQ files 
bash process_fastq.sh $PDIR $fastqDIR $JOBS
# Alignment
bash alignment.sh $PDIR fastq-processed/trim $JOBS
# Process BAM files
bash umi_dedup.sh $PDIR bam $JOBS
# Measure gene level counts
bash htseq-count.sh $PDIR bam-processed counts

# make MultiQC report for above steps
multiqc counts logs/ -n mutiqc-preprocessing

rm -r fastq-processed
rm -r bam-processed

end_data="`date`"

echo $start_data '--->>>' $end_data
