import time
from twython import Twython

APP_KEY = 'kHGPCE3LT4kiBillHqgD3aB0y'
APP_SECRET = 'mJa8ArGIWLyCir2BNaItipMolrmx5nFOabfWITeLuy7X0sgvN3'
OAUTH_TOKEN = '133995778-TGHZPF1EvbKqa02kqs7bSTBmygvhX9ztXFm4WzO6'
OAUTH_SECRET = 'kOEJc74cT8XLHPPJRtX73g8D4ATRmm0mhTEgIfu0nDmhy'

# This script fetches MAX_COUNT tweets 
# in every iteration of the for-loop
# at the bottom. Total tweets fetched
# are MAX_COUNT times MAX_REP.

# It prints the text of tweets from
# the first iteration.

# MAX_COUNT can be 100 at a time
MAX_COUNT = 100
MAX_REP = 5 

twitter = Twython(APP_KEY, APP_SECRET, oauth_version=2)
ACCESS_TOKEN = twitter.obtain_access_token()

# Each entry in "dstore" is a collection of MAX_COUNT tweets
# So, here, dstore[0]['statuses'] gives you the first ten 
# tweets in a list, dstore[1]['statuses'] gives you the next 
# ten tweets in the list

# Each tweet is a giant structure with a lot of attributes.
# EXAMPLE: 
# FIRST_TEN_TWEETS = dstore[0]['statuses']
# FIRST_TEN_TWEETS[0] is the first tweet.
# FIRST_TEN_TWEETS[0]['user'] gives you attributes of the user 
# (giant structure again)

# FIRST_TEN_TWEETS[0]['user']['text'] gives you the text of
# the tweet

# You can find other attributes of the tweet 
# under FIRST_TEN_TWEETS[0].keys()
# use the KEYS() function for any structure
# to find attributes of interest.

start_time = time.time()
dstore = {}

twitter = Twython(APP_KEY, access_token = ACCESS_TOKEN)
wapTweets = twitter.search(q='#trump', count = MAX_COUNT)
dstore[0] = wapTweets

for i in range(MAX_REP):
    dstore[i+1] = twitter.search(q='#trump', count = MAX_COUNT, \
    max_id = dstore[i]['search_metadata']['max_id'])

FIRST_TEN_TWEETS = dstore[0]['statuses']    

for i in range(len(FIRST_TEN_TWEETS)):
    print i, ': ', FIRST_TEN_TWEETS[i]['text'], '\n'
    
print 'Elapsed: ', time.time() - start_time, ' seconds'
    

