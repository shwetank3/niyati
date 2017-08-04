import re
import time, os
import pandas as pd

import nltk
import string
import numpy as np
import scipy.io as sio
from textblob import TextBlob as tb
from sklearn.pipeline import Pipeline

from nltk import RegexpParser as rp
from nltk.corpus import stopwords, wordnet 
from nltk.stem.wordnet import WordNetLemmatizer

from sklearn.cross_validation import KFold as kf
from sklearn.decomposition import NMF as nmf
from sklearn.decomposition import LatentDirichletAllocation as lda
from sklearn.feature_extraction.text import CountVectorizer as cv
from sklearn.feature_extraction.text import TfidfTransformer as tfidf

def print_top_words(model, feature_names, n_top_words):
    for topic_idx, topic in enumerate(model.components_):
        print("Topic #%d:" % topic_idx)
        print(" ".join([feature_names[i]
                        for i in topic.argsort()[:-n_top_words - 1:-1]]))

def clean(doc):
    stop_free = " ".join([i for i in doc.lower().split() if (wordnet.synsets(i) and i not in stop)])
    punc_free = ''.join(ch for ch in stop_free if ch not in exclude)
    normalized = " ".join(lemma.lemmatize(word) for word in punc_free.split())
    return normalized.encode('ascii','ignore')

def rem_duplicates(doc):
    doc_clean = pd.DataFrame(doc).drop_duplicates().values.tolist()
    doc_clean = [doc_clean[ii][0] for ii in range(len(doc_clean))]
    return doc_clean

NUMTOPICS = 10
N_TOP_WORDS = 10

stop = set(stopwords.words('english'))
exclude = set(string.punctuation) 
lemma = WordNetLemmatizer()

tweethandle =  open("wapda_1.txt",'r')
doc_complete = rem_duplicates(tweethandle.readlines())
# get doc_filt from the bottom
#doc_clean = [str_stem(clean(doc.decode('utf8'))) for doc in doc_complete]
doc_clean = [str_stem(clean(doc.decode('utf8'))) for doc in doc_filt]
doc_clean = pd.DataFrame(doc_clean).drop_duplicates().values.tolist()
doc_clean = [doc_clean[ii][0] for ii in range(len(doc_clean))]

#doc_clean = [''.join(tb(doc).noun_phrases) for doc in doc_clean]
#doc_clean = pd.DataFrame(doc_clean).drop_duplicates().values.tolist()
#doc_clean = [doc_clean[ii][0] for ii in range(len(doc_clean))]


start_time = time.time()

# filter out the words with zero verbiness
filt_nvbg = [(sum(nltk.FreqDist([tag for (word,tag) in nltk.pos_tag(doc_complete[ii].split()) 
if (tag.startswith('VBG') and word!='shedding')]).values())>0) 
for ii in range(len(doc_complete))]

doc_filt = [doc_complete[jj] for jj in range(len(filt_nvbg)) if filt_nvbg[jj]]

print 'Elapsed: ', time.time() - start_time, ' seconds'

start_time = time.time()
rec2 = list()
kf1 = kf(len(doc_clean), n_folds = 5)

for ntopics in range(2,20):
    cv1 = cv(stop_words='english')
    lda1 = lda(n_topics = ntopics, learning_method = 'online', verbose = True)
    nmf1 = nmf(n_components = ntopics)
    X = cv1.fit_transform(doc_clean)

    rec = list()
    for train, test in kf1:   
        lda1.fit(X[train])
        #print("\nTopics in LDA model:")
        #tf_feature_names = cv1.get_feature_names()
        #print_top_words(lda1, tf_feature_names, N_TOP_WORDS)
        rec.append(lda1.perplexity(X[test]))

    rec2.append(np.mean(rec))
print 'Elapsed: ', time.time() - start_time, 'seconds'
plt.plot(rec2)

start_time = time.time()

filt_vbsq, ptags = list(), list()
for ii in range(len(doc_complete)):
    pt = nltk.pos_tag(doc_complete[ii].split())
    tr1 = rp("VBSQ: {<NN><VBD>}").parse(pt)

    count = 0

    for subtree in tr1.subtrees(filter=lambda t: t.label() == 'VBSQ'):
        count += 1

    filt_vbsq.append(count)
    ptags.append(pt)

print 'Elapsed: ', time.time() - start_time, ' seconds'

