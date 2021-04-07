#This script follows the slides for session 5

library(tidyverse)

#Step 1: Get Unprocessed Text
library(gutenbergr)
raw_text <- gutenberg_download(35993) %>% #This is the id code for Don Quixote
  mutate(book="Don Quixote",
         author="Miguel de Cervantes") #We can add some DOCVARS

#Step 2: Clean Text
clean_text<- raw_text %>% 
  mutate(
    text=tolower(text),
    #We can clean using the stringR package (tidyverse)
    text=str_remove_all(text,"[:punct:]"), 
    text=str_remove_all(text,"[:digit:]")
  )

#Step 3: Tokenize Text
library(tidytext)
text_tokens <- clean_text %>%
  #Tokenize by word
  unnest_tokens(word, text) %>%
  #Remove english stopwords
  anti_join(stop_words) 

#Step 4: Summarize Tokens
#How many unique words are there in the book?
length(unique(text_tokens$word))

#Let's count how many times each of them is mentioned!
token_counts <- text_tokens %>% 
  count(word, sort = T) 

#Step 5: Visualize Text
token_counts %>% 
  #Let's tale the top 20 words
  top_n(20) %>% 
  ggplot(aes(n,reorder(word, n))) + 
  geom_col()+
  labs(y="Token",
       x="Frequency")

library(ggwordcloud)
token_counts %>% 
  #Let's only consider words that appeared at least 100 times!
  filter(n>100) %>% 
  ggplot(aes(label=word, size=n))+
  #We can use the geom_text_wordcloud function to make very nice outputs
  geom_text_wordcloud(color="blue")+
  #We can also tweek the size of our wordcloud
  scale_size_area(max_size = 20) +
  #Let's work with a blank canvas
  theme_minimal()