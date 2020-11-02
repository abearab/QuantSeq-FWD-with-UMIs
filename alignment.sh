PDIR=$1
fastqDIR=$2
JOBS=$3

INDEX='/rumi/shams/abe/genomes/hg38/gencode.v34/star_index'

cd $PDIR

mkdir -p bam
mkdir -p logs/star_aligner

STAR --genomeLoad LoadAndExit --genomeDir $INDEX

for fq_file in ${fastqDIR}/*.fastq.gz; do
    fq_base=`basename $fq_file`
    sample_id=${fq_base/.fastq.gz/}

    echo '--------------' $sample_id '--------------'

    STAR \
    --outSAMtype BAM SortedByCoordinate \
    --readFilesCommand zcat \
    --runThreadN $JOBS \
    --genomeDir $INDEX \
    --readFilesIn $fq_file \
    --outFilterType BySJout \
    --outFilterMultimapNmax 20 \
    --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 1 \
    --outFilterMismatchNmax 999 \
    --outFilterMismatchNoverLmax 0.6 \
    --alignIntronMin 20 \
    --alignIntronMax 1000000 \
    --alignMatesGapMax 1000000 \
    --outSAMattributes NH HI NM MD \
    --outFileNamePrefix bam/$sample_id;

    mv -v bam/${sample_id}Aligned.sortedByCoord.out.bam bam/${sample_id}.bam
    mv -v bam/${sample_id}Log.final.out logs/star_aligner/
    rm -v bam/${sample_id}*out*
done

STAR --genomeLoad Remove --genomeDir $INDEX

rm -r _STARtmp/ Log.out Log.progress.out Aligned.out.sam
