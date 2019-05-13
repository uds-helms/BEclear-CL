## Check R version
if(R.version$major < 3 | (R.version$major == 3 & R.version$minor < 5)){
    stop("Your R version is too old. Please install a version greater or equal 3.5")
}

## Check dependencies and if necessary install them
if(!requireNamespace("BiocManager", quietly = TRUE) | package.version("BEclear") < 2){
    if (!requireNamespace("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
    
    BiocManager::install("BEclear")
}
if (!requireNamespace("optparse", quietly = TRUE))
    install.packages("optparse")

## Load required packages
l<-lapply(c("BEclear", "data.table", "futile.logger", "optparse"), require, character.only = TRUE)

