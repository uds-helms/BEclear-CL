# BEclear-CL

## Description
Correction of batch effects with [BEclear](https://bioconductor.org/packages/release/bioc/html/BEclear.html) as a command line tool.
If you have any issues regarding the core program, please visit the [originial BEclear repository](https://github.com/uds-helms/BEclear/issues).

## Installation

```bash
git clone git@github.com:uds-helms/BEclear-CL.git
cd BEclear-CL
## check and install required packages
Rscript install_requirements.R
chmod +x BEclearCL.R
```

## Usage example

Accessing the help pages:

```bash
./BEclearCL.R -h
```

Simple usage example:

```bash
./BEclearCL.R -f testDataSet.txt -o testImputed.txt -s testSamples.txt
```

Using BEclearCL in a pipeline:

```bash
cat test.txt | ./BEclearCL.R -w
```

## Additional Help

A more detailed description of the tool can be found in the [Documentation.pdf](https://github.com/uds-helms/BEclear-CL/blob/master/doc/Documentation.pdf).

## Citation

Akulenko, R., Merl, M., & Helms, V. (2016). BEclear: Batch effect detection and 
adjustment in DNA methylation data. PLoS ONE, 11(8), 1–17.
https://doi.org/10.1371/journal.pone.0159921
