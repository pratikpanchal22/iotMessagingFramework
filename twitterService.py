#!/usr/bin/env python
import sys
from twython import Twython

#tweetStr = "Hello World! Greetings from Aquila Bot, I'll be notifying you of important things that I notice around me!"
tweetStr =sys.argv[1]

# your twitter consumer and access information goes here
apiKey = 'dummyApiKey'
apiSecret = 'dummyApiSecret'
accessToken = 'dummyAccessToken'
accessTokenSecret = 'dummyAccessTokenSecret'

api = Twython(apiKey,apiSecret,accessToken,accessTokenSecret)

api.update_status(status=tweetStr)

print "Tweeted: " + tweetStr
