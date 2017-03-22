# -*- coding: utf-8 -*-
"""
Created on Fri Mar 17 13:14:53 2017

@author: shwetank
"""
from nltk.corpus import stopwords 
from nltk.stem.wordnet import WordNetLemmatizer
import gensim
from gensim import corpora
import string

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

tweethandle =  open("mytweet.txt",'r')
doc_complete = tweethandle.readlines()  
doc_clean = [clean(doc).split() for doc in doc_complete]

############ REMOVING CERTAIN REDUNDANT WORDS #################################








         
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




