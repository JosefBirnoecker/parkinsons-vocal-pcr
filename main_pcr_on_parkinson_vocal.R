### Analysis setup

# import libraries
library(tidyverse)
library(mdatools)
library(dplyr)

# import dataset
park_data <- as.data.frame(read.csv('data/parkinsons.data'))

# extract the independent variable "status" and remove it from the dataset of dependent variables
patient_status <- park_data[, c('name','status')]
park_data$status <- NULL

# set patient ID as rowname
rownames(park_data) <- park_data$name
park_data$name <- NULL

# check for NAs
rows_with_NAs <- park_data[!complete.cases(park_data), ]
print(rows_with_NAs)



#---------------------------------------------------------------------------------------------------

### PCA

# run PCA with 5 principal components
pca.park <- mdatools::pca(park_data, ncomp = 5, scale = TRUE, center=TRUE)

# plot variance
plotVariance(pca.park$res$cal, type = "h", show.labels = TRUE, labels = "values")
summary(pca.park)

# plot residuals
plotResiduals(pca.park, show.labels = TRUE)
plot(pca.park)

# remove outliers
outlier_list <- c("phon_R01_S35_6")
park_final <- park_data[!(rownames(park_data) %in% outlier_list), ]
patient_status <- patient_status %>%
  filter(!name %in% outlier_list)

# run PCA after outlier-removal
pca.park_final <- mdatools::pca(park_final, ncomp = 5, scale = TRUE, center=TRUE)

# plot variance
plotVariance(pca.park_final$res$cal, type = "h", show.labels = TRUE, labels = "values")
summary(pca.park_final)

# plot residuals
plotResiduals(pca.park_final, show.labels = FALSE)

# plot pca summary
plot(pca.park_final)

# plot PC1 vs PC2
par(mfrow = c(1, 2))
plotScores(pca.park_final, c(1, 2), show.labels = FALSE, cgroup = patient_status[,'status'])
plotLoadings(pca.park_final, c(1, 2), show.labels = TRUE)

#---------------------------------------------------------------------------------------------------

### GLM

#extract PCA scores
pca.park_scores <- as.data.frame(pca.park_final$res$cal$scores)

# extract the first 2 principle components for the GLM
glm_data <- pca.park_scores %>%
  select("Comp 1","Comp 2")

# add dependent variable "status" to the df
glm_data$status <- patient_status$status

# create GLM model
glm_park <- glm(status ~ `Comp 1` + `Comp 2`, data = glm_data, family = binomial)
# model summary
summary(glm_park)

### GLM Model QC

# Get the predicted probabilities for each patient (ranges from 0 to 1)
predicted_probs <- predict(glm_park, type = "response")

# Convert probabilities to a hard 0 or 1 prediction (using 0.5 as the cutoff)
predicted_status <- ifelse(predicted_probs > 0.5, 1, 0)

# Build a confusion matrix to see True Positives, False Positives, etc.
table(Predicted = predicted_status, Actual = glm_data$status)
