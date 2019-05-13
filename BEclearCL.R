#!/usr/bin/env Rscript

chooseCRANmirror(ind = 1)

## Check R version
if(R.version$major < 3 | (R.version$major == 3 & R.version$minor < 5)){
    stop("Your R version is too old. Please install a version greater or equal 3.5")
}

if (!requireNamespace("Biobase", quietly = TRUE)){
    if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
    BiocManager::install("Biobase")
}
    
suppressPackageStartupMessages({
require(Biobase, quietly = TRUE)
})

## Check dependencies and if necessary install them
if(!requireNamespace("BiocManager", quietly = TRUE) | package.version("BEclear") < 2){
    if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
    
    BiocManager::install("BEclear")
}
if (!requireNamespace("optparse", quietly = TRUE))
    
    install.packages("optparse")

## Load required packages
suppressPackageStartupMessages({
l<-lapply(c("BEclear", "data.table", "futile.logger", "optparse"), require, 
          character.only = TRUE, quietly = TRUE)
})

## parsing options
## https://www.r-bloggers.com/passing-arguments-to-an-r-script-from-command-lines/
option_list = list(
    make_option(c("-f", "--file"), type="character", default=NULL, 
                help="dataset file name", metavar="character"),
    make_option(c("-d", "--detection"), default=FALSE, 
                help="Do the detection of batch effects",
                metavar="character"),
    make_option(c("-o", "--out"), type="character", default="out.txt", 
                help="output file name [default= %default]", metavar="character")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

## Prepare BiocParallelParam
bpparam <- MulticoreParam(workers = 2)
tmp <- flog.threshold(ERROR)

## Read from stdin
input<-file('stdin', 'r')
data <- read.table(input, header = T, sep = "\t")

if(opt$detection){
    
}

data <- imputeMissingData(data, BPPARAM = bpparam )

write.table(data, "", sep = "\t",row.names = TRUE, col.names = TRUE)

# if (is.null(opt$file)){
#     print_help(opt_parser)
#     stop("At least one argument must be supplied.", call.=FALSE)
# }


