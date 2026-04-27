# =============================================================================
# HCAP-XC-Theme_Driver.R
#
# Prerequisites:
#   - quarto (https://quarto.org)
#   - R with quarto package
#
# Usage:
#   Rscript HCAP-XC-Theme_Driver.R
#   OR
#   In R console: source("HCAP-XC-Theme_Driver.R")
#
# Output:
#   - HCAP-XC-Theme_Control.html (rendered slide show)
#
# =============================================================================

# Render the presentation from the control file
quarto::quarto_render(
  input = "HCAP-XC-Theme_Control.qmd",
  output_format = "revealjs"
)

message("Presentation rendered successfully!")
message("Output: HCAP-XC-Theme_Control.html")
