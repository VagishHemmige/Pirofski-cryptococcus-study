# Purpose: attach every package the analysis uses and define shared constants.
# Needs: nothing. Produces: attached packages and the location of the study data.
# Source: the "library" chunk of the original 2022 R Markdown file, unchanged.

## ---- load-packages
#Imports packages needed for the analysis

library(tidyverse)
library(gtsummary)
library(stringr)
library(readxl)
library(ggbeeswarm)
library(ggplot2)
library(ggpubr)
library(haven)
library(pROC)
library(broom)
library(corrplot)
library(factoextra)
library(flextable)
library(bstfun)
library(cutpointr)

## ---- define-constants
# Location of the study workbook. The workbook is restricted and is never
# committed: data-raw/ is listed in .gitignore. Place your authorized copy there,
# or change this path to wherever you keep it.
raw_data_path <- "data-raw/transUABallData012219 (1).xls"
raw_data_sheet <- "Data"

# Output folders for exported tables and figures
tables_dir <- "tables"
figures_dir <- "figures"
