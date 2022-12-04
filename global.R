library(memoise)
library(tidyverse)
library(tidytext)
library(tm)

# Text cleaning:
clean_text <<- function(dataset) {
  
  # Get the text column
  text <- dataset$text
  
  # Set the text to lowercase
  text <- tolower(text)
  
  # Remove mentions, urls, emojis, numbers, punctuations, etc.
  text <- gsub("@\\w+", "", text)
  text <- gsub("https?://.+", "", text)
  text <- gsub("\\d+\\w*\\d*", "", text)
  text <- gsub("#\\w+", "", text)
  text <- gsub("[^\x01-\x7F]", "", text)
  text <- gsub("[[:punct:]]", " ", text)
  # Remove spaces and newlines
  
  text <- gsub("\n", " ", text)
  text <- gsub("^\\s+", "", text)
  text <- gsub("\\s+$", "", text)
  text <- gsub("[ |\t]+", " ", text)
  
  return(text)
}

# Remove stopwords:
remove_stopwords <<- function(used_language, documents) {
  stopwords_regex = paste(stopwords(used_language), collapse = '\\b|\\b')
  stopwords_regex = paste0('\\b', stopwords_regex, '\\b')
  documents = stringr::str_replace_all(documents, stopwords_regex, '')
  return(documents)
}

read_dataset <- function(text_lang) {
  text_dataset <<- read.csv(file = 'data/text.csv', header = TRUE, sep = ",")
  
  # These should be adapted to your usecase:
  # We need text and Sentiment columns only
  text_dataset["text"] <<- text_dataset["Comment"]
  text_dataset <<- text_dataset[c("text", "Sentiment")]
  
  # The rest is generic
  text_dataset["text"] <<- clean_text(text_dataset)
  text_dataset["text"] <<- remove_stopwords(text_lang, text_dataset$text)
  return(text_dataset)
}

# get word frequency dataframe per sentiment:
get_word_frequency_dataframe <<- function(dataset, sentiment) {
  selected_text_df = text_dataset[text_dataset$Sentiment == sentiment,]
  docs <- Corpus(VectorSource(selected_text_df$text))
  dtm <- TermDocumentMatrix(docs) 
  matrix <- as.matrix(dtm) 
  words <- sort(rowSums(matrix),decreasing=TRUE) 
  df <- data.frame(word = names(words),freq=words)
  return(df)
}

# Generic function:
getTermMatrix <<- memoise(function(sentiment) {
  get_word_frequency_dataframe(text_dataset, sentiment)
})