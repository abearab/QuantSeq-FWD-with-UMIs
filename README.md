# Quick start guide
First of all, create conda environments as described [here](https://github.com/abearab/QuantSeq-FWD-with-UMIs/tree/main/envs#setup-your-system). 
For a detailed explanation of all modules see [this note](https://github.com/abearab/QuantSeq-FWD-with-UMIs/blob/main/src/README.md). 
Before you run below commands, change `'<#of-jobs>'` to you desired number of threads to use for the analysis. Also, change `'<parent-dir>'` to the path which you want to write results and `'<fastq-dir>'` to the place which FASTQ files are located. 
## [Preprocessing](https://github.com/abearab/QuantSeq-FWD-with-UMIs/blob/main/src/README.md#preprocessing)
```bash
conda activate alignment 
```
```bash
cd ./src
```
```bash
bash fastqc.sh '<parent-dir>' '<fastq-dir>' fastQC '<#of-jobs>' 
```
```bash
bash process_fastq.sh '<parent-dir>' '<fastq-dir>' '<#of-jobs>'
```
```bash
bash alignment.sh '<parent-dir>' fastq-processed/trim '<#of-jobs>'
```
```bash
bash umi_dedup.sh '<parent-dir>' bam '<#of-jobs>'
```
```bash
bash htseq-count.sh '<parent-dir>' bam-processed counts
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

# Exploratory data analysis
Jupyter! Make sure to install [Jupyter](https://anaconda.org/anaconda/jupyter) and [`nb_conda_kernels`](https://anaconda.org/conda-forge/nb_conda_kernels) in the base environment or build seprate environment for that. Using `nb_conda_kernels`, you can have one Jupyter installed in your system and launch different python or R kernels for any created conda environments even in a single notebook. 

You only need `ipykernel`, `numpy` and `pandas` in each environment in addition to your own packages. 
```bash
conda install -n <env-name> -c anaconda ipykernel numpy pandas
```
### How to use R in Jupyter?
If you want to use python and R packages together, you can use `rpy2`. After you have R installed through conda, you can install [`rpy2`](https://pypi.org/project/rpy2/) through `pip`.

Instead, you can include R kernel into an envrinment with R packages. So, install [`irkernel`](https://anaconda.org/r/r-irkernel). 
