# -*- coding: utf-8 -*-
"""
Created on Fri Apr  7 17:19:52 2017

@author: shwetank
"""
import os
import pandas as pd
import xlsxwriter as xl

path = 'C:\\Users\shwetank\Desktop\SEM3\Time-Series\project\data_file\\'
myfiles = {}

for (i,filename) in zip(range(1,len(os.listdir(path))+1),os.listdir(path)):
    f = pd.read_csv(path+filename,dtype = {"Unnamed: 16":object})
    myfiles[i] = f
    
#print(myfiles[1].head())
####################Shifting Columns in Python ################################

# Acessing any index in dataframe
#print(myfiles[1]["Date"][0:3])

###Insert new columns in File 2
myfiles[2]['Unnamed: 13'] = float("Nan")
myfiles[2]['Unnamed: 14'] = float("Nan")
myfiles[2]['Unnamed: 15'] = float("Nan")
myfiles[2]['Unnamed: 16'] = float("Nan")

#print(myfiles[2][0:5])
#a = pd.Series(["1","12d","acv","bad","adf"])
#a.str.findall("1")
#a = myfiles[1][0:5]
#colnew = list(a.iloc[:,16:17])+list(a.iloc[:,4:16])
#a.loc[:,colold] = a.loc[:,colnew].values
colnew = ['Unnamed: 16']+list(myfiles[1].iloc[:,4:16])
colold = list(myfiles[1].iloc[:,4:17])
for i in range(1,5):
    tempchange = myfiles[i][myfiles[i]["Dew point"].str.contains("%")].loc[:,colnew].values
    myfiles[i].loc[myfiles[i]["Dew point"].str.contains("%"),colold] = tempchange
    
###############################################################################


