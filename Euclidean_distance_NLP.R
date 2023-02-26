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
library(outliers)

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

Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
Distance_vector <- vector(length = nrow(Original))
for(row_i in 1:nrow(Anonymous)){
  for(row_j in 1:nrow(Original)){
    Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
    Distance_vector[row_j] <- Euclidean
  }
Distance_matrix[row_i,]  <- Distance_vector
}

# test if there is only one correspondence in the original dataset (bad model):
Boolean_vector <- vector(length = nrow(Anonymous))
for(row_n in 1:nrow(Distance_matrix)){
  b <- 0
  a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
  if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
    b <- 1
  Boolean_vector[row_n] <- b
}
sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence


# test for threshold:
# difference_vector <- vector(length = nrow(Anonymous))
# for(row_n in 1:nrow(Distance_matrix)){
#   difference_vector[row_n] <- diff(sort(Distance_matrix[row_n,])[1:2])
# }
# 
# 
# diff(sort(Distance_matrix[6,])[1:2])
# 
# t.test(difference_vector, mu = 0)
#   
# 
# qqnorm(Distance_matrix[6,])
# shapiro.test(Distance_matrix[6,])
# 
plot(Distance_matrix[2,], main = 'Euclidean Distance for an Anonymous row', ylab = 'Distance to an Original row')
heatmap(as.matrix((as.data.frame(Distance_matrix) %>% select_if(~ !any(is.na(.))))))
# which.min(Distance_matrix[6,])


############################### 


# non-linear correlation


#############################################################################################################################################
################################### BayNet #################################################################################################

################################## sample size = 50 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/brca_mRNA_50patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/Baynet')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/Baynet/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- Euclidean
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'BayNet_50.csv')
proportion_Baynet_50 <- mean(proportion)

################################## sample size = 100 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED100patients_subsamples/1/brca_mRNA_100patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED100patients_subsamples/1/Baynet')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED100patients_subsamples/1/Baynet/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- Euclidean
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'BayNet_100.csv')
proportion_Baynet_100 <- mean(proportion)

################################## sample size = 200 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED200patients_subsamples/1/brca_mRNA_200patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED200patients_subsamples/1/Baynet')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED200patients_subsamples/1/Baynet/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- Euclidean
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'BayNet_200.csv')
proportion_Baynet_200 <- mean(proportion)

################################## sample size = 500 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED500patients_subsamples/1/brca_mRNA_500patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED500patients_subsamples/1/Baynet')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED500patients_subsamples/1/Baynet/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- Euclidean
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'BayNet_500.csv')
proportion_Baynet_500 <- mean(proportion)

################################## sample size = 1000 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1000patients_subsamples/1/brca_mRNA_1000patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1000patients_subsamples/1/Baynet')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1000patients_subsamples/1/Baynet/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- Euclidean
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'BayNet_1000.csv')
proportion_Baynet_1000 <- mean(proportion)

################################## sample size = 1977 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1977patients_subsamples/1/brca_mRNA_1977patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1977patients_subsamples/1/Baynet')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1977patients_subsamples/1/Baynet/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- Euclidean
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'BayNet_1977.csv')
proportion_Baynet_1977 <- mean(proportion)


#############################################################################################################################################
################################### MIIC #################################################################################################

################################## MIIC: sample size = 50 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/brca_mRNA_50patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/MIIC')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/MIIC/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- Euclidean
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'MIICt_50.csv')
proportion_MIIC_50 <- mean(proportion)

################################## MIIC: sample size = 100 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED100patients_subsamples/1/brca_mRNA_100patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED100patients_subsamples/1/MIIC')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED100patients_subsamples/1/MIIC/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- Euclidean
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'MIIC_100.csv')
proportion_MIIC_100 <- mean(proportion)

################################## MIIC: sample size = 200 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED200patients_subsamples/1/brca_mRNA_200patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED200patients_subsamples/1/MIIC')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED200patients_subsamples/1/MIIC/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- Euclidean
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'MIIC_200.csv')
proportion_MIIC_200 <- mean(proportion)

################################## MIIC: sample size = 500 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED500patients_subsamples/1/brca_mRNA_500patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED500patients_subsamples/1/MIIC')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED500patients_subsamples/1/MIIC/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- if_else(is.na(Euclidean), 50, Euclidean)
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'MIIC_500.csv')
proportion_MIIC_500 <- mean(proportion)

################################## MIIC: sample size = 1000 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1000patients_subsamples/1/brca_mRNA_1000patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1000patients_subsamples/1/MIIC')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1000patients_subsamples/1/MIIC/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- if_else(is.na(Euclidean), 50, Euclidean)
    }
    Distance_matrix[row_i,]  <- Distance_vector
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'MIIC_1000.csv')
proportion_MIIC_1000 <- mean(proportion)

################################## MIIC: sample size = 1977 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1977patients_subsamples/1/brca_mRNA_1977patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1977patients_subsamples/1/MIIC')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1977patients_subsamples/1/MIIC/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- if_else(is.na(Euclidean), 50, Euclidean)
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'MIIC_1977.csv')
proportion_MIIC_1977 <- mean(proportion)




#############################################################################################################################################
################################### Synthpop #################################################################################################

################################## Synthpop: sample size = 50 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/brca_mRNA_50patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/Synthpop')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED50patients_subsamples/1/Synthpop/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- if_else(is.na(Euclidean), 50, Euclidean)
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'Synthpop_50.csv')
proportion_Synthpop_50 <- mean(proportion)

################################## Synthpop: sample size = 100 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED100patients_subsamples/1/brca_mRNA_100patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED100patients_subsamples/1/Synthpop')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED100patients_subsamples/1/Synthpop/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- if_else(is.na(Euclidean), 50, Euclidean)
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'Synthpop_100.csv')
proportion_Synthpop_100 <- mean(proportion)

################################## Synthpop: sample size = 200 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED200patients_subsamples/1/brca_mRNA_200patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED200patients_subsamples/1/Synthpop')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED200patients_subsamples/1/Synthpop/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- if_else(is.na(Euclidean), 50, Euclidean)
    }
    Distance_matrix[row_i,]  <- if_else(is.na(Euclidean), 50, Euclidean)
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'Synthpop_200.csv')
proportion_Synthpop_200 <- mean(proportion)

################################## Synthpop: sample size = 500 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED500patients_subsamples/1/brca_mRNA_500patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED500patients_subsamples/1/Synthpop')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED500patients_subsamples/1/Synthpop/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- if_else(is.na(Euclidean), 50, Euclidean)
    }
    Distance_matrix[row_i,]  <- Distance_vector
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'Synthpop_500.csv')
proportion_Synthpop_500 <- mean(proportion)

################################## Synthpop; sample size = 1000 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1000patients_subsamples/1/brca_mRNA_1000patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1000patients_subsamples/1/Synthpop')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1000patients_subsamples/1/Synthpop/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- if_else(is.na(Euclidean), 50, Euclidean)
    }
    Distance_matrix[row_i,]  <- Distance_vector
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'Synthpop_1000.csv')
proportion_Synthpop_1000 <- mean(proportion)

################################## Synthpop: sample size = 1977 #####################################################

Original <- read.csv2('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1977patients_subsamples/1/brca_mRNA_1977patients.csv',
                      header = T, sep = ',')

# repeat for all files

file.path('C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1977patients_subsamples/1/Synthpop')

all_files <- list.files(path = 'C:/Users/caroline.pena/Documents/SIAM Hackaton 2023/MIXED1977patients_subsamples/1/Synthpop/', pattern = '.csv', full.names = TRUE) # the json files to be loaded

Anonymous <- tibble() # empty tibble to store the data

i =1
proportion <- c() # empty vector to store proportions
for(file in all_files){
  Anonymous <- read.csv2(file, header = T, sep = ',') # from csv
  # distribution of distances 
  
  Distance_matrix <- matrix(nrow = nrow(Anonymous), ncol = nrow(Original))
  Distance_vector <- vector(length = nrow(Original))
  for(row_i in 1:nrow(Anonymous)){
    for(row_j in 1:nrow(Original)){
      Euclidean <- sqrt(sum(stringdist(Anonymous[row_i,],Original[row_j,], method='jaccard'))^2)
      Distance_vector[row_j] <- if_else(is.na(Euclidean), 50, Euclidean)
    }
    Distance_matrix[row_i,]  <- Distance_vector
  }
  
  # test if there is only one correspondence in the original dataset (bad model):
  Boolean_vector <- vector(length = nrow(Anonymous))
  for(row_n in 1:nrow(Distance_matrix)){
    b <- 0
    a <- grubbs.test(Distance_matrix[row_n,]) # H0: there is NO outlier, Ha: there IS outlier
    if(a$p.value < 0.05) # there is outlier, so change the boolean variable to TRUE
      b <- 1
    Boolean_vector[row_n] <- b
  }
  proportion[i] <- sum(Boolean_vector)/length(Boolean_vector) # proportion of rows that have only one correspondence (NOT PRIVATE)
  i = i+1
}
write.csv2(proportion, 'Synthpop_1977.csv')
proportion_Synthpop_1977 <- mean(proportion)


Distance_vector
