%%
clear all
clc
%Eigen Vector Computation
n = 1222;                   %number of points
m = 3;                      %number of dimensions
k = 2;                      %number of clusters
A = csvread('data.csv');      %Adjacency matrix  
[V,D] = eig(A);
[gen_ntg,permutation]=sort(diag(D));    %Sorting Eigen values
V = V(:,permutation);
ED = V(:,end-m+1:end); 
%Columns are eigen vectors
idx = kmeans(ED,k);

%%
B = expm(A);
[V1,D1] = eig(B);
[gen_ntg1,permutation1]=sort(diag(D1));    %Sorting Eigen values
V1 = V1(:,permutation1);
ED1 = V1(:,end-m+1:end); 
%Columns are eigen vectors
idx1 = kmeans(ED1,k);