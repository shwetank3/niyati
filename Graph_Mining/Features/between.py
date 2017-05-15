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
expA = pd.read_csv("exp_mat.csv",header = None)
expA_n = expA/(expA.max().max())
expA_n = expA_n.round(5)

######################Creating Features as per EDGES ######################
print("Let Us Start Creating features")
btwn_edge_ij = []
btwn_edge_ji = []

for i in range(no_nodes):
    for j in range(no_nodes): 
      btwn_edge_ij.append(expA_n[i][j])
      btwn_edge_ji.append(expA_n[j][i])

    if(i%500==0):
        complete = i*100/no_nodes
        print('{0:.2g}% Complete'.format(complete))
            
print("Calulating Features complete...")
print("Writing it in CSV File...")
    
###################### Writing it in a File #############################
df1 = pd.DataFrame(btwn_edge_ij)
df1.to_csv("btwn_edge_ij.csv",header = None,index = False)
df2 = pd.DataFrame(btwn_edge_ji)
df2.to_csv("btwn_edge_ji.csv",header = None,index = False)
