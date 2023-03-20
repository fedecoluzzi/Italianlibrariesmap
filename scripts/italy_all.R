library(leaflet)
library(htmlwidgets)
library(rstudioapi)
library(leaflegend)

current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path ))

df <- read.csv("../data/geodata-north-xlsx.csv")

pal <- colorNumeric(
  palette = "Oranges",
  domain = df$number_of_works)

# for more complex popups see
#   https://stackoverflow.com/questions/47789632/customizing-leaflet-popup-in-r
m <- leaflet(df) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircles(~longitude,
             ~latitude,
             radius = ~number_of_works * 500,
             color = ~pal(number_of_works),
             #stroke = FALSE,
             fillOpacity = 0.5,
             popup = paste0(
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
             ))

m

library(htmlwidgets)
saveWidget(m, file="../maps/italy_north.html")