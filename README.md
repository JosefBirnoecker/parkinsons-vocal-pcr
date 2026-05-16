# Parkinson's Disease Vocal Data Analysis

## Overview
This repository contains an R-based data analysis project aimed at distinguishing healthy individuals from those diagnosed with Parkinson's Disease (PD) using non-invasive vocal measurements. The analysis employs Principal Component Analysis (PCA) for dimensionality reduction and exploratory analysis, followed by a Generalized Linear Model (GLM) for classification. Additionally, it contains a written report on the analysis, which can be found in the `output_interpretation.html` file.

## Dataset
The project utilizes the **Parkinson's Disease Data Set**, created by Max Little (University of Oxford) in collaboration with the National Centre for Voice and Speech. 
- **Size:** 195 instances from 31 individuals (23 with PD, 8 healthy controls).
- **Features:** 24 attributes, including patient ID, diagnosis status, and 22 acoustic voice measurements (e.g., fundamental frequency, frequency variation/jitter, amplitude variation/shimmer, and tonal noise).

## Project Structure
- `data/parkinsons.data`: The raw dataset used for the analysis.
- `main_pcr_on_parkinson_vocal.R`: The core R script containing the data preprocessing steps, PCA implementation, and GLM modeling.
- `output_interpretation.html`: The compiled final project report in HTML format.

## Methodology
1. **Data Preprocessing**: Data cleaning, extracting the target variable, setting appropriate patient identifiers, and checking for missing values.
2. **Principal Component Analysis (PCA)**: 
   - An initial run was performed to identify and remove outliers with high orthogonal distance (e.g., recording `phon_R01_S35_6`).
   - A subsequent run with 5 principal components analyzed the variance, residuals, and feature loadings to uncover underlying patterns between groups.
3. **Generalized Linear Model (GLM)**: 
   - A logistic regression model was trained using the first two principal components to predict the binary diagnosis status (Healthy vs. PD).
   - Evaluated model performance using predicted probabilities and a confusion matrix.

## Key Findings
- **Acoustic Differences**: The PCA loadings revealed that healthy patients tend to have higher vocal fundamental frequency and tonal measure NHR, whereas Parkinson's patients exhibit higher amplitude variation (shimmer) and frequency variation (jitter).
- **Model Performance**: The GLM demonstrated that the first two principal components are significant predictors of the disease. The model achieved an accuracy of approximately **82.5%** (160 correct predictions out of 194), showing a reasonable effectiveness in classifying the diagnosis status.

## Prerequisites
To run this analysis, you will need R installed along with the following packages:
```r
install.packages(c("tidyverse", "mdatools", "dplyr"))
```

## Usage
To reproduce the findings:
1. Clone the repository to your local machine.
2. Open the R project file (`main_pcr_on_parkinson_vocal.Rproj`) to ensure proper working directory setup.
3. Run the standalone script `main_pcr_on_parkinson_vocal.R` to view the outputs directly in RStudio
