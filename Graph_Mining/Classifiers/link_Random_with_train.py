# -*- coding: utf-8 -*-
"""
Created on Wed Apr 26 12:11:42 2017

@author: shwetank
"""
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
####################### READING FEATURE FILES ################################
edge_hd = open('edge.csv','r')
#ib_hd = open('IB.csv','r')
#ob_hd = open('OB.csv','r')
cntrl_src_hd = open('cntrl_edge_src.csv','r')
cntrl_dst_hd = open('cntrl_edge_dst.csv','r')
btwn_ij_hd = open('btwn_edge_ij.csv','r')
btwn_ji_hd = open('btwn_edge_ji.csv','r')
#jac_ij_hd = open('jac_sim_ij.csv','r')
#jac_ji_hd = open('jac_sim_ji.csv','r')
#cos_ij_hd = open('cos_sim_ij.csv','r')
#cos_ji_hd = open('cos_sim_ji.csv','r')

######################### TRAINING SET ########################################
feature_tr = []
edge_tr = []
################## Enter Values ... PLzzzzzzzzzzzzzzzz
no_train_1 = 5000
no_train_0 = 5000
tr_strt = 50000
tr_strt_pt = 0
##################

count1 = 0
count0 = 0
start = 0
no_train = no_train_1 + no_train_0

edge_hd.seek(tr_strt_pt)
cntrl_src_hd.seek(tr_strt_pt)
cntrl_dst_hd.seek(tr_strt_pt)
btwn_ij_hd.seek(tr_strt_pt)
btwn_ji_hd.seek(tr_strt_pt)

for (e,cs,cd,bij,bji) in zip(edge_hd,cntrl_src_hd,cntrl_dst_hd,btwn_ij_hd,btwn_ji_hd):
 start = start + 1 
 if(start>tr_strt):
  if(count1<no_train_1 and int(e.rstrip('\n'))==1): 
    feature = [float(cs.rstrip('\n')),float(cd.rstrip('\n')),float(bij.rstrip('\n')),float(bji.rstrip('\n'))]
    feature_tr.append(feature)
    edge_tr.append(int(e.rstrip('\n')))
    count1 = count1 + 1
  if(count0<no_train_0 and int(e.rstrip('\n'))==0): 
    feature = [float(cs.rstrip('\n')),float(cd.rstrip('\n')),float(bij.rstrip('\n')),float(bji.rstrip('\n'))]
    feature_tr.append(feature)
    edge_tr.append(int(e.rstrip('\n')))
    count0 = count0 + 1
  if(count0+count1 == no_train):
      print("Training Set Made... Go on next stage")
      break
    
############################# TESTING SET #####################################
feature_ts = []
edge_ts = []
################## ENTER VALUES... PLzzzzzzzzzzzzzzzz
no_test_1 = 20
no_test_0 = 20
ts_strt = 50000
ts_strt_pt = 0
##################

count1 = 0
count0 = 0
start = 0
no_test = no_test_1 + no_test_0

edge_hd.seek(ts_strt_pt)
cntrl_src_hd.seek(ts_strt_pt)
cntrl_dst_hd.seek(ts_strt_pt)
btwn_ij_hd.seek(ts_strt_pt)
btwn_ji_hd.seek(ts_strt_pt)
for (e,cs,cd,bij,bji) in zip(edge_hd,cntrl_src_hd,cntrl_dst_hd,btwn_ij_hd,btwn_ji_hd):
 start = start + 1 
 if(start> ts_strt):
  if(count1<no_test_1 and int(e.rstrip('\n'))==1): 
    feature = [float(cs.rstrip('\n')),float(cd.rstrip('\n')),float(bij.rstrip('\n')),float(bji.rstrip('\n'))]  
    feature_ts.append(feature)
    edge_ts.append(int(e.rstrip('\n')))
    count1 = count1 + 1
  if(count0<no_test_0 and int(e.rstrip('\n'))==0): 
    feature = [float(cs.rstrip('\n')),float(cd.rstrip('\n')),float(bij.rstrip('\n')),float(bji.rstrip('\n'))]  
    feature_ts.append(feature)
    edge_ts.append(int(e.rstrip('\n')))
    count0 = count0 + 1
  if(count0+count1 == no_test):
    print("Testing Set Made... Go on next stage")  
    break
###############################Delete Useless Variables########################
del count0
del count1
###### Creating train.csv and test.csv ########################################
#train_df = pd.DataFrame({'edge':e_tr,'Cntrl_SRC': cs_tr,'Cntrl_DST': cd_tr,'Btn_ij': bij_tr,'Btn_ji': bji_tr})
#train_df.to_csv("train.csv",header = None,index = False)

#test_df = pd.DataFrame({'edge':e_ts,'Cntrl_SRC': cs_ts,'Cntrl_DST': cd_ts,'Btn_ij': bij_ts,'Btn_ji': bji_ts})
#test_df.to_csv("test.csv",header = None,index = False)

###############################################################################
##################            Random Forest            ########################
###############################################################################
clf = RandomForestClassifier(n_estimators = 500, oob_score = True)
feature_df = pd.DataFrame(feature_tr)
edge_array = np.asarray(edge_tr)
clf = clf.fit(feature_df, edge_array)

predictions = clf.predict(feature_ts)




























