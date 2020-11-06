- Each module write output files in the subfolders of `'<parent-dir>'`. 
- STAR and HTSeq command options selected as suggested in the [QuantSeq data analysis manual](https://www.lexogen.com/wp-content/uploads/2020/07/015UG108V0300_QuantSeq-Data-Analysis-Pipeline-on-BlueBee-Platform_2020-07-20.pdf), page 18. 
- We are using [UMI Tools](https://umi-tools.readthedocs.io/en/latest/QUICK_START.html) with basic options for this pipeline. 
- Important file/directory outputs from each module, marked as **bold** for your attention. 

# Preprocessing
## Process raw FASTQ files 
The 1st 6nt are UMI. So, we aim to remove UMI sequences from the Illumina reads using the [`umi_tools extract`](https://umi-tools.readthedocs.io/en/latest/QUICK_START.html#step-3-extract-the-umis). Then, we use [`cutadapt`](https://github.com/marcelm/cutadapt) with `-u` option to trim 12 nt and also, remove low quality and short reads. 

```bash
bash process_fastq.sh '<parent-dir>' '<fastq-dir>' '<#of-jobs>'
```
#### OUTPUTS:
|Location |Description |
|---|---|
|`fastq-processed/umi_extract` | FASTQ files after running `umi_tools extract` command on files inside '<fastq-dir>' directory. 
|**`fastq-processed/trim`** | FASTQ files after running `cutadapt` command on above FASTQ files as the input. 
|`logs/umi_tools_extract` | Log files from running `umi_tools extract` 
|`logs/cutadapt_trim` | Log files from running `cutadapt` 

## Alignment
This command run STAR for all samples in the `'<fastq-dir>'`. To use processed FASTQ files as the input, specify `'<fastq-dir>'` as `fastq-processed/trim`.
```bash
bash alignment.sh '<parent-dir>' '<fastq-dir>' '<#of-jobs>'
```
#### OUTPUTS:
|Location |Description |
|---|---|
|**`bam`** |Actual results from STAR run in BAM format.
|`logs/star_aligner`| Log files from STAR run. 


## Process BAM files
Here, `umi_tools dedup` detect duplicate reads in the BAM files. To use BAM files from the alignment module as the input, specify `'<bam-dir>'` as `bam`.

```bash
bash umi_dedup.sh '<parent-dir>' '<bam-dir>' '<#of-jobs>'
```
#### OUTPUTS:
|Location |Description |
|---|---|
|**`bam-processed`** |Actual results from `umi_tools dedup` run in BAM format.
|`logs/umi_tools_dedup`|Log files from `umi_tools dedup` run. 


## Measure gene level counts
Gene level counts measured using the HTSeq package. To use processed BAM files as input, specify `'<bam-dir>'` as `bam-processed`.

```bash
bash htseq-count.sh '<parent-dir>' '<bam-dir>' '<count-dir>'
```
#### OUTPUTS: 
if `'<count-dir>'` replaced by `counts`:
|Location |Description |
|---|---|
|`counts` |Actual results from `htseq-count` run.

## Quality controls 
Fastq files and the pre-processing steps were assessed for quality control using the FastQC and multiQC programs. 
```bash
bash fastqc.sh '<parent-dir>' '<fastq-dir>' '<fastQC-dir>' '<#of-jobs>' 
```
#### OUTPUTS: 
if `'<fastQC-dir>'` replaced by `fastQC`:
|Location |Description |
|---|---|
|`fastQC`|Actual results from `fastqc` run.
|`mutiqc-fastQC`|All data from `mutiqc` run on the above folder.
|**`mutiqc-fastQC.html`**|HTML report of QCs for all FASTQ files in '<fastq-dir>' folder.

---

Also, this line will provide another HTML report for STAR, Cutadapt, UMI Tools (`extract` and `dedup`) and HTSeq commands into `mutiqc-preprocessing.html` file. 
```bash
multiqc '<count-dir>' logs/ -n mutiqc-preprocessing
```

# Downstream analysis 
## Count based basic analysis
HTSeq counts processed in R using the DESeq2 package. First, the `varianceStabilizingTransformation` function from DESeq2 used for the Principal Component Analysis (PCA). The first three PCs were selected for a 3-D scatter plot visualization using the R-Plotly package. For heatmap visualizations, normalized counts extracted from the DESeq object, genes with less than 10 counts in all samples were removed as low expressed genes, and also, normalized across samples (SD = 1, mean ~=0) for each gene. 

```bash
Rscript DESeq.R '<parent-dir>' '<count-dir>' '<samplesheet.txt>' '<#of-jobs>' 
```
#### OUTPUTS: 
|Location |Description |
|---|---|
| `deseq/pca3d` | `plotly` data
| **`deseq/pca3d.html`** | PCA; Interactive 3D scatter plot for the first 3 PCs.
| **`deseq/mostVar_Heatmap.pdf`** | Heatmap plot in `pdf` format
| **`deseq/mostVar_Heatmap.png`** | Heatmap plot in `png` format
| **`deseq/counts.normalized.txt`** | Raw counts for all samples in a single file. 
| **`deseq/counts.raw.txt`** | Normalized counts (using DESeq2) for all samples in a single file. 

## Differential expression analysis 
\[coming soon\]
## Enrichment analysis 
\[coming soon\]
<!-- `'<ipage-folder>'` should contain one or more iPAGE inputs in correct format. It means two column tab seprated table which contain the first column as gene IDs and the second column with numeric valuse such as logFC. 
Something like this: 
```
ENSG00000000003 0.223
ENSG00000000005	0
ENSG00000000419	0.094
ENSG00000000457	0.216
ENSG00000000460	0.253
ENSG00000000938	0
ENSG00000000971	0
ENSG00000001036	-0.358
ENSG00000001084	0.523
ENSG00000001167	0.304
```

```bash
nohup ls '<ipage-folder>'/*.txt | parallel -j'<#of-jobs>' -k bash ipage.sh {} &> ipage.out &
```

Currently, you can run this module on `rumi` server at UCSF. 
--> 

# References
- Andrews S. (2010). FastQC: a quality control tool for high throughput sequence data. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc


- Ewels, P., Magnusson, M., Lundin, S., & Käller, M. (2016). MultiQC: summarize analysis results for multiple tools and samples in a single report. Bioinformatics (Oxford, England), 32(19), 3047–3048. https://doi.org/10.1093/bioinformatics/btw354


- Smith, T., Heger, A., & Sudbery, I. (2017). UMI-tools: modeling sequencing errors in Unique Molecular Identifiers to improve quantification accuracy. Genome research, 27(3), 491–499. https://doi.org/10.1101/gr.209601.116


- Martin, M. (2011). Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet.journal, 17(1), pp. 10-12. https://doi.org/10.14806/ej.17.1.200


- Dobin, A., Davis, C. A., Schlesinger, F., Drenkow, J., Zaleski, C., Jha, S., Batut, P., Chaisson, M., & Gingeras, T. R. (2013). STAR: ultrafast universal RNA-seq aligner. Bioinformatics (Oxford, England), 29(1), 15–21. https://doi.org/10.1093/bioinformatics/bts635


- Anders, S., Pyl, P. T., & Huber, W. (2015). HTSeq--a Python framework to work with high-throughput sequencing data. Bioinformatics (Oxford, England), 31(2), 166–169. https://doi.org/10.1093/bioinformatics/btu638


- Frankish, A., Diekhans, M., Ferreira, A. M., Johnson, R., Jungreis, I., Loveland, J., Mudge, J. M., Sisu, C., Wright, J., Armstrong, J., Barnes, I., Berry, A., Bignell, A., Carbonell Sala, S., Chrast, J., Cunningham, F., Di Domenico, T., Donaldson, S., Fiddes, I. T., García Girón, C., … Flicek, P. (2019). GENCODE reference annotation for the human and mouse genomes. Nucleic acids research, 47(D1), D766–D773. https://doi.org/10.1093/nar/gky955
 
 
- R Core Team (2018). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. https://www.R-project.org/.
 
 
- Love, M. I., Huber, W., & Anders, S. (2014). Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome biology, 15(12), 550. https://doi.org/10.1186/s13059-014-0550-8
 
 
- Andrews S. (2010). FastQC: a quality control tool for high throughput sequence data. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc
 
 
- Ewels, P., Magnusson, M., Lundin, S., & Käller, M. (2016). MultiQC: summarize analysis results for multiple tools and samples in a single report. Bioinformatics (Oxford, England), 32(19), 3047–3048. https://doi.org/10.1093/bioinformatics/btw354
 
 
- Smith, T., Heger, A., & Sudbery, I. (2017). UMI-tools: modeling sequencing errors in Unique Molecular Identifiers to improve quantification accuracy. Genome research, 27(3), 491–499. https://doi.org/10.1101/gr.209601.116
 
 
- Martin, M. (2011). Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet.journal, 17(1), pp. 10-12. https://doi.org/10.14806/ej.17.1.200
 
 
- Dobin, A., Davis, C. A., Schlesinger, F., Drenkow, J., Zaleski, C., Jha, S., Batut, P., Chaisson, M., & Gingeras, T. R. (2013). STAR: ultrafast universal RNA-seq aligner. Bioinformatics (Oxford, England), 29(1), 15–21. https://doi.org/10.1093/bioinformatics/bts635
 
 
- Sievert, C. (2020). Interactive Web-Based Data Visualization with R, plotly, and shiny. New York: Chapman and Hall/CRC, https://doi.org/10.1201/9780429447273

