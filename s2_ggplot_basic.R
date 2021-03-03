#-----------------------------------------------
# Author: Alfredo Hernandez Sanchez
# Title: GGPLOT2 Basics
# Date: 2021-03-03
# Course: DVIZ_s2 IBEI
#-----------------------------------------------

library(tidyverse)


#-----------------------------------------------
#Let's get the commonly used "Cars" dataset
data("mtcars")

#-----------------------------------------------
#Explore the dataset
str(mtcars) 
summary(mtcars)

#-----------------------------------------------
#Transform variables

mtcars$model <- row.names(mtcars)

mtcars$engine <- ifelse(mtcars$vs==0,"v shape","straight")

mtcars[mtcars$am == 1,]$am <- "Manual"
mtcars[mtcars$am == 0,]$am <- "Automatic"

unique(mtcars$gear)
mtcars <- mtcars %>% 
  mutate(gear=case_when(
    gear==4 ~ "Four",
    gear==3 ~ "Three",
    gear==5 ~ "Five"))

mtcars$cyl <- as.factor(mtcars$cyl)

#-----------------------------------------------
#Subset to a new df
df <- mtcars %>% 
  select(model, am, cyl, hp, mpg, wt) %>% 
  rename(cylinders=cyl,
         mileage=mpg,
         weight=wt,
         transmission=am) 

#-----------------------------------------------
#Plotting

#A histogram
df %>%
  ggplot(aes(x= mileage))+
  geom_histogram(binwidth = 1)

#A bar chart
df %>%
  ggplot(aes(x= cylinders))+
  geom_bar(fill="green")

#A column chart
df %>%
  ggplot(aes(x=cylinders, y=weight))+
  geom_col(fill="blue", color="white")

#A boxplot
df %>%
  ggplot(aes(x= transmission, y=mileage))+
  geom_boxplot()

#A more complex scatterplot
df %>% 
  filter(weight > 2) %>% 
  ggplot(aes(x=mileage,y=hp))+
  geom_point(aes(shape=transmission, color=cylinders), size=2)+
  geom_text(aes(label= ifelse(hp == max(hp), as.character(model), "")),hjust=.5, vjust=0) +
  geom_text(aes(label= ifelse(hp == min(hp), as.character(model), "")),hjust=.5, vjust=0) +
  geom_smooth(method=lm, se=F)+
  geom_hline(yintercept = mean(mtcars$hp), linetype="dashed")+
  annotate("rect", xmin = 25, xmax = 30, ymin = mean(mtcars$hp), ymax = mean(mtcars$hp)+10,
           alpha = .2, fill="red")+
  annotate("text", x=27, y=mean(mtcars$hp)+6, label= sprintf("av. hp: %s", round(mean(mtcars$hp))),color="blue")+
  labs(x="Mileage", y="Horsepower", title="More Power!", subtitle="Data from mtcars")+
  theme(axis.text.y = element_text(angle = 90, hjust = .5),
        legend.position = "bottom")+
  ggsave("Output/scatter_plot.png", width = 30, height = 20, units = "cm")
