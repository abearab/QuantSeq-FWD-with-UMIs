# Quick start guide
First of all, create conda environments as described [here](https://github.com/abearab/QuantSeq-FWD-with-UMIs/tree/main/envs#setup-your-system). 
For a detailed explanation of all modules see [this note](https://github.com/abearab/QuantSeq-FWD-with-UMIs/blob/main/src/README.md). 
Before you run below commands, change `'<#of-jobs>'` to you desired number of threads to use for the analysis. Also, change `'<parent-dir>'` to the path which you want to write results and `'<fastq-dir>'` to the place which FASTQ files are located. 
## [Preprocessing](https://github.com/abearab/QuantSeq-FWD-with-UMIs/blob/main/src/README.md#preprocessing)
```bash
conda activate alignment 
cd ./src
```
```bash
bash process_fastq.sh '<parent-dir>' '<fastq-dir>' '<#of-jobs>'
```
```bash
bash alignment.sh '<parent-dir>' '<fastq-dir>' '<#of-jobs>'
```
```bash
bash umi_dedup.sh '<parent-dir>' bam '<#of-jobs>'
```
```bash
bash htseq-count.sh '<parent-dir>' bam-processed counts
```
```bash
bash fastqc.sh '<parent-dir>' '<fastq-dir>' fastQC '<#of-jobs>' 
```
```bash
multiqc counts/ logs/ -n mutiqc-preprocessing
```
## [Downstream analysis](https://github.com/abearab/QuantSeq-FWD-with-UMIs/blob/main/src/README.md#downstream-analysis)
Define a `samplesheet.txt` which contain a tab seprated table to describe your samples. 
\[coming soon\]
```bash
conda activate deseq2
```
```bash
Rscript DESeq.R '<parent-dir>' counts samplesheet.txt '<#of-jobs>' 
```

---

Note: you can run each line with `nohup` in below format to run your command on the background:


```bash
nohup '<program>' '<options>' > '<log-file.txt>' &
```
