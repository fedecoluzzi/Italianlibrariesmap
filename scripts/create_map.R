library(leaflet)
library(htmlwidgets)
library(rstudioapi)

# Next steps
# Check geospatial co-ordinates
#. https://towardsdatascience.com/geocoding-tableau-and-r-integration-c5b32dc0eda6

current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path ))

df <- read.csv("../data/library_geodata.csv")

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
  , df$library
  , "<br>"
  , "<b>Number of books held: </b>"
  , df$number_of_books_held
) %>%
  lapply(htmltools::HTML)

# for more complex popups see
#   https://stackoverflow.com/questions/47789632/customizing-leaflet-popup-in-r
m <- leaflet(df) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addAwesomeMarkers(lng = ~longitude,
             lat = ~latitude,
             icon=icons,
             label=~labels,
             clusterOptions = markerClusterOptions())

m

library(htmlwidgets)
saveWidget(m, file="../maps/italy_map.html")
