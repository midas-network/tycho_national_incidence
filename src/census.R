# Library and System -----------------------------------------------------------
rm(list = ls())
library(dplyr)
library(readxl)
library(tidyr)
library(purrr)
library(curl)

# Data From CENSUS. GOV --------------------------------------------------------
# Data from 1910 to 1990
# From: https://www.census.gov/data/tables/time-series/demo/popest/1970s-state.html
# Data from 1990 to 2000
# From: https://www.census.gov/data/tables/time-series/demo/popest/1990s-state.html
# Data from 2000 to 2010
# From: https://www.census.gov/data/tables/time-series/demo/popest/intercensal-2000-2010-state.html
# Data from 2010 to 2020
# From: https://www.census.gov/data/tables/time-series/demo/popest/intercensal-2010-2020-state.html
# Data from 2020 to 2024
# From: https://www.census.gov/data/tables/time-series/demo/popest/2020s-state-total.html

# Function ---------------------------------------------------------------------
clean_df <- function(df, loc_dictionary) {
  df <- as.data.frame(df)
  new_col <- strsplit(df[1, ], " +")[[1]]
  new_col[1] <- "location"
  if (any(any(duplicated(new_col))))
    new_col[grep(new_col[duplicated(new_col)], new_col)[1]] <- "census"
  if (any(grepl("St", new_col)))
    new_col <- grep("St", new_col, value = TRUE, invert = TRUE)
  if (length(grep("\\/90$", new_col)) > 1)
    new_col <- new_col[-tail(grep("\\/90$", new_col),1)]
  df[, 1] <- gsub(" +(?=\\d)" , "_" , df[, 1], perl = TRUE)
  df[, 1] <- gsub("^_" , "" , df[, 1])
  df_demo <- tidyr::separate(df[-1, ,FALSE], col = df, into = new_col,
                             sep = "_")
  df_demo <- dplyr::select(df_demo, -contains("census")) %>%
    dplyr::mutate_all(function(x) gsub(",", "", x)) %>%
    dplyr::mutate(location =
                    unique(gsub("\\d+ +|^ + |--+", "", location))) %>%
    dplyr::mutate(location = loc_dictionary[location]) %>%
    dplyr::filter(!is.na(location)) %>%
    tidyr::pivot_longer(!location, names_to = "year",
                        values_to = "population") %>%
    dplyr::mutate(year =
                    ifelse(grepl("\\/", year),
                           paste0("19", stringr::str_extract(gsub("cen", "",
                                                                  year),
                                                             "\\d\\d$")),
                                year))
  return(df_demo)
}

# Prerequisite -----------------------------------------------------------------
load("process_data/sysdata.rda")

# Path to the raw files (create if non existant)
folder_dir <- "./raw/census/"
if (!dir.exists(folder_dir)) dir.create(folder_dir, recursive = TRUE)

# Load pop data ----------------------------------------------------------------
link_list <-
  c("1980-1990/state/asrh/st0009ts.txt", "1980-1990/state/asrh/st1019ts.txt",
    "1980-1990/state/asrh/st2029ts.txt", "1980-1990/state/asrh/st3039ts.txt",
    "1980-1990/state/asrh/st4049ts.txt", "1980-1990/state/asrh/st5060ts.txt",
    "1980-1990/state/asrh/st6070ts.txt", "1980-1990/state/asrh/st7080ts.txt",
    "1980-1990/state/asrh/st8090ts.txt", "1990-2000/state/totals/st-99-03.txt",
    "2000-2010/intercensal/state/st-est00int-01.xls",
    "2010-2020/intercensal/national/nst-est2020int-pop.xlsx",
    "2020-2023/state/totals/NST-EST2023-POP.xlsx")

file_dir <- paste0(folder_dir, basename(link_list))

# Download and Store all files for reproducibility (only run once)
base_link <- "https://www2.census.gov/programs-surveys/popest/tables/"
link_list <- paste0(base_link, link_list)
download.file(link_list, file_dir)


# Standardize data -------------------------------------------------------------
census_all <- lapply(file_dir, function(down_link) {
  if (grepl(".txt$", down_link)) {
    df <- read.delim2(down_link)
    if (grepl("7080|8090|99-03", down_link)) {
      head <- grep("Fip St|7/\\d\\d|7/\\d{1,2}/\\d\\d", df[, 1])
      unit <- 1
      if (grepl("7080", down_link)) {
        tail <- grep("US", df[, 1])
      } else {
        tail <- grep("WY|Wyoming", df[, 1])
      }
    } else {
      unit <- 1000
      head <- grep("19\\d\\d.*19\\d\\d.*19\\d\\d", df[, 1])
      tail <- grep("WY", df[, 1])
    }
    df_demo <- rbind(clean_df(df[head[1]:tail[1],], dictionary_location),
                     clean_df(df[head[2]:tail[2],], dictionary_location))
  } else {
    unit <- 1
    df <- readxl::read_excel(down_link, skip = 3)
    colnames(df)[1] <- "location"
    df_demo <- dplyr::select(df, !dplyr::contains("...")) %>%
      dplyr::mutate(location = gsub("^\\.", "", location)) %>%
      dplyr::mutate(location = dictionary_location[location]) %>%
      dplyr::filter(!is.na(location)) %>%
      tidyr::pivot_longer(!location, names_to = "year",
                          values_to = "population")
  }
  df_demo <- dplyr::mutate(df_demo,
                           location = as.character(location),
                           year = as.numeric(year),
                           population = as.numeric(population) * unit)
  sel_year <- min(df_demo$year) + 9
  df_demo <- dplyr::filter(df_demo, year <= sel_year)
  return(df_demo)
}) %>%
  dplyr::bind_rows()

write.csv(census_all, "process_data/census.csv", row.names = FALSE)

# Clean env --------------------------------------------------------------------
rm(list = ls())
