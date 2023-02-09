# Load required R packages 
library(readxl)
library(tidyverse)
library(rstatix)
library(ggpubr)

# Prepare the data and inspect a random sample of the data
setwd("C:/GitHub/Perception-Project/Dan/Data Processing and Analysis/WholeVsLocal/")
Wdata<- read_excel("DataFormatForStats_WholeVLocal.xlsx", sheet = "Whole Avg ES Full GC") %>%
	filter(Perceived == 1) %>%
	as_tibble()
Wdata %>% sample_n(6)

Wdata <- select(WBAMFront, WBAMTrans, WBAMSag, CoMPosx, CoMPosy, CoMPosz, CoMVelx, CoMVely, CoMVelz, CoMAccx, CoMAccy, CoMAccz, Perceived)
summary(Wdata)



Ldata<- read_excel("DataFormatForStats_WholeVLocal.xlsx", sheet = "Local Avg ES Full GC")