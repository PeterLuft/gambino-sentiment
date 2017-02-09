'''
Tweet Collection Script

Peter Luft
0544354

The following Python program accesses Twitter data via Tweepy StreamListener
and inputs the returned tweets in a CSV file, called 'results.csv'. See the
README.doc for more details. 

'''

#import our stuff
from tweepy import OAuthHandler
from tweepy import Stream
from tweepy.streaming import StreamListener
import tweepy
import json
import csv


'''
!!!IMPORTANT!!!

The following four authentication variables have been set to dummy values by myself.
If you wish to run the program in real-time, you must register your own twitter application
and enter the corresponding authentication keys it gives you below. See the attached
README.doc for more details. 
'''
consumer_key = 'CHANGE_ME'
consumer_secret = 'CHANGE_ME'
access_token = 'CHANGE_ME'
access_secret = 'CHANGE_ME'

auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)
api = tweepy.API(auth)


class MyListener(StreamListener):

    i = 0

    def on_data(self, data):
        try:

			#note, you'll need to change the below path according to your working directory on your machine
            with open('/Users/pwluft/Desktop/Twitter_Sentiment_Project/results.csv', 'a') as f:
                tweet = json.loads(data)

                print(str(tweet['text'].encode('utf-8'))[1:])
                csv.writer(f).writerow([str(tweet['text'].encode('utf-8'))[1:]])
                return True

        except BaseException as e:
            print("Error on_data: %s" % str(e))
            return True

    def on_error(self, status):
        print(status)
        return True

#set our search keys to whatever you'd like, and it just runs the stream until you kill the program.
searchKeys = ['childish gambino, gambino, awaken my love, donald glover']
myStream = Stream(auth, MyListener())
myStream.filter(track= searchKeys)






