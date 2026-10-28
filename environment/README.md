# Environment and execution notes

## Software

The selected R scripts explicitly load the `nlme` package.

Install the package in R using:

```r
install.packages("nlme")
```

## Input configuration

The selected scripts use variables such as `data_path` and `input_dir`.

Configure these paths for the local repository before running the
scripts. Do not rely on personal Google Drive or Colab paths.

## Reproducibility status

The presence of scripts and selected input files does not by itself
prove that an analysis runs end to end.

Before claiming independent reproducibility, verify:

1. All required input files are available.
2. Input and output paths are configured.
3. Required R packages are installed.
4. Model assumptions and exclusions are documented.
5. The scripts execute successfully in a clean environment.

Record the tested R version and package versions only after checking
them in a documented environment.
