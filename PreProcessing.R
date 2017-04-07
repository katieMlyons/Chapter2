#!/usr/bin/env Rscript

library(vcfR)
library(adegenet)
library(parallel)



#X <- scaleGen(test, NA.method = "asis")

#testClust <- find.clusters.genind(test)

#testPCA <- dapc(X)

input <- readline("VCF file? ") #initial: NoPairsNorth.vcf
test <- read.vcfR(input)
gl <- vcfR2genlight(test) #omits loci with more than two alleles
str(gl)

gl@n.loc # number of SNPs
str(gl@chromosome) # number of loci

## how many SNPs per loci?
## get from vcfR object
SNPsByLocus = as.data.frame(test@fix)
length(SNPsByLocus)
PerLocusTable = table(SNPsByLocus$CHROM)
max(PerLocusTable) # greatest number of SNPs per locus
hist(PerLocusTable) # summary of SNPs per locus

#tallying missing genotypes
nas = c()
for (i in 1:length(gl$gen)){
  snps = gl$gen[[i]]
  nas = append(nas, length(snps$NA.posi))
} #get number of NA SNPs per individual
hist(nas/(gl@n.loc), breaks=20)

nas = nas/(gl@n.loc) # get NAs into percent missing

num = 0.90 # pick threshold of missing data above which to discard individuals
bads = data.frame(cbind(gl$ind.names[nas>num]))

filename = strsplit(basename(input), ".", fixed=TRUE)[[1]][1]
write.table(bads, row.names=F, col.names = F, quote=F, file= paste ("bads.", num*100, ".", filename,".tab", sep=""))


## go into instructions.txt and generate new vcf file called "thinned"