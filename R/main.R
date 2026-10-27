# Purpose: run the full analysis in dependency order.
# Run from the project root in a fresh R session. Requires the restricted study
# workbook at the path set in R/setup.R (data-raw/ by default; never committed).

source("R/setup.R")
source("R/functions.R")
source("R/import_clean.R")
source("R/modeling.R")
source("R/pca.R")
source("R/tables.R")
source("R/figures.R")
