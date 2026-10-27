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

## ---- define-display-labels
# Readable names for variables and categories in exported tables. Used only when
# tables are saved (R/tables.R); the analysis itself uses the original names.
display_variable_labels <- c(
  Sex = "Sex",
  TransplantOrgan = "Transplanted organ",
  RACE = "Race",
  CaseOrControl = "Case status",
  STEROID = "Corticosteroids",
  DrugCNI = "Calcineurin inhibitor",
  DrugMycophenolate = "Mycophenolate",
  DrugMTOR = "mTOR inhibitor",
  CNSDisease = "CNS cryptococcosis",
  AGE = "Age (years)",
  GXMIgG = "GXM-IgG (1/titer)",
  GXMIgM = "GXM-IgM (1/titer)",
  LAMIgG = "Lam-IgG (1/titer)",
  LAMIgM = "Lam-IgM (1/titer)",
  IgM = "IgM (µg/mL)",
  IgG1 = "IgG1 (µg/mL)",
  IgG2 = "IgG2 (µg/mL)",
  log_GXMIgG = "GXM-IgG (log 1/titer)",
  log_GXMIgM = "GXM-IgM (log 1/titer)",
  log_LAMIgG = "Lam-IgG (log 1/titer)",
  log_LAMIgM = "Lam-IgM (log 1/titer)",
  log_IgM = "IgM (log µg/mL)",
  log_IgG1 = "IgG1 (log µg/mL)",
  log_IgG2 = "IgG2 (log µg/mL)"
)

yes_no <- c("FALSE" = "No", "TRUE" = "Yes")
display_level_labels <- list(
  Sex = c(M = "Male", F = "Female"),
  RACE = c(W = "White", B = "Black"),
  DrugCNI = yes_no,
  DrugMycophenolate = yes_no,
  DrugMTOR = yes_no,
  CNSDisease = yes_no
)
