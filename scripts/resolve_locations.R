#remotes::install_github("dieghernan/nominatimlite")

library(nominatimlite)
library(tibble)
library(stringr)
library(ggmaps)

current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path ))
df <- read.csv("../data/libraries.csv")

df$lib_name_short <- word(df$library_name, start=1, end=3)
lat_longs <- geo_lite(address = df$lib_name_short, lat = "latitude", long = "longitude")

df$resolved_lat <- lat_longs$latitude
df$resolved_long <- lat_longs$longitude
df$resolved_adr <- lat_longs$address

write.csv(df, file = "../data/libraries_resolved_locations.csv")

# Try with google maps
ggmap::register_google(key="key_here")

locations <- geocode(df$library_name)
df$ggmap_lat <- locations$lat
df$ggmap_long <- locations$lon

write.csv(df, file = "../data/libraries_resolved_locations.csv")
