# Setup your system
To avoid dependency conflicts, having multiple programming envrinments is the right way to install packages. Therefore, it's recommended to easily install and use Conda package manager - [link](https://docs.anaconda.com/anaconda/install/)!

This pipeline have two envrinments for two set of tasks:

### 1. Alignment and QC tasks
#### Make envrinment:
```bash
conda env create -f alignment.yml
```

### 2. Differential expression analysis
#### Make envrinment:
```bash
conda env create -f deseq2.yml
```
