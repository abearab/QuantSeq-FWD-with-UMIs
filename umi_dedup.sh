PDIR=$1
bamDIR=$2
JOBS=$3

cd $PDIR

mkdir -p bam-processed/
mkdir -p logs/umi_tools_dedup;

for bam_file in ${bamDIR}/*.bam; do
    fq_base=`basename $bam_file`
    sample_id=${fq_base/.bam/}

    echo '--------------' $sample_id '--------------'

    samtools index -@ $JOBS $bam_file

    umi_tools dedup \
    --output-stats=logs/umi_tools_dedup/${sample_id}.log \
    --stdin=bam/${sample_id}.bam \
    --stdout=bam-processed/${sample_id}.bam

done
