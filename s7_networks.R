library(tidyverse)
library(ggraph)
library(tidygraph)
set.seed(42)

mygraph <- create_ring(10)

mygraph %>% 
  ggraph(layout = "circle")+
  geom_node_point()+
  geom_edge_link()

mygraph %>% 
  activate(nodes) %>% 
  mutate(attribute=c("A","A","B","B","A",
                     "A","A","B","B","A")) %>% 
  activate(edges) %>% 
  mutate(weight=rnorm(10, mean = 5, sd= 1)) %>% 
  ggraph(layout = "circle")+
  scale_edge_width(range = c(.1, 1))+ 
  geom_edge_link(aes(edge_width = weight))+
  geom_node_point(aes(color=attribute), size=5)+
  theme(legend.position = "bottom",
        legend.box = "vertical")

#Some more random graphs! 
mygraph2<-play_erdos_renyi(n = 11,m=23,directed = F)
mygraph2

mygraph2<-mygraph2 %>% 
  activate(nodes) %>% 
  mutate(names=letters[1:11],
         type=ifelse(runif(11, min=0, max=1)>.5,"First","Second")) %>% 
  activate(edges) %>% 
  mutate(weight=rnorm(23,mean=10,sd=1))

mygraph2 %>% 
  ggraph(layout = "fr")+
  geom_edge_link(color="purple")+
  geom_node_point(aes(color=type),show.legend=F,size=2)+
  geom_node_text(aes(label=names), size=5)


#Replication Data
dip_matrix <- read.csv("DIPCON2005_3.0.csv")

dip_matrix %>% 
  reshape2::melt() %>%
  rename(source=X,
         target=variable,
         weight=value) %>%
  filter(weight==1) %>%
  select(-weight) %>%
  as_tbl_graph(directed=F) %>% 
  mutate(centrality=centrality_degree()) %>% 
  ggraph(layout = "stress")+
  #geom_edge_arc(alpha=.1, color="#9FCCCB")+ #takes a long time!
  geom_node_point(aes(size = centrality), show.legend = F, color="#33FFFA")+
  geom_node_text(aes(label=name))+
  labs(title = "Diplomatic Network in 2005",
       caption = "Nodes represent states, and lines represent embassies. Node size proportional to the number of embassies received.")+
  theme_graph()+
  ggsave("diplomatic_network.png", width = 30, height = 20, units = "cm")


#Trade Network with Mutate
trade_matrix <- read.csv("mod1_trade2005.csv")

trade_matrix %>% 
  reshape2::melt() %>% 
  rename(source=X,
         target=variable,
         weight=value) %>% 
  filter(weight>0) %>% 
  as_tbl_graph(directed=F) %>% 
  mutate(centrality=centrality_degree(weights = weight, normalized=F)) %>% 
  activate(nodes) %>% 
  mutate(trade_zone=ifelse(name%in%c("USA","MEX","CAN"), "USMCA", "OTHER")) %>% 
  ggraph(layout = "stress")+
  #geom_edge_arc(alpha=.1, color="#9FCCCB")+ #takes a long time!
  geom_node_point(aes(size = centrality, color=trade_zone), show.legend = F)+
  geom_node_text(aes(label=name, size = centrality), show.legend = F)+ #you can also use ggrepel
  labs(title = "Global Trade Network in 2005",
       caption = "Nodes represent states, and lines represent trade flows. Node size proportional to total trade volume.")+
  theme_graph()+
  ggsave("trade_network.png", width = 30, height = 20, units = "cm")





