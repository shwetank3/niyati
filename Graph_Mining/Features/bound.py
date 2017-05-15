# -*- coding: utf-8 -*-
"""
Created on Tue Apr 25 18:29:23 2017

@author: shwetank
"""
import pandas as pd
import numpy as np
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
IB = np.sum(expA,axis = 0)   ###columnwise  Inboundness
OB = np.sum(expA,axis = 1)   ###rowwise     Outboundness
IB_n = IB/IB.max()
OB_n = OB/OB.max()
IB_n = IB_n.round(5)
OB_n = OB_n.round(5)
######################Creating Features as per EDGES ######################
print("Let Us Start Creating features")
IB_edge = []  
OB_edge = []


for i in range(no_nodes):
    if(i==1):
      break  
    for j in range(no_nodes): 
      IB_edge.append(IB_n[[i]])
      OB_edge.append(OB_n[[j]])  

    if(i%500==0):
        complete = i*100/no_nodes
        print('{0:.2g}% Complete'.format(complete))
            
print("Calulating Features complete...")
print("Writing it in CSV File...")
    
###################### Writing it in a File #############################
df1 = pd.DataFrame(IB_edge)
df1.to_csv("IB.csv",header = None,index = False)
df2 = pd.DataFrame(OB_edge)
df2.to_csv("OB.csv",header = None,index = False)

