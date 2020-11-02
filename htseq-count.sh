PDIR=$1
bamDIR=$2
countDIR=$3

GTF='/rumi/shams/abe/genomes/hg38/gencode.v34/gencode.v34.annotation.gtf'

cd $PDIR
mkdir -p $countDIR

for bam in ${bamDIR}/*.bam; do
    base=`basename $bam`;    sample_id=${base/.bam/};

    echo -e '----------------------- ' $sample_id  ' -----------------------'

    htseq-count -m intersection-nonempty -s yes -f bam -r pos $bam $GTF > ${countDIR}/${sample_id}.txt

done
