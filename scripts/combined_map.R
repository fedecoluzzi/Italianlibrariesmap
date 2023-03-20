library(leaflet)
library(htmlwidgets)
library(rstudioapi)

current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path ))

df <- read.csv("../data/libraries.csv")

# taken from
#   https://colorbrewer2.org/#type=sequential&scheme=YlOrBr&n=5
getColor <- function(number_of_works) {
  sapply(df$number_of_works, function(number_of_works) {
    if(number_of_works <= 5) {
      "white"
    } else if(number_of_works <= 10) {
      "grey"
    } else if(number_of_works <= 15) {
      "black"
    }})
}

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
  , df$library_name
  , "<br>"
  ,"<b>Location: </b>"
  , df$place
  , "<br>"
  ,"<b>Area: </b>"
  , df$area
  , "<br>"
  , "<b>Number of books held: </b>"
  , df$number_of_works
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
             group=~area) %>%
  addLayersControl(
    overlayGroups = ~area,
    options = layersControlOptions(collapsed = FALSE)
  )

m

library(htmlwidgets)
saveWidget(m, file="../maps/italy_all.html")