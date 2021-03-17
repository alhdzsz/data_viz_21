#-----------------------------------------------
# Author: Alfredo Hernandez Sanchez
# Title: GGPLOT2 Themes
# Date: 2021-03-16
# Course: DVIZ_2021 IBEI
#-----------------------------------------------

library(tidyverse)

## Basic Themes 

ggplot(mtcars, aes(wt, mpg, color=as.factor(cyl))) +
  geom_point(size=2) +
  labs(title = "Fuel Economy to Weight",
       subtitle = "MTCARS Data",
       color="Number of Cylinders",
       x="Weight (tons)",
       y="Mileage")+
  theme_dark(base_size = 14)+
  scale_color_manual(values = c("green", "red", "blue"))+
  ggsave("Output/dark_theme.png", width = 10, height = 10, units = "cm")

ggplot(mtcars, aes(wt, mpg, color=as.factor(cyl))) +
  geom_point(size=2) +
  labs(title = "Fuel Economy to Weight",
       subtitle = "MTCARS Data",
       color="Number of Cylinders",
       x="Weight (tons)",
       y="Mileage")+
   ggsave("Output/no_theme.png", width = 10, height = 10, units = "cm")


## ggthemes Package 

library(ggthemes)

ggplot(mtcars, aes(wt, mpg, color=as.factor(cyl))) +
  geom_point(size=2) +
  labs(title = "Fuel Economy to Weight",
       subtitle = "MTCARS Data",
       color="Number of Cylinders",
       x="Weight (tons)",
       y="Mileage")+
  theme_economist()+
  scale_color_economist()+
  ggsave("Output/economist_theme.png", width = 10, height = 10, units = "cm")

ggplot(mtcars, aes(wt, mpg, color=as.factor(cyl))) +
  geom_point(size=2) +
  labs(title = "Fuel Economy to Weight",
       subtitle = "MTCARS Data",
       color="Number of Cylinders",
       x="Weight (tons)",
       y="Mileage")+
  theme_stata()+
  scale_color_stata()+
  ggsave("Output/stata_theme.png", width = 10, height = 10, units = "cm")

ggplot(mtcars, aes(wt, mpg, color=as.factor(cyl))) +
  geom_point(size=2) +
  labs(title = "Fuel Economy to Weight",
       subtitle = "MTCARS Data",
       color="Number of Cylinders",
       x="Weight (tons)",
       y="Mileage")+
  theme_excel()+
  scale_color_excel()+
  ggsave("Output/excel_theme.png", width = 10, height = 10, units = "cm")

ggplot(mtcars, aes(wt, mpg, color=as.factor(cyl))) +
  geom_point(size=2) +
  labs(title = "Fuel Economy to Weight",
       subtitle = "MTCARS Data",
       color="Number of Cylinders",
       x="Weight (tons)",
       y="Mileage")+
  theme_wsj(base_size = 5)+
  scale_color_wsj()+
  ggsave("Output/wsj_theme.png", width = 10, height = 10, units = "cm")

## Custom Theme

ggplot(mtcars, aes(wt, mpg, color=as.factor(cyl))) +
  geom_point(size=2) +
  labs(title = "Fuel Economy to Weight",
       subtitle = "MTCARS Data",
       color="Number of Cylinders",
       x="Weight (tons)",
       y="Mileage")+
  theme(panel.border = element_rect(fill = NA, color = NA),
        panel.grid.minor.y = element_line(colour = "#dde1e0", size=1, linetype = "dotted"),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        text=element_text(size=16),
        plot.title = element_text(vjust = 1.5),
        plot.subtitle = element_text(vjust = 1.5, face="italic"),
        plot.background = element_rect(fill = "#dde1e0", colour = "#060404"),
        axis.ticks = element_blank(),
        panel.background = element_rect(fill = "white"),
        axis.line = element_line(size = 1.3, colour = "#060404"),
        legend.background = element_rect(fill="#dde1e0"),
        legend.position = "bottom",
        axis.text.y = element_text(angle=90),
        legend.title = element_text(size = rel(0.8), face = "bold"),
        legend.key= element_rect(colour = "#060404"))+
  scale_color_manual(values = c("#3b4381", "#d32425", "#FFBB01", "#060404", 
                                "#e4480a", "#d4d4d4", "#8d5f37", "#6c6c6c"))+
  ggsave("Output/my_theme.png", width = 25, height = 15, units = "cm")


