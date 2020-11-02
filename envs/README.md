When you have multiple tasks to analyze a data and you need to use several packages, you have to avoid dependency conflicts. The solution to this problem is using multiple programming envrinments and install packages carefully for certain tasks separately. 

Therefore, it's recommended to install and use Conda package manager [link](https://docs.anaconda.com/anaconda/install/)!

## Alignment and QC tasks
```
conda env create -f alignment.yml
```

## Differential expression analysis
```
conda env create -f deseq2.yml
```

## Exploratory data analysis
Jupyter! Make sure to install [Jupyter](https://anaconda.org/anaconda/jupyter) and `nb_conda_kernels` [link](https://anaconda.org/conda-forge/nb_conda_kernels) in the base environment. Using `nb_conda_kernels`, you can have one Jupyter installed in your system and launch different python or R kernels for any created conda environments in a single notebook. 

You only need `ipykernel`, `numpy` and `pandas` from `anaconda` channel in each environment in addition to your own packages. If you have python and R packages together, only after you have R installed through conda, you can install `rpy2` through `pip` - https://pypi.org/project/rpy2/. 

Instead, you can include R kernel to an envrinment with R packages. So, install `irkernel` from `r` channel - https://anaconda.org/r/r-irkernel. 
