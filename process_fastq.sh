PDIR=$1
fastqDIR=$2
JOBS=$3

mkdir -p fastq-processed/umi_extract;
mkdir -p fastq-processed/trim;
mkdir -p logs/umi_tools_extract;
mkdir -p logs/cutadapt_trim;

for fq_file in ${fastqDIR}/*.fastq.gz; do
    fq_base=`basename $fq_file`;
    sample_id=${fq_base/.fastq.gz/}
    log_file=${fq_base/.fastq.gz/.log};

    echo '--------------' $sample_id '--------------'

     umi_tools extract --bc-pattern=NNNNNN \
     --stdin=$fq_file \
     --log=logs/umi_tools_extract/$log_file \
     --stdout fastq-processed/umi_extract/$fq_base

    cutadapt -j $JOBS -q 15 -m 20 -u 12 -o fastq-processed/trim/$fq_base fastq-processed/umi_extract/$fq_base > logs/cutadapt_trim/$log_file;

done

