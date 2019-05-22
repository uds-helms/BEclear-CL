#!/usr/bin/env Rscript

## Load required packages
suppressPackageStartupMessages({
l<-lapply(c("BEclear", "data.table", "futile.logger", "optparse"), require, 
          character.only = TRUE, quietly = TRUE)
})

## parsing options
## https://www.r-bloggers.com/passing-arguments-to-an-r-script-from-command-lines/
option_list = list(
    make_option(c("-f", "--file"), type="character", default=NULL, 
                help="dataset file name. If not set, STDIN is used", metavar="character"),
    make_option(c("-o", "--out"), type="character", default=NULL, 
                help="output file name. If not set, STDOUT is used", 
                metavar="character"),
    make_option(c("-d", "--detection"), default=FALSE, action = "store_true", 
                help="Do the detection of batch effects"),
    make_option(c("-s", "--samples"), type="character", default=NULL, 
                help="Path to a file assigning each sample to a batch.",
                metavar="character"),
    make_option(c("-c", "--cores"), type="numeric", default=1, 
                help="The number of workers for parallelisation",
                metavar="numeric"),
    make_option(c("-b", "--BEscore"), type="character", default=NULL, 
                help="Path to a file where the table with BEscores should be stored.",
                metavar="character"),
    make_option(c("-v", "--verbose"), default=FALSE, action = "store_true",
                help="Write informative output to the STDOUT."),
    make_option(c("-r", "--replace"), default=FALSE, action = "store_true",
               help="Replace values outside the interval between 0 and 1.")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

## Prepare BiocParallelParam
bpparam <- SnowParam(workers = opt$cores)
if(opt$verbose){
    tmp <- flog.threshold(INFO)
}else{
    tmp <- flog.threshold(ERROR)
}


## Read input

if(is.null(opt$file)){
    input <- file('stdin', 'r')
}else{
    input<-file(opt$file, 'r')
}
data <- read.table(input, header = T, sep = "\t")

if(opt$detection){
    if(is.null(opt$samples)){
        ## setting samples as batches
        samples <- data.table(sample_id = colnames(data), 
                              batch_id = colnames(data))
    }else{
        ## reading in samples file
        samples <- fread(opt$samples)
    }
    
    # detect batch effect
    batchEffects <- calcBatchEffects(data = data, samples = samples)
    med <- batchEffects$med
    pvals <- batchEffects$pval
    
    ## Summarize p-values and median differences for batch affected genes
    sum <- calcSummary(medians = med, pvalues = pvals)
    
    if(!is.null(opt$BEscore)){
        score.table <- calcScore(data = data, samples = samples, 
                                 summary = sum, dir = getwd())
        fwrite(score.table, file = opt$BEscore)
    }
    
    data <- clearBEgenes(data = data, samples = samples, summary = sum)
    
}

data <- imputeMissingData(data, BPPARAM = bpparam)

if(opt$replace){
    data <- replaceOutsideValues(data)
}

out <- opt$out
if(is.null(out)){
    out <- ""
}
write.table(data, out, sep = "\t",row.names = TRUE, col.names = TRUE)

