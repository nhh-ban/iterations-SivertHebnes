library(tidyverse)
library(lubridate)

transform_metadata_to_df <- function(stations_metadata) {
  
  # Convert the list to a tibble
  stations_df <- stations_metadata[[1]] %>%
    map(as_tibble) %>%
    bind_rows()
  
  # Extracting latestData and converting it to date-time format
  stations_df <- stations_df %>%
    mutate(latestData = map_chr(latestData, 1, .default = NA_character_)) %>%
    mutate(latestData = as_datetime(latestData, tz = "UTC"))
  
  # Unlist the location to extract lat and lon
  stations_df <- stations_df %>%
    mutate(location = map(location, unlist)) %>%
    mutate(
      lat = map_dbl(location, "latLon.lat"),
      lon = map_dbl(location, "latLon.lon")
    ) %>%
    select(-location)
  
  return(stations_df)
}


dataframe <- transform_metadata_to_df(stations_metadata)



library(anytime)


to_iso8601 <- function(date_time, offset) {
  new_date_time <- date_time + days(offset)
  formatted_date <- format(anytime(new_date_time), format = "%Y-%m-%dT%H:%M:%S")
  return(paste0(formatted_date, "Z"))
}



