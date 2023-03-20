library(leaflet)
library(htmlwidgets)
library(rstudioapi)

current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path ))

df <- read.csv("../data/geodata-south-xlsx.csv")

pal <- colorNumeric(
  palette = "Oranges",
  domain = df$number_of_works)

m <- leaflet(df) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircles(~longitude,
             ~latitude,
             popup=~library_name,
             radius = ~number_of_works * 1000,
             color = ~pal(number_of_works),
             stroke = FALSE,
             fillOpacity = 0.5)

m

library(htmlwidgets)
saveWidget(m, file="../maps/italy_south.html")
