# Library and System
rm(list = ls())
library(dplyr)
library(ggplot2)

# Add vaccine data
# From NEJM article
df <- read.csv("process_data/national_incidence_rate_lvl1.csv")
df <- dplyr::distinct(dplyr::select(df, disease))
df <- dplyr::mutate(df,
                    year =
                      dplyr::case_when(disease == "HEPATITIS A" ~ 1995,
                                       disease == "MEASLES" ~ 1963,
                                       disease == "MUMPS" ~ 1968, # 1967 (red line at first week of 1968)
                                       disease == "PERTUSSIS" ~ 1948,
                                       disease == "POLIO" ~ 1955,
                                       disease == "RUBELLA" ~ 1969,
                                       disease == "SMALLPOX" ~ NA,
                                       disease == "DIPHTHERIA"~ 1923))
write.csv(df, "process_data/vaccine_year_introduction.csv", row.names = F)
