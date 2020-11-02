## Preprocessing
First, we aim to remove UMI sequences from the Illumina reads using the `umi_tools extract` command. Then, we use Cutadapt to remove low quality and short reads. Processed fastq files will save into `fastq-processed/trim` subfolder in the `<parent-dir>`. 

```
bash process_fastq.sh <parent-dir> <fastq-dir> <#of-jobs>
```

Using the STAR aligner (Dobin et al., 2013), fastq files were aligned against the `GENCODE v.34` human reference genome.
Outputs in `bam` format will save into `bam` subfolder in the `<parent-dir>`.

```
bash alignment.sh <parent-dir> fastq-processed/trim <#of-jobs>
```

We aimed to process BAM files from the STAR run using `umi_tools dedup` to detect duplicate reads. 
Outputs are again in `bam` format; this time, they will save into `bam-processed` subfolder in the `<parent-dir>`.

```
bash umi_dedup.sh <parent-dir> bam <#of-jobs>
```

Gene level counts measured using the HTSeq package. STAR and HTSeq command options selected as suggested in the QuantSeq FWD kit data analysis manual. 

```
bash htseq-count.sh <parent-dir> bam-processed/ htseq-count 
```

## Quality controls 
Fastq files and the pre-processing steps were assessed for quality control using the FastQC and multiQC programs. 
```
bash fastqc.sh <parent-dir> <fastq-dir> <fastQC-dir> <#of-jobs> 
```

```
multiqc htseq-count logs/ -n mutiqc-preprocessing
```

## Downstream analysis 
Further data analysis and visualization occurred in R. HTSeq counts processed using the DESeq2 package and a DESeq object contain all samples created. First, the `varianceStabilizingTransformation` function from DESeq2 used for the Principal Component Analysis (PCA). The first three PCs were selected for a 3-D scatter plot visualization using the R-Plotly package. For heatmap visualizations, Normalized counts extracted from the DESeq object, genes with less than 10 counts in all samples were removed as low expressed genes, and also, normalized across samples (SD = 1, mean ~=0) for each gene. 

Current R script save raw counts, normalized counts, a histogram of most variant genes across samples, and a 3-D PCA plot (HTML format). You can filter out samples in the HTML report to see examples such as the attached png file to see how your samples are distinguishable through PCs. 


```
Rscript DESeq.R <parent-dir> htseq-count CHLG01_samplesheet.txt 18
```

```
nohup ls ipage/*.txt | parallel -j18 -k bash ipage_human_ensembl.sh {} &> ipage.out &
```

Note: you can run each line with `nohup` in this format to run your command on the background:

```
nohup '<program>' '<options>' > '<log-file.txt> &'
```

## Dependencies
`alignment` environment:


`deseq2` environment:



## References
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

