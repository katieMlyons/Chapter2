#source("http://bioconductor.org/biocLite.R")
#biocLite("gdsfmt")
#biocLite("SNPRelate")

library(SNPRelate)
library(readr)
library(dplyr)
library(ggplot2)

full <- read_csv("RawData/SI Appendix 1 sampling.csv") #get species to pop assignments
full %>%
  select(`Stacks sample label`, `Species`) %>%
  filter(Species %in% c("tonkawae", "naufragia", "chisholmensis")) %>%
  mutate(`Stacks sample label` = gsub(" _", "_", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub(" \\(duplicate\\)", "", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub("Smiths_Spring", "Smiths_Spg", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub("30_Smiths_Spg", "30_Smiths_Spring", `Stacks sample label`)) %>%
  unique() -> SpeciesAssign



#makeGDA <- snpgdsVCF2GDS("~/Desktop/northonly.vcf", "~/Desktop/northonlyGDS")
# only need to do this once
# .gds file shows up in directory

genofile <- snpgdsOpen("~/Desktop/northonlyGDS")

snpset<-snpgdsLDpruning(genofile, ld.threshold=0.1, autosome.only=FALSE)
# recovered 34134 SNPS from 58561 Chromosomes?? skipped over some chroms
snpset.id <- unlist(snpset)
pca<-snpgdsPCA(genofile, snp.id=snpset.id, autosome.only=FALSE)

pc.percent <- pca$varprop*100

tab<-data.frame(sample.id=pca$sample.id, EV1=pca$eigenvect[,1], EV2=pca$eigenvect[,2], stringsAsFactors=FALSE)
tab %>%
  left_join(SpeciesAssign, c('sample.id' = 'Stacks sample label')) -> merged

colors <- as.factor(merged$Species)
plot(merged$EV1, merged$EV2, col=colors) #works but looks crappy
qplot(merged$EV1, merged$EV2, color = colors) #looks a little better
