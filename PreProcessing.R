library(vcfR)
library(adegenet)



#X <- scaleGen(test, NA.method = "asis")

#testClust <- find.clusters.genind(test)

#testPCA <- dapc(X)


test <- read.vcfR("~/Desktop/NoPairsNorth.vcf")
gl <- vcfR2genlight(test)
str(gl)



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


## go into instructions.txt and generate new vcf file called "thinned"

