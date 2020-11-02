When you have multiple tasks to analyze a data, then you need to use several packages. To avoid dependency conflicts, having multiple programming envrinments is the right way to install packages carefully. Each envrinment should specify for certain tasks. 

Therefore, it's recommended to easily install and use Conda package manager - [link](https://docs.anaconda.com/anaconda/install/)!

# Setup your system
Here we have two envrinments:
### 1. Alignment and QC tasks
```
conda env create -f alignment.yml
```

### 2. Differential expression analysis
```
conda env create -f deseq2.yml
```

# Exploratory data analysis
Jupyter! Make sure to install [Jupyter](https://anaconda.org/anaconda/jupyter) and [`nb_conda_kernels`](https://anaconda.org/conda-forge/nb_conda_kernels) in the base environment. Using `nb_conda_kernels`, you can have one Jupyter installed in your system and launch different python or R kernels for any created conda environments in a single notebook. 

You only need `ipykernel`, `numpy` and `pandas` in each environment in addition to your own packages. 
```
conda install -n <env-name> -c anaconda ipykernel numpy pandas
```
### How to use R in Jupyter?
If you want to use python and R packages together, you can use `rpy2`. After you have R installed through conda, you can install [`rpy2`](https://pypi.org/project/rpy2/) through `pip`.

Instead, you can include R kernel into an envrinment with R packages. So, install [`irkernel`](https://anaconda.org/r/r-irkernel). 
