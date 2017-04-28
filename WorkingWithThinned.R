library(vcfR)
library(adegenet)
library(readr)
library(dplyr)

input <- readline("Thinned VCF? ")
test <- read.vcfR(input)
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

newSampleDF <- as.data.frame(newSampleList)
new <- df
# using lapply, loop over columns and match values to the look up table. store in "new".
new <- lapply(newSampleDF, function(x) SpeciesAssignments$Species[match(x, SpeciesAssignments$`Stacks sample label`)])

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

pop(gl)=factor(admix.cols,levels=c("green3", "darkorange", "red", "grey30", "blue", "hotpink"))
cols = c("green3", "darkorange", "red", "grey30", "blue", "hotpink", "olivedrab1", "gold", "skyblue","green4" )

#### for three species PCA, so as not to confuse colors with 5-Q admixture PCA
cols = c("gold", "skyblue", "green4")
str(pop(gl))

pca=glPca(gl,nf=3)

#col=c("red","orange","green2","blue")


s.class(pca$scores[],pop(gl),col=transp(cols,0.5),cstar=1,cellipse=0,clabel=0,axesell=F,grid=F,cpoint=2)

# or add ellipses and labels!
s.class(pca$scores[],pop(gl),col=transp(cols,0.5),cstar=1,cellipse=1,clabel=1,axesell=F,grid=F,cpoint=2)
