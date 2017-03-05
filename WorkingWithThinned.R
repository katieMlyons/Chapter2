library(vcfR)
library(adegenet)
library(readr)

test <- read.vcfR("~/Desktop/thinned.vcf")
gl <- vcfR2genlight(test)


newSampleList <- gl@ind.names

full <- read_csv("RawData/SI Appendix 1 sampling.csv") #get species list for new thinned samples

full %>%
  mutate(`Stacks sample label` = gsub(" \\(duplicate\\)", "", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub(" _", "_", `Stacks sample label`)) %>%
  filter(Species %in% c("tonkawae", "naufragia", "chisholmensis")) %>%
  select(`Stacks sample label`, Species) %>%
  unique() -> compareList

compareList %>%
  filter(`Stacks sample label` %in% newSampleList) -> SpeciesAssignments

########## Export Species Assignments for dadi (order doesn't matter)

write_delim(SpeciesAssignments, path = "DadiPopList.txt", delim = "\t", col_names = F)


########## Generate species list for gl, order matters

new <- df
# using lapply, loop over columns and match values to the look up table. store in "new".
new[] <- lapply(samplistdf, function(x) SpeciesAssignments$Species[match(x, SpeciesAssignments$`Stacks sample label`)])

pop(gl) <- new$newSampleList

########################################################################

nas = c()
for (i in 1:length(gl$gen)){
  snps = gl$gen[[i]]
  nas = append(nas, length(snps$NA.posi))
}
hist(nas/(gl@n.loc), breaks=20)

nas = nas/(gl@n.loc)




########################################################################

pca=glPca(gl,nf=3)

col=c("red","orange","green2","blue")
col=cols

s.class(pca$scores[],pop(gl),col=transp(col,0.5),cstar=1,cellipse=0,clabel=0,axesell=F,grid=F,cpoint=2)

