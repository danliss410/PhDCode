# Load required R packages 
library(readxl)
library(tidyverse)
library(rstatix)
library(ggpubr)

# Prepare the data and inspect a random sample of the data
setwd("C:/GitHub/Perception-Project/Dan/Data Processing and Analysis/WholeVsLocal/")
Wdata<- read_excel("DataFormatForStats_WholeVLocal.xlsx", sheet = "Whole Avg ES Full GC")

Ldata<- read_excel("DataFormatForStats_WholeVLocal.xlsx", sheet = "Local Avg ES Full GC")