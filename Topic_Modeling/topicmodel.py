# -*- coding: utf-8 -*-
"""
Created on Fri Mar 17 13:14:53 2017

@author: shwetank
"""
from nltk.corpus import stopwords 
from nltk.stem.wordnet import WordNetLemmatizer

import string

from gensim import corpora
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import CountVectorizer as cv
from sklearn.feature_extraction.text import TfidfTransformer as tfidf

############ PREPROCESSING ####################################################
stop = set(stopwords.words('english'))
exclude = set(string.punctuation) 
lemma = WordNetLemmatizer()

def clean(doc):
    stop_free = " ".join([i for i in doc.lower().split() if i not in stop])
    punc_free = ''.join(ch for ch in stop_free if ch not in exclude)
    normalized = " ".join(lemma.lemmatize(word) for word in punc_free.split())
    return normalized
doc_complete = []

tweethandle =  open("wapda_1.txt",'r')
doc_complete = tweethandle.readlines()  
doc_clean = [clean(doc).split() for doc in doc_complete]

############ REMOVING CERTAIN REDUNDANT WORDS #################################
print("Just a trial run for push on git")







         
############ LDA MODELLING ####################################################
# Creating the term dictionary of our courpus, where every unique term is assigned an index. 
dictionary = corpora.Dictionary(doc_clean)

# Converting list of documents (corpus) into Document Term Matrix 
doc_term_matrix = [dictionary.doc2bow(doc) for doc in doc_clean]

# Creating the object for LDA model using gensim library
Lda = gensim.models.ldamodel.LdaModel

# Running and Trainign LDA model on the document term matrix.
ldamodel = Lda(doc_term_matrix, num_topics=3, id2word = dictionary, passes=50)

############ OUTPUT ####################################################
print(ldamodel.print_topics(num_topics=3, num_words=3))




