# -*- coding: utf-8 -*-
"""
Created on Tue Apr 25 10:17:59 2017

@author: shwetank
"""
import scipy as sp 
import pandas as pd
import numpy as np
from scipy import sparse
from scipy.linalg import solve_banded

A = pd.read_csv('adjMat.csv', header = None)
A = A.values
expA = sp.linalg.expm(A)

sA_c = sparse.csc_matrix(A) 
expsA_c = sp.linalg.expm(sA_c).todense()
#expsA_C_dense = expsA_c.todense()

df = pd.DataFrame(expA)
df.to_csv("exp_mat.csv",header = None,index = False)
