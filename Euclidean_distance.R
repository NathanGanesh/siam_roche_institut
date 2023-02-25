###############################
### SIAM Hackaton 2023 
### Correlation metrics between matrices
### Author: Caroline Pena
### Date: 26/02/2023
##############################
rm(list = ls()) # tidy work space
gc()

library(tidyverse)
library(stringdist)

############################################# Data reading: ###################################################
Anonymous <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/Baynet/brca_mRNA_patients_BayNet_n20_deg2_eps0_seed_1.csv',
                       header = T, sep = ',')

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/brca_mRNA_50patients.csv',
                      header = T, sep = ',')


################################ Distance to the closest record (DCR): #############################################

closest_match <- as.data.frame(Original[which.min(Reduce(`+`,Map(stringdist,Original, Anonymous[1,], method='jaccard'))),])
Euclidean <- sqrt(sum(stringdist(Anonymous[1,],Original[as.numeric(row.names(closest_match)),])^2))



Distance_vector <- vector(length = nrow(Anonymous))
for(row_i in 1:nrow(Anonymous)){
  closest_match <- as.data.frame(Original[which.min(Reduce(`+`,Map(stringdist,Original, Anonymous[row_i,], method='jaccard'))),])
  Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[as.numeric(row.names(closest_match)),])^2))
  Distance_vector[row_i] <- Euclidean
}

mean(Distance_vector)

# distribution of distances 


############################### 


# non-linear correlation