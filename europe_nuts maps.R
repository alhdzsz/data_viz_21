library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(eurostat)
library(tidyverse)

world <- ne_countries(scale = "medium", returnclass = "sf")

nuts3 <- get_eurostat_geospatial(output_class = "sf",
                                 resolution = "20", 
                                 nuts_level = 3,
                                 year = 2013)
nuts2 <- get_eurostat_geospatial(output_class = "sf",
                                   resolution = "20", 
                                   nuts_level = 2,
                                   year = 2013)
nuts1 <- get_eurostat_geospatial(output_class = "sf",
                                 resolution = "20",
                                 nuts_level = 1,
                                 year = 2013)
europe <- get_eurostat_geospatial(output_class = "sf",
                                 resolution = "20", 
                                 nuts_level = 0,
                                 year = 2013)

europe %>% 
  ggplot() +
  geom_sf(data=world, color=NA, fill="lightgray")+
  geom_sf(data=nuts2, color="darkgray", fill="antiquewhite")+
  geom_sf(color="black", fill=NA)+
  coord_sf(xlim = c(-22, 42),
           ylim = c(36, 70))+
  theme(panel.background = element_rect(fill = "aliceblue"),
        axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        panel.border=element_rect(colour = "black", fill=NA, size=1),
        plot.title = element_text(hjust = 0.5, size = 20, color = "darkblue"),
        plot.subtitle = element_text(hjust = 0.5, size = 15, color = "darkblue"))+
  ggsave("nuts_europe.png", height = 30, width = 30, units = "cm")

