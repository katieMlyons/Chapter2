library(vcfR)
library(adegenet)

### doing PCA on north only samples
### load structure (thinned)

### 270 lines (2*135 samples)
### 20835 cols
### nonthinned is 19957 cols
### first col is sample name

### copied .ustr to .stru


#test <- read.structure('~/Desktop/northonly.stru', n.ind = 135, , col.lab = 1, onerowperind = FALSE, n.loc = 20834, ask = FALSE)

#X <- scaleGen(test, NA.method = "asis")

#testClust <- find.clusters.genind(test)

#testPCA <- dapc(X)


### Scratch that, there is a way to read in .vcf files
### PROBLEM, these files are NOT thinned

test <- read.vcfR("~/Desktop/NoPairsNorth.vcf")
# @fix: 8 column matrix to hold the fixed data BUT this vcf has 9 columns
# format column is in @gt : i think this is OK?

gl <- vcfR2genlight(test)

str(gl)

pops = read_lines('SampleData/northSpeciesAlpha') # FIX THIS, not necessarily in right order
pop(gl) = pops # fix length


#tallying missing genotypes
nas = c()
for (i in 1:length(gl$gen)){
  snps = gl$gen[[i]]
  nas = append(nas, length(snps$NA.posi))
}
hist(nas/(gl@n.loc), breaks=20)

nas = nas/(gl@n.loc)

bads = data.frame(cbind(gl$ind.names[nas>0.90]))
write.table(bads, row.names=F, quote=F, file="~/Desktop/bads.tab")

