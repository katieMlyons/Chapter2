library(readr)
library(dplyr)

full <- read_csv("RawData/SI Appendix 1 sampling.csv")

# create pop_assign file
full %>%
  select(`Stacks sample label`, `Locality label`) %>%
  mutate(`Stacks sample label` = gsub(" _", "_", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub(" \\(duplicate\\)", "", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub("Smiths_Spring", "Smiths_Spg", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub("30_Smiths_Spg", "30_Smiths_Spring", `Stacks sample label`)) %>%
  unique() -> popAssign

# fixed a spacing problem and removed the duplicate titles

minInd <- paste("#", unique(full$`Locality label`), ":0", sep="")
# can change the one to whatever minimum you want

write_delim(popAssign, "popAssign.txt", delim = " ", col_names = FALSE)
write_lines(minInd, "popAssign.txt", append=TRUE)
# proper format for popAssign file - 2 sections

# create pop_assign file for just north
full %>%
  filter(Species %in% c("tonkawae", "naufragia", "chisholmensis")) %>%
  select(`Stacks sample label`, `Locality label`) %>%
  mutate(`Stacks sample label` = gsub(" _", "_", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub(" \\(duplicate\\)", "", `Stacks sample label`)) %>%
  unique() -> popAssignNorth

minIndNorth <- paste("#", unique(popAssignNorth$`Locality label`), ":0", sep="")
  
write_delim(popAssignNorth, "popAssignNorth.txt", delim = " ", col_names = FALSE)
write_lines(minIndNorth, "popAssignNorth.txt", append=TRUE)

# create file of north-only samples
full %>%
  filter(Species %in% c("tonkawae", "naufragia", "chisholmensis")) %>%
  select(`Stacks sample label`) %>%
  mutate(`Stacks sample label` = gsub(" _", "_", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub(" \\(duplicate\\)", "", `Stacks sample label`)) %>%
  unique() -> popListNorth

write_delim(popListNorth, "popListNorth.txt", "\n", col_names=FALSE)

# create alphabetical list of north species for vcfR
full %>%
  mutate(`Stacks sample label` = gsub(" \\(duplicate\\)", "", `Stacks sample label`)) %>%
  filter(Species %in% c("tonkawae", "naufragia", "chisholmensis")) %>%
  select(`Stacks sample label`, Species) %>%
  unique() %>%
  select (Species) -> NorthSpeciesAlpha

write_delim(NorthSpeciesAlpha, "northSpeciesAlpha", "\n", col_names=FALSE)

# create list linking north samples to species
full %>%
  mutate(`Stacks sample label` = gsub(" \\(duplicate\\)", "", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub(" _", "_", `Stacks sample label`)) %>%
  filter(Species %in% c("tonkawae", "naufragia", "chisholmensis")) %>%
  select(`Stacks sample label`, Species) %>%
  unique() -> Ind2SpeciesNorth

write_delim(Ind2SpeciesNorth, "Ind2SpeciesNorth.txt", col_names=FALSE)

# create list of northern species for vcftools to keep
full %>%
  mutate(`Stacks sample label` = gsub(" \\(duplicate\\)", "", `Stacks sample label`)) %>%
  mutate(`Stacks sample label` = gsub(" _", "_", `Stacks sample label`)) %>%
  filter(Species %in% c("tonkawae", "naufragia", "chisholmensis")) %>%
  select(`Stacks sample label`) -> ToKeep

write_delim(ToKeep, "vcftoolsKeep.txt", col_names=FALSE)
