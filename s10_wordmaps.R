library(tidyverse)
library(sf)

#provinces
ken <- st_read("KEN_adm/KEN_adm1.shp", stringsAsFactors = FALSE) %>% 
  st_transform(4326) %>% 
  st_as_sf()
#subprovinces
ken2 <- st_read("KEN_adm/KEN_adm2.shp", stringsAsFactors = FALSE) %>% 
  st_transform(4326) %>% 
  st_as_sf()
#add random covariates
ken2$data <- rnorm(nrow(ken2), mean = 10, sd=1)

#plot layers
ggplot()+
  geom_sf(data = ken2, aes(fill=data))+
  geom_sf(data = ken, size=1, fill=NA)+
  theme_minimal()

#add theme elements
ggplot()+
  geom_sf(data = ken, color = "black", fill = "black")+
  theme_minimal()+
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank(),
        panel.grid = element_blank(),
        panel.border = element_blank(),
        axis.line = element_blank())+
  ggsave("kenya.png", units = "cm", height = 15, width = 15)


#Maps and wordclouds! 
library(ggwordcloud)
library(tidytext)
library(rvest)

url <- "https://www.lyricsondemand.com/miscellaneouslyrics/nationalanthemslyrics/italynationalanthemlyrics.html"

anthem<-read_html(url) %>%
  html_nodes(".lcontent") %>% 
  html_text() %>% 
  str_replace_all("[\r\n]", " ") %>% 
  tolower() %>% 
  str_remove_all("[:punct:]") %>% 
  str_remove_all("[:digit:]")

italy <- st_read("ITA_adm/ITA_adm1.shp", stringsAsFactors = FALSE) %>% 
  st_transform(4326) %>% 
  st_as_sf()

ggplot()+
  geom_sf(data = italy, color = "black", fill = "black")+
  theme_minimal()+
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank(),
        panel.grid = element_blank(),
        panel.border = element_blank(),
        axis.line = element_blank())+
  ggsave("italy.png", units = "cm", height = 15, width = 15)

anthem %>% 
  as_tibble() %>% 
  rename(text=value) %>% 
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>% #removes common words
  count(word, sort = T) %>% 
  head(70) %>% #top 100 words
  mutate(angle = 45 * sample(-2:2, n(), replace = TRUE, prob = c(1, 1, 4, 1, 1)), #angle
         color=ifelse(runif(70,min=0,max=1)>.5,"a","b")) %>% #color
  ggplot(aes(label=word, size=n, angle=angle))+ 
  geom_text_wordcloud(aes(color=color),
                      mask = png::readPNG("italy.png"))+ #shapefile
  scale_size_area(max_size = 5) + #or 20 for biggers
  scale_colour_manual(values = c("#009344","#cf2734"))+
  theme_minimal()+
  ggsave("italy_anthem.png", units = "cm", height = 15, width = 15)


#Activity: with your group, select one or more countries and make the anthem against the map
#In addition, try give the english version and the national language version different colors!

