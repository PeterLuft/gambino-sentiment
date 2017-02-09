#=======================================================================
# Peter Luft
# 0544354
#
# Programming Languages 
# Class Project: Twitter Sentiment Analysis
#
# Execute this R file once you have a CSV of tweets collected.
# I've included a results.csv file in my project package. 
#=======================================================================


#=======================================================================
# Phase 1: Reading and Preprocessing the Tweets
#=======================================================================


install.packages("tm")
install.packages("wordcloud")
library("wordcloud")
library("tm")
library("stringr")

#read in our csv of tweets
#NOTE: to run this on your machine, change the below file path to the 
tweets <- read.csv("/Users/pwluft/Desktop/Twitter_Sentiment_Project/results.csv")
tweets_text <- paste(tweets$text, collapse="")

#first, get rid of all the links
regString <- "[(http(s)?):\\/\\/(www\\.)?a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)"
clean_tweet <- str_replace_all(tweets_text, regString,"")

#get rid of all the emoji bytecodes. niiice
clean_tweet <- str_replace_all(clean_tweet, "(\\\\(...))", "")

#get rid of retweets stuff...
clean_tweet = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", " ", clean_tweet)

#if all the whitespace is gonna be stripped anyway, just replace it with spaces
clean_tweet = gsub("@\\w+", " ", clean_tweet)
clean_tweet = gsub("[[:punct:]]", " ", clean_tweet)
clean_tweet = gsub("[[:digit:]]", " ", clean_tweet)
clean_tweet = gsub("http\\w+", " ", clean_tweet)
clean_tweet = gsub("[ \t]{2,}", " ", clean_tweet)
clean_tweet = gsub("^\\s+|\\s+$", " ", clean_tweet) 
clean_tweet = tolower(clean_tweet)

#remove instances of his name in the tweet, because that's going to show up a lot
clean_tweet = gsub("gambino", " ", clean_tweet)
clean_tweet = gsub("childish", " ", clean_tweet)
clean_tweet = gsub("donald", " ", clean_tweet)
clean_tweet = gsub("glover", " ", clean_tweet)
clean_tweet = gsub("new", " ", clean_tweet)
clean_tweet = gsub("album", " ", clean_tweet)

#create a corpus of the remaining terms
tweets_source <- VectorSource(clean_tweet)
corpus <- Corpus(tweets_source)

#clean the corpus
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

#create a document term matrix from our corpus
dtm <- DocumentTermMatrix(corpus)
dtm2 <- as.matrix(dtm)


#okay we have a document term matrix. Let's get some word frequencies
frequency <- colSums(dtm2)
frequency <- sort(frequency, decreasing=TRUE)
words <- names(frequency)

set.seed(39)
wordcloud(names(frequency), frequency, min.freq = 10, colors = brewer.pal(6, "Dark2"))


#=======================================================================
# Phase 2: Analyzing the Processed Tweet Data for Sentiment 
#=======================================================================

#scan in a modifed libaray of positive and negative words. 
#change the below two paths to whatever your working directory is
good = scan('/Users/pwluft/Desktop/Twitter_Sentiment_Project/peterLuft_customLexicon/positive-words.txt', what='character', comment.char=';')
bad = scan('/Users/pwluft/Desktop/Twitter_Sentiment_Project/peterLuft_customLexicon/negative-words.txt', what='character', comment.char=';')

# Add a few twitter-specific negative phrases
bad_text = c(bad, 'wack', 'whack', 'raps', 'rap','bar', 'bars')
good_text = c(good, 'dope', 'woke', 'tight', 'tite', 'fire', 'lit', 'wild')


#this function analyzes and calculates sentiment data for us
analyze = function(myCorpus, good_text, bad_text){
  require(stringr)
  
  #get the corpus into a raw string
  input = data.frame(text = sapply(myCorpus, as.character), stringsAsFactors = FALSE)

  #convert raw string into list of words
  word.list = str_split(input, '\\s+')
  words = unlist(word.list)
  
  #match all the words with the dictionary of positive terms
  pos.matches = match(words, good_text)
  pos.matches = good_text[pos.matches]
  pos.matches <- pos.matches[!is.na(pos.matches)]

  #match all the words with the dictionary of negative terms
  neg.matches = match(words, bad_text)
  neg.matches = bad_text[neg.matches]
  neg.matches <- neg.matches[!is.na(neg.matches)]

  #get length of both the positive term vector and the negative term vector
  numPos <- length(pos.matches)
  numNeg <- length(neg.matches)
  
  #our score is simply the positive minus the negative
  score <- numPos - numNeg

  # print(pos.matches)
  # print(neg.matches)

  
  print(numPos)
  print(numNeg)
  print(score)

  # print(unique(pos.matches))
  # print(unique(neg.matches))
  
  x <- sort(table(pos.matches), decreasing = TRUE)
  print(x)
  
  y <- sort(table(neg.matches), decreasing = TRUE)
  print(y)
  
  
  colors <- brewer.pal(n = 8, name = "Dark2")
  
  pie(c(numPos, numNeg), labels = c("Positive", "Negative"), radius=1, col=colors, main="Overview of Twitter Sentiment")
  
}


analyze(corpus, good_text, bad_text)









