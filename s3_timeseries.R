#-----------------------------------------------
# Author: Alfredo Hernandez Sanchez
# Title: GGPLOT2 Timeseries
# Date: 2021-03-16
# Course: DVIZ_2021 IBEI
#-----------------------------------------------

library(tidyverse)

df1 = KOF_clean 
df2 = ECI_clean

#let's combine these two datasets by common variables!
df = left_join(df1, df2)

#let's make our ECI a dummy variable
df = df %>% 
  mutate(complex=ifelse(ECI>0,1,0))

#let's plot a line for KOF in all countries
df %>% 
  ggplot(aes(x=year,y=KOFGI, group=country))+
  geom_line()

#let's plot a line for KOF in Spain
df %>% 
  filter(country=="Spain") %>% 
  ggplot(aes(x=year,y=KOFGI))+
  geom_line(color="blue")

#let's plot a line for KOF in Spain AND Hungary
df %>% 
  filter(country%in%c("Spain","Hungary")) %>% 
  ggplot(aes(x=year,y=KOFGI,group=country))+
  geom_line()

#let's plot a line for KOF in Spain AND Hungary
df %>% 
  filter(country%in%c("Spain","Hungary")) %>% 
  ggplot(aes(x=year,y=KOFGI,group=country))+
  geom_line(aes(color=country))

#let's plot a line for KOF in Spain & Hungary AND Saudi Arabia & Kazakhstan
df %>% 
  filter(country%in%c("Spain","Hungary", "Kazakhstan", "Kuwait")) %>% 
  ggplot(aes(x=year,y=KOFGI,group=country))+
  geom_line(aes(color=country))+
  facet_wrap(~complex)

#let's change the colors a bit!
df %>% 
  filter(country%in%c("Spain","Hungary", "Kazakhstan", "Kuwait")) %>% 
  ggplot(aes(x=year,y=KOFGI,group=country))+
  geom_line(aes(color=country))+
  facet_wrap(~complex)+
  scale_color_manual(values = c("blue", "red", "green", "orange"))
  
#let's plot the two indices for Spain
df %>% 
  filter(country=="Spain") %>% 
  ggplot()+
  geom_line(aes(x=year,y=KOFGI,group=country), color="blue")+
  geom_line(aes(x=year,y=ECI,group=country), color="red")

#let's add an additional y axis to see the timeseries better!
df %>% 
  filter(country=="Spain") %>% 
  ggplot()+
  geom_line(aes(x=year,y=KOFGI,group=country), color="blue")+
  scale_y_continuous(sec.axis = sec_axis(~ . / 100, name = "ECI"))+
  geom_line(aes(x=year,y=ECI*100,group=country), color="red")

#let's explore this for two countries
df %>% 
  filter(country%in%c("Spain","Hungary")) %>% 
  ggplot()+
  geom_line(aes(x=year,y=KOFGI,group=country, color="KOFIG"))+
  scale_y_continuous(sec.axis = sec_axis(~ . / 100, name = "ECI"))+
  geom_line(aes(x=year,y=ECI*100,group=country, color="ECI"))+
  facet_wrap(~country, scales = "free")+
  scale_color_manual(values = c("blue", "red"))

  

