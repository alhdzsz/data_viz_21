library(tidyverse)
library(rvest)
library(tidytext)
library(ggwordcloud)
library(textdata) 
#Global Options
stringsAsFactors = FALSE #so text is recognized as text!

####----------------------Data Collection

# Step 1: Define URL
url<-"https://www.presidency.ucsb.edu/advanced-search?field-keywords=&field-keywords2=&field-keywords3=&from%5Bdate%5D=&to%5Bdate%5D=&person2=200320&category2%5B%5D=406&items_per_page=100"

# Step 2: Read URL into a list object
page<-read_html(url)
class(page)

# Step 3: Extract attributes
my_results<-html_table(page) #this extacts html tables

summary(my_results)
class(my_results[[1]]) #inside the results list, there is a data frame

my_results <- my_results[[1]] #lets extract it!

# Step 3.1: Extract MORE attributes
my_urls <-page %>%
  html_nodes(".views-field-title a") %>% #use the selector gadget to find the right nodes!
  html_attr("href") %>% #we extract "href" or links! 
  as.data.frame() %>% 
  mutate(link=paste0("https://www.presidency.ucsb.edu", .))

# Step 4: Consolidate Data Frame

df <- my_results
df$Link <- my_urls$link

# Step 5: Visit Each URL and Extract the Text

## Option 1: A function
my_scraper<-function(address){
  result<-read_html(address) %>% #define the variable the funciton needs
    html_nodes(".field-docs-content") %>% #Define the CSS indicator (custom)
    html_text() #define the output you want!
} 

df$text<-sapply(df$Link, my_scraper)

## Option 2: A loop
df$text2<-NA
for(i in 1:nrow(df)){
  result <- read_html(df[i,"Link"]) %>% 
    html_nodes(".field-docs-content") %>% 
    html_text()
  df[i,"text2"]<-result
}

#Are they the same?
df$text2==df$text

####----------------------Text Processing

df$text2=NULL #let's drop one of the duplicated variables

#Clean Text
df <- df %>% 
  mutate(
    text=tolower(text),
    text=str_remove_all(text,"[:punct:]"),
    text=str_remove_all(text,"[:digit:]")
  )

#Tokenize
tidy_biden <- df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>% 
  mutate(month=str_extract(Date, "[A-z]{3}"))

head(tidy_biden)
unique(tidy_biden$month)

#Text Summaries
tidy_biden %>% 
  group_by(month) %>% 
  count(word, sort = T) %>% 
  summarise(words=sum(n))

month_counts <- tidy_biden %>% 
  group_by(month) %>% 
  count(word, sort = T) 

#Word Cloud
month_counts %>% 
  head(50) %>% 
  ggplot(aes(label=word, size=n, color=month))+
  geom_text_wordcloud()+
  scale_size_area(max_size = 5) +
  facet_wrap(~month)+
  theme_minimal()

####----------------------Sentiment Analysis

#AFINN Dictionary 
afinn<-get_sentiments("afinn") %>% 
  rename(AFINN=value)#install AFINN, click 1
summary(afinn)

tidy_biden <- tidy_biden %>% 
  left_join(afinn)

head(tidy_biden)
summary(tidy_biden$AFINN)

tidy_biden %>% 
  group_by(month) %>% 
  summarise(afinn=sum(AFINN, na.rm = T)) %>%
  ggplot(aes(x=month, y=afinn)) +
  geom_col()

#Bing Dictionary 
tidy_biden <-tidy_biden %>% 
  left_join(get_sentiments("bing")) %>% 
  rename(BING=sentiment) %>% 
  mutate(BING=ifelse(BING=="positive",1,0))

head(tidy_biden)

tidy_biden %>% 
  group_by(month) %>% 
  summarise(pos_bing=sum(BING, na.rm = T),
            words=n()) %>%
  mutate(pos_bing_r=pos_bing/words) %>% 
  ggplot(aes(x=month, y=pos_bing_r)) +
  geom_col()

##Challenge

#Can you do it by month for ALL months? How about by week? For Trump?
