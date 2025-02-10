# Library and System -----------------------------------------------------------
rm(list = ls())
library(dplyr)

# Prerequisite -----------------------------------------------------------------
# census data, vaccine data & location dictionaries
df_pop <- read.csv("process_data/census.csv") %>%
  dplyr::filter(location == "US")
# Path to the raw files (create if non existant)
folder_dir <- "./raw/tycho_level1/"
if (!dir.exists(folder_dir)) dir.create(folder_dir, recursive = TRUE)

# As the plot needs a YYYY-MM-DD date, the year
# information is transform as 1st Jan of the associated year
df_vax <- read.csv("process_data/vaccine_year_introduction.csv") %>%
  dplyr::rename(vaccine = year) %>%
  dplyr::mutate(vaccine = as.Date(paste0(vaccine, "-01-01")))

# Download data ----------------------------------------------------------------
# from Zenodo and unzip: "https://zenodo.org/records/12608992"
# (run on 2025-02-10), only run for data update
zen_link <- "https://zenodo.org/records/12608992"
down_link <- paste0(zen_link,
                    "/files/ProjectTycho_Level1_v1.0.0.zip?download=1")
download.file(down_link, paste0(folder_dir, "ProjectTycho_Level1_v1.0.0.zip"))
unzip(paste0(folder_dir, "ProjectTycho_Level1_v1.0.0.zip"),
      exdir = folder_dir)


# Load data --------------------------------------------------------------------
df_tycho <- read.csv(paste0(folder_dir, "ProjectTycho_Level1_v1.0.0.csv"),
                     na.strings = "\\N") %>%
  dplyr::distinct() %>%
  dplyr::filter(!is.na(cases)) %>%
  dplyr::mutate(date = MMWRweek::MMWRweek2Date(as.numeric(substr(epi_week, 1,
                                                                 4)),
                                               as.numeric(substr(epi_week, 5,
                                                                 6)), 7),
                year = as.numeric(substr(epi_week, 1, 4))) %>%
  dplyr::mutate(date = as.Date(date)) %>%
  dplyr::filter(!(epi_week == "194836"),
                !(epi_week == "201052" & disease == "HEPATITIS A"))

## Remove week 36 of 1948: Data entry error,
##  correct source table: https://pmc.ncbi.nlm.nih.gov/articles/PMC1995387/
## Remove week 52 of 2010, Hepatitis A: source print error (since corrected but
##  correction not integrated in Tycho)
##  https://www.cdc.gov/mmwr/PDF/wk/mm5951.pdf
##  (see page 1710 - click the erratum
##  corrected table here:
##  https://www.cdc.gov/mmwr/preview/mmwrhtml/mm6008a9.htm?s_cid=mm6008a9_w

# National Incidence rate ------------------------------------------------------
# Calculate by adding all the state or city together per epi week and disease,
# and calculating the incidence rate per 100,000 by applying:
#    nbr of cases divided by the population size, multiplied by 100,000
df_nat_incrate <- df_tycho %>%
  dplyr::summarize(value = sum(cases),
                   .by = c("epi_week", "disease", "date", "year")) %>%
  dplyr::left_join(df_pop, by = "year") %>%
  dplyr::mutate(incidence_rate = (value / population) * 100000) %>%
  dplyr::left_join(df_vax, by = "disease") %>%
  dplyr::select(disease, date, incidence_rate, value, vaccine)

write.csv(df_nat_incrate, "process_data/national_incidence_rate_lvl1.csv",
          row.names = FALSE)
