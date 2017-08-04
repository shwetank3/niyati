import got

def printTweet(t):
	print "Username: %s" % t.username
	print "Retweets: %d" % t.retweets
	print "Text: %s" % t.text
	print "Mentions: %s" % t.mentions
	print "Hashtags: %s\n" % t.hashtags
	print "Date: %s\n" % t.date
	
# Example 1 - Get tweets by username
#tweetCriteria = got.manager.TweetCriteria().setUsername('barackobama').setMaxTweets(1)
#tweet = got.manager.TweetManager.getTweets(tweetCriteria)[0]
		
# Example 2 - Get tweets by username and bound dates
#tweetCriteria = got.manager.TweetCriteria().setUsername("barackobama").setSince("2015-09-10").setUntil("2015-09-12").setMaxTweets(1)
#tweet = got.manager.TweetManager.getTweets(tweetCriteria)[0]

#1000 tweets take about 48 seconds

NUMTWEETS = 10000

start_time = time.time()
tweetCriteria = got.manager.TweetCriteria().setQuerySearch('wapda load shedding').setSince("2010-01-01").setUntil("2016-12-31").setMaxTweets(NUMTWEETS)
tweets = got.manager.TweetManager.getTweets(tweetCriteria)
print 'Elapsed: ', time.time() - start_time, ' seconds\n'

first_tweet = tweets[0]
printTweet(first_tweet)

print tweets[len(tweets)-1].date
