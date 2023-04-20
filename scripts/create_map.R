library(leaflet)
library(htmlwidgets)
library(rstudioapi)
library(tidyverse)

# Next steps
# Check geospatial co-ordinates
# . https://towardsdatascience.com/geocoding-tableau-and-r-integration-c5b32dc0eda6

current_path <- rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path))

files <- list.files("../data")

# df <- tibble()

# for (file in files) {
#  path <- paste0("../data/", file)
#  data <- read_csv(path)
#  df <- bind_rows(df, data)
# }

df <- read_csv(paste0("../data/", "GEODATA_MACRO_ITALY.csv"))

df <- df %>% distinct()

icons <- awesomeIcons(
  icon = "fa-book",
  iconColor = "black",
  library = "fa",
  # markerColor = getColor(df),
)

# labels work thanks to
#   https://www.drdataking.com/post/how-to-add-multiple-lines-label-on-a-leaflet-map/
labels <- paste0(
  '<b>Library: </b><a href="https://',
  df$`Library website`,
  '">',
  df$`Name of Library`,
  "</a>",
  "<br>",
  "<b>Location:</b>",
  df$Location,
  "<br>",
  "<b>Number of books held: </b>",
  df$`Number of works`,
  "<br>",
  "<b>Type of Library: </b>",
  df$`Type of Library`
) %>%
  lapply(htmltools::HTML)

# for more complex popups see
#   https://stackoverflow.com/questions/47789632/customizing-leaflet-popup-in-r
m <- leaflet(df) %>%
  addProviderTiles(providers$CartoDB.Voyager) %>%
  addAwesomeMarkers(
    lng = ~Longitude,
    lat = ~Latitude,
    icon = icons,
    popup = ~labels,
    clusterOptions = markerClusterOptions()
  )

m

library(htmlwidgets)
saveWidget(m, file = "../maps/italy_map.html")
