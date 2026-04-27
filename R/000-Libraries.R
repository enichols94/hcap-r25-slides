# =============================================================================
# R/00-Libraries.R
#
# Purpose: Load all required libraries for FPE Memory analysis
#
# =============================================================================

library(here)        # Project-relative paths
library(tidyverse)   # Data wrangling and visualization
library(haven)       # Read/write Stata files
library(mirt)        # Item response theory and latent variable models
library(lavaan)      # Structural equation modeling
library(knitr)       # Dynamic report generation
library(kableExtra)  # Enhanced tables for HTML/PDF output
library(skimr)       # Summary statistics tables

# rethinking for precis
devtools::install_github("rmcelreath/rethinking@slim")
library(rethinking)

# Load RNJmisc from GitHub, we'll use the svalues, z1, include commands
devtools::install_github("rnj0nes/RNJmisc", force = TRUE)

# Set CRAN mirror and install MplusAutomation
options(repos = c(CRAN = "https://cran.r-project.org"))
tryCatch({
  if (!require("MplusAutomation", quietly = TRUE)) {
    install.packages("MplusAutomation")
    library(MplusAutomation)
  }
}, error = function(e) {
  warning("Could not install/load MplusAutomation: ", e$message)
})
