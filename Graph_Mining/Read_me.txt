The Folder contains 4 SubFolders namely : 
1. Features
2. Classifiers
3. Sample_Dataset
4. Others

1. FEATURES
a. It contains Python Files named between.py, bound.py, centrality.py, cosine.py, edge.py, jaccard.py and sparse.py.
b. File 'sparse.py' takes 'adjMat.csv' as input csv file to read the adjacency matrix.
   It gives output as 'exp_mat.csv' by computing the exponential of the adjacency matrix.
   It does that by either directly computing the exponential using 'library scipy' or using 'scipy.sparse' by converting it into sparse format.
c. Remaining python files then takes 'adjMat.csv' and 'exp_mat.csv' as input.
   Each python file then outputs and saves the corresponding features in an external file in .csv format.
   Each file computes a particular feature for the model.
   
2. CLASSIFIERS
a. There are two broad sets of Algorithm used for link prediction, depending upon the convenience of use.
b. First Set contains 'link_Random_with_train.py' and 'link_logisitic_with_train.py'.
c. This set takes features .csv files as input from Folder Features and performs the Random Forest and Logistic Regression Classification respectively.
d. This set is mainly useful for very huge graph, with high number of nodes and features.
e. Second Set contains files namely 'feat_graph.py', 'feat_graph_logistic.py', 'feat_graph_nn.py' and 'feat_graph_svm.py'.
f. This set of Algorithm takes 'adjMat.csv' and 'exp_mat.csv' as input.
g. It computes and appends the useful features on real-time basis, without storing the features in an external file.

3. SAMPLE_DATASET
a. This Folder contains small sample of input data files namely 'adjMat.csv' and 'exp_mat.csv'.
b. 'adjMat.csv' is the adjacency matrix of 300 nodes.
c. 'exp_mat.csv' is the calculated exponential of 'adjMat.csv' adjacency matrix. 
d. These data files can be used for Testing and Preliminary analysis of the Link-Prediction Codes. 

4. OTHERS
a. It contain files 'exponential2.m', 'spectral_clustering.m' and 'workingPythonLinkPrediction.pbs'.
b. 'exponential2.m' is MATLAB Code, used to estimate and compare the computational time in performing the eigen decomposition of the Adjacency and corresponding Exponential Matrix.
c. 'spectral_clustering.m' was written to perform the spectral clustering analysis on MATLAB.
d. 'workingPythonLinkPrediction.pbs' is the Portable Batch System file. It was used to run a link prediction along with eigen decomposition job on the HPC ARC(Advanced Research Computing) Cluster at Virginia Tech.
   It defines the commands and cluster resources used for the job.




