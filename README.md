=============================================================
PETER LUFT
0544354
TWITTER SENTIMENT R PROJECT
README
=============================================================


This readme doc will cover the package contents of my project folder
and how to use it, step by step. 

1. Tweet Collection Script:
A Python3 file to access the Twitter API via Tweepy and returns tweets
based on search query. I used it to search terms related for my topic,
but it works with whatever. It should technically work with Python 2.7, 
but I didn't test it and I recommend using 3. Two things to note about
this script. The first is that I changed the API keys to dummy values.
If you wish to run this, simply register your app on Twitter, it's free.
Secondly, you'll need to change the CSV file path to whatever your working
directory is. Those things aside, just run the script and you will accumulate
a CSV file of tweets quickly.

2. results.csv File
The aforementioned Python script writes all of the tweets to this CSV. It
only has one column, 'text', which contains a 1000 ish tweets. This CSV
will be read by the R Script, explained below.

3. Twitter_Analysis.R
This is an R script that takes care of all of the data reading, preprocessing,
cleaning, and analysis. It will output a pie chart of the sentiment score,
and outputs the frequency of negative and positive words, according to the 
modified lexicon folder I included. To run this file, ensure the file paths
in the script have been changed to your working directory. This includes the
path to the results.csv file, as well as the dictionary.txt files. 

4. peterLuft_customLexicon
A folder containing two dictionaries, one of positive terms and one of negative
terms. The R script runs the tweet data against both of these. I modified some
of the terms to better suit Twitter language. 

