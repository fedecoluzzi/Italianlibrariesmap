library(leaflet)
library(htmlwidgets)
library(rstudioapi)

# Next steps
# Check geospatial co-ordinates
#. https://towardsdatascience.com/geocoding-tableau-and-r-integration-c5b32dc0eda6

current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path ))

df <- read.csv("../data/GEODATA_MACRO_CENTRAL_ITALY.csv")

icons <- awesomeIcons(
  icon = 'fa-book',
  iconColor = 'black',
  library = 'fa',
  #markerColor = getColor(df),
)

# labels work thanks to
#   https://www.drdataking.com/post/how-to-add-multiple-lines-label-on-a-leaflet-map/
labels <- paste0(
  "<b>Library: </b>"
  , df$Library.name
  , "<br>"
  , "<b>Number of books held: </b>"
  , df$Number.of.works
) %>%
  lapply(htmltools::HTML)

# for more complex popups see
#   https://stackoverflow.com/questions/47789632/customizing-leaflet-popup-in-r
m <- leaflet(df) %>%
  addProviderTiles(providers$CartoDB.Voyager) %>%
  addAwesomeMarkers(lng = ~Longitude,
                    lat = ~Latitude,
                    icon=icons,
                    label=~labels,
                    clusterOptions = markerClusterOptions())

m

library(htmlwidgets)
saveWidget(m, file="../maps/italy_central_map.html")
