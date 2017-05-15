# -*- coding: utf-8 -*-
"""
Created on Tue Apr 25 18:29:23 2017

@author: shwetank
"""
import pandas as pd
from sklearn.metrics import jaccard_similarity_score as js
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning) 

print("Reading Adjacency Matrix")
A = pd.read_csv("adjMat.csv",header=None);

no_edges = A.sum().sum()
no_nodes = A.shape[1]

###################### Basic Feature Definitions ##########################
print("Let Us Start Basic Feature Definition of IB and OB and read exp(A)")
A = A.values 
######################Creating Features as per EDGES ######################
print("Let Us Start Creating features")
jac_sim_ij = []
jac_sim_ji = []

for i in range(no_nodes):
    for j in range(no_nodes): 
      jac_sim_ij.append(js(A[i],A[j]))
      jac_sim_ji.append(js(A[j],A[i]))

    if(i%500==0):
        complete = i*100/no_nodes
        print('{0:.2g}% Complete'.format(complete))
            
print("Calulating Features complete...")
print("Writing it in CSV File...")
    
###################### Writing it in a File #############################
df1 = pd.DataFrame(jac_sim_ij)
df1.to_csv("jac_sim_ij.csv",header = None,index = False)
df2 = pd.DataFrame(jac_sim_ji)
df2.to_csv("jac_sim_ji.csv",header = None,index = False)
