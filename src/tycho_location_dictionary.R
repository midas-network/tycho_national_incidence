# Region Hard-coded from the NEJM article:
# Panhuis, Willem G. van, John Grefenstette, Su Yon Jung, Nian Shong
# Chok, Anne Cross, Heather Eng, Bruce Y. Lee, et al. 2013. “Contagious
# Diseases in the United States from 1888 to the Present.” New England
# Journal of Medicine 369 (22): 2152–58.
# <https://doi.org/10.1056/NEJMms1215400>.

# Folder information
if (!(dir.exists("./process_data"))) dir.create("./process_data")

# Location state name and abbreviation
df_location <- read.csv("./raw/location/location.csv")
number2location <- setNames(df_location$location_name,
                            df_location$location)
abbr2location <- setNames(df_location$location_name,
                          df_location$abbreviation)
location2location <- setNames(c(df_location$location_name, "US", "US", "US",
                                "US", "DC"),
                              c(df_location$location_name, "USA", "U.S.", "US",
                                "United States", "DIST. OF COL."))
dictionary_location <- c(number2location, abbr2location, location2location)

location2abbr <- setNames(names(abbr2location),
                          as.character(abbr2location))

df_region <- data.frame(region = 1,
                        state = c("Connecticut", "Maine", "Massachusetts",
                                  "New Hampshire", "Rhode Island",
                                  "Vermont")) %>%
  rbind(data.frame(region = 2,
                   state = c("New Jersey", "New York"))) %>%
  rbind(data.frame(region = 3,
                   state = c("Delaware", "District of Columbia", "Maryland",
                             "Pennsylvania", "Virginia", "West Virginia"))) %>%
  rbind(data.frame(region = 4,
                   state = c("Alabama", "Florida", "Georgia", "Kentucky",
                             "Mississippi", "North Carolina", "South Carolina",
                             "Tennessee"))) %>%
  rbind(data.frame(region = 5,
                   state = c("Illinois", "Indiana", "Michigan", "Minnesota",
                             "Ohio", "Wisconsin"))) %>%
  rbind(data.frame(region = 6,
                   state = c("Arkansas", "Louisiana", "New Mexico", "Oklahoma",
                             "Texas"))) %>%
  rbind(data.frame(region = 7,
                   state = c("Iowa", "Kansas", "Missouri", "Nebraska"))) %>%
  rbind(data.frame(region = 8,
                   state = c("Colorado", "Montana", "North Dakota",
                             "South Dakota", "Utah", "Wyoming"))) %>%
  rbind(data.frame(region = 9,
                   state = c("Arizona", "California", "Hawaii", "Nevada"))) %>%
  rbind(data.frame(region = 10,
                   state = c("Alaska", "Idaho", "Oregon", "Washington"))) %>%
  dplyr::mutate(abbr = location2abbr[state])

location2region <- setNames(df_region$region, df_region$state)
abbr2region <- setNames(df_region$region, df_region$abbr)

save(list = c("abbr2region", "dictionary_location", "location2abbr",
              "location2region"), file = "process_data/sysdata.rda")
