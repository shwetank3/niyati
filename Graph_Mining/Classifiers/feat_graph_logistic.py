# -*- coding: utf-8 -*-
"""
Created on Thu Apr 27 23:21:01 2017

@author: shwetank
"""
import pandas as pd
import numpy as np
from sklearn.preprocessing import normalize
from sklearn.metrics.pairwise import cosine_similarity as cs
from sklearn.metrics import jaccard_similarity_score as js
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix
import warnings
import random
warnings.filterwarnings("ignore", category=DeprecationWarning) 

print("Reading Adjacency Matrix")
A = pd.read_csv("adjMat.csv",header=None);

no_edges = A.sum().sum()
no_nodes = A.shape[1]

###################### Basic Feature Definitions ##########################
print("Let Us Start Basic Feature Definition of IB and OB and read exp(A)")
A = A.values 
expA = pd.read_csv("exp_mat.csv",header = None)
expA = expA.values
#expA_n = expA/(expA.max().max())
#expA_n = expA_n.round(5)
IB_exp = np.sum(expA,axis = 0)   ###columnwise  Inboundnes
OB_exp = np.sum(expA,axis = 1)   ###rowwise     Outboundness
IB_adj = np.sum(A,axis = 0)
OB_adj = np.sum(A,axis = 1)

cntrl = [] 
for i in range(no_nodes): 
      cntrl.append(expA[i][i])

print("Start appending features")

feat_train = []
lab_train = []
for i in range(no_nodes):
    for j in range(no_nodes):
        lab_train.append(A[i][j])
        temp = []
        #node features
        '''
        temp.append(IB_exp[i])
        temp.append(IB_exp[j])
        temp.append(OB_exp[i])
        temp.append(OB_exp[j])
        temp.append(cntrl[i])
        temp.append(cntrl[j])
        '''
        #edge features
        temp.append(expA[i][j])
        temp.append(IB_adj[i])
        temp.append(IB_adj[j])
        temp.append(OB_adj[i])
        temp.append(OB_adj[j])
        foo = cs(A[i],A[j])
        temp.append(foo[0][0])
        temp.append(js(A[i],A[j]))

        feat_train.append(temp)

print("Calculating training and testing feature")
edge_size = 2430
per = 0.8        
feat_ones = []
feat_zeros = []
lab_ones = []
lab_zeros = []
count = 0
for i in range(no_nodes):
    for j in range(no_nodes):
        if i==j:
            continue
        if lab_train[300*i+j]==1:
            feat_ones.append(feat_train[300*i+j])
            lab_ones.append(1)
        else:
            if count<edge_size:
                if random.randint(0,1)==1:
                    feat_zeros.append(feat_train[300*i+j])
                    lab_zeros.append(0)
                    count = count+1

temp = feat_ones+feat_zeros
temp_norm = normalize(temp)
feat_ones = temp_norm[0:edge_size][:]
feat_zeros = temp_norm[edge_size:][:]

order1 = np.random.permutation(edge_size)
order2 = np.random.permutation(edge_size)
train_feat = []
train_lab = []
test_feat = []
test_lab = []                    
for i in range(int(per*edge_size)):
    train_feat.append(feat_ones[order1[i]])
    train_lab.append(lab_ones[order1[i]])
for i in range(int(per*edge_size)):
    train_feat.append(feat_zeros[order2[i]])
    train_lab.append(lab_zeros[order2[i]])    
for i in range(int((1-per)*edge_size)):
    c = int(per*edge_size)    
    test_feat.append(feat_ones[order1[c+i]])
    test_lab.append(lab_ones[order1[c+i]])   
for i in range(int((1-per)*edge_size)):
    c = int(per*edge_size)    
    test_feat.append(feat_zeros[order2[c+i]])
    test_lab.append(lab_zeros[order2[c+i]])
                                     
print("Start Logistic Regression")                     
##################            Logistic Regression      ########################
###############################################################################
logistic = LogisticRegression(C = 100000)
feature_df = pd.DataFrame(train_feat)
#edge_array = np.asarray(edge_tr)
edge_array = train_lab
logistic_fit = logistic.fit(feature_df, edge_array)
feature_ts = test_feat
predictions = logistic_fit.predict(feature_ts)
cf = confusion_matrix(test_lab, predictions)
accuracy = (cf[0][0]+cf[1][1])/(cf[0][0]+cf[1][1]+cf[0][1]+cf[1][0])
precision = cf[0][0]/(cf[0][0]+cf[1][0])
recall = cf[0][0]/(cf[0][0]+cf[0][1])
f_sc = (2*precision*recall)/(precision+recall)