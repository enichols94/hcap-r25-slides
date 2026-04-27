# =============================================================================
# R/01-Environment-settings.R
#
# Purpose: Define paths and environmental settings for FPE Memory analysis
#
# Prerequisites:
#   - R/00-Libraries.R must be sourced before this file
#   - Current working directory should be the project root
#
# =============================================================================

# Project root
proj_root <- here::here()

# ---- Paths to External Workflow Data (2022 Data Report) ----
# HRS/HCAP 2022 data from the Data_Report workflow
# Data_Report_20250924 is a sibling folder within HCAP16_Algorithm_in_HCAP22
data_report_workflow <- file.path(
  dirname(proj_root),
  "Data_Report_20250924"
)

# ---- Local Project Paths ----
path_stata_dta    <- here::here("Stata", "DTA")
path_stata_output <- here::here("Stata", "MPLUS_OUTPUT")
path_figures      <- here::here("FIGURES")
path_md           <- here::here("MD")
path_references   <- here::here("REFERENCES")
path_r            <- here::here("R")
path_rdata        <- here::here("R", "RDATA")

# ---- HCAP 2016 Data ----
# Path to 2016 HCAP data with vdmde2 (verbatim memory scores)
file_hcap16_data <- "/Users/rnj/Library/CloudStorage/Dropbox/Work/HCAP23/POSTED/ANALYSIS/Integrated_Analysis_fork_EAP/w021.dta"

# ---- HCAP 2022 Data ----
# Path to 2022 HCAP data from the Data_Report workflow
file_hcap2022_data <- file.path(
  data_report_workflow,
  "Stata", "DTA", "w021.dta"
)

# ---- HCAP 2016 Derived Data (EAP estimates) ----
# Based on Stata macro: $derivedhcap16EAP
# This references the 2016 algorithm output from the Data_Report workflow
path_hcap16_eap <- file.path(
  data_report_workflow,
  "Stata", "MPLUS_OUTPUT"
)

# ---- Color Palette ----
# Parameters (match Stata locals)
I <- 0.85   # intensity multiplier for RGB channels

# Helper: build an R color with intensity-scaled RGB
mk_col <- function(r, g, b, I = 1) {
  r <- pmin(255, pmax(0, round(r * I)))
  g <- pmin(255, pmax(0, round(g * I)))
  b <- pmin(255, pmax(0, round(b * I)))
  rgb(r, g, b, maxColorValue = 255)
}

# Colors (equivalent to Stata locals)
color_red      <- mk_col(237,  28,  36, I)
color_brown    <- mk_col( 78,  54,  41, I)
color_gold     <- mk_col(255, 199, 144, I)
color_skyblue  <- mk_col( 89, 203, 232, I)
color_emerald  <- mk_col(  0, 179, 152, I)
color_navy     <- mk_col(  0,  60, 113, I)
color_taupe    <- mk_col(183, 176, 156, I)

# ---- Create directories if they don't exist ----
dir.create(path_stata_dta, showWarnings = FALSE, recursive = TRUE)
dir.create(path_stata_output, showWarnings = FALSE, recursive = TRUE)
dir.create(path_rdata, showWarnings = FALSE, recursive = TRUE)
dir.create(path_md, showWarnings = FALSE, recursive = TRUE)

# ---- Verification ----
# Print confirmation of paths
cat("\n=== FPE Memory Analysis Environment ===\n")
cat("Project root:", proj_root, "\n")
cat("HCAP 2016 data file:", file_hcap16_data, "\n")
cat("HCAP 2022 data file:", file_hcap2022_data, "\n")
cat("Stata output:", path_stata_output, "\n")
cat("Figures:", path_figures, "\n")

# Here is a function that scans an R file, identifies sections based on your # comments, 
# and creates a named list (an object) in your environment.
get_script_ranges <- function(file_path) {
  if (!file.exists(file_path)) stop("File not found!")
  
  lines <- readLines(file_path)
  n_lines <- length(lines)
  
  # 1. Identify all blank lines (or lines with only whitespace)
  blank_lines <- which(grepl("^\\s*$", lines))
  
  # Add virtual boundaries for the start and end of the file
  boundaries <- sort(unique(c(0, blank_lines, n_lines)))
  
  ranges_list <- list()
  
  # 2. Iterate through segments between boundaries
  for (i in 1:(length(boundaries) - 1)) {
    start_idx <- boundaries[i] + 1
    end_idx   <- boundaries[i + 1]
    
    # Skip if the segment is empty (e.g., double blank lines)
    if (start_idx > end_idx) next
    
    # 3. Check if the first non-blank line in this segment is a comment
    segment_content <- lines[start_idx:end_idx]
    first_line <- segment_content[grep("\\S", segment_content)[1]]
    
    if (!is.na(first_line) && grepl("^#", first_line)) {
      # Create a key from that first comment line
      label <- gsub("^#\\s*|\\s*$", "", first_line)
      clean_key <- gsub("[^a-zA-Z0-9]", "_", tolower(label))
      
      # Ensure key is valid
      if (nchar(clean_key) == 0) clean_key <- paste0("chunk_", start_idx)
      if (grepl("^[0-9]", clean_key)) clean_key <- paste0("v_", clean_key)
      
      # Store the range
      ranges_list[[clean_key]] <- paste0(start_idx, "-", end_idx)
    }
  }
  
  # --- Object Naming ---
  file_name <- tools::file_path_sans_ext(basename(file_path))
  clean_file_name <- gsub("[-.]", "_", file_name)
  obj_name <- paste0("ranges_", clean_file_name)
  
  assign(obj_name, ranges_list, envir = .GlobalEnv)
  message(paste0("Ranges created in: ", obj_name))
}