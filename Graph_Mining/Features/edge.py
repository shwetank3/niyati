# -*- coding: utf-8 -*-
"""
Created on Tue Apr 25 18:29:23 2017

@author: shwetank
"""
import pandas as pd
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
edge = []

for i in range(no_nodes):
    for j in range(no_nodes): 
      edge.append(int(A[i][j]==1))
    if(i%500==0):
        complete = i*100/no_nodes
        print('{0:.2g}% Complete'.format(complete))
            
print("Calulating Features complete...")
print("Writing it in CSV File...")
    
###################### Writing it in a File #############################
df = pd.DataFrame(edge)
df.to_csv("edge.csv",header = None,index = False)


