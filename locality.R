library(readr)
library(dplyr)
library(geosphere)


full <- read_csv("RawData/SI Appendix 1 sampling.csv")

full %>% 
  select(long, lat, `Locality label`) %>%
  unique() -> justGPS

# OK, now we have a tibble with lat, long, and site
# do the same thing but just for the northern species

full %>%
  filter(Species %in% c("tonkawae", "naufragia", "chisholmensis")) %>%
  select(long, lat, `Locality label`, Species) %>%
  unique() -> northGPS

northLongLat <- cbind(northGPS$long, northGPS$lat) #pairwise long-lat rows for distm fxn
northDistMat <- distm(northLongLat) #distance matrix using great circle distance
rownames(northDistMat) <- northGPS$`Locality label`
colnames(northDistMat) <- northGPS$`Locality label`

# doing this just for tonkawae
full %>%
  filter(Species == "tonkawae") %>%
  select(long, lat, `Locality label`, Species) %>%
  unique() -> tonkawaeGPS

tonkLongLat <- cbind(tonkawaeGPS$long, tonkawaeGPS$lat)
tonkDistMat <-distm(tonkLongLat)
rownames(tonkDistMat) <- tonkawaeGPS$`Locality label`
colnames(tonkDistMat) <- tonkawaeGPS$`Locality label`

# make object linking samples to populations
full %>%
  select(`Stacks sample label`, `Locality label`) -> sample2Pop
