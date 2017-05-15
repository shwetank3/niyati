clc
clear all
close all

M = csvread('citation_34000.csv');
% A1 = zeros(8297,8297);
good = zeros(9912553,1);
% B = zeros(82168,82168);
assign = zeros(9912553,1);
for i = 1 : size(M,1)
    good(M(i,1)) = 1;
    good(M(i,2)) = 1;
    %B(M(i,1)+1,M(i,2)+1) = 1;
end
prev = 0;
for i = 1 : 9912553
    if good(i)==1
       assign(i) = prev+1;
       prev = prev + 1;
    end
end
A = zeros(prev,prev);
for i = 1 : size(M,1)
   A(assign(M(i,1)),assign(M(i,2))) = 1;
end

A1 = A(1:10000,1:10000);
exp_A = expm(A1);
csvwrite('citation_1000.csv',A1);
csvwrite('exp_citation_1000.csv',exp_A);
%nice = find(good==1);
% A = A1(nice,nice);

%%
tic 
[V,D] = eig(A1);
toc
%%
tic
exp_A = expm(A1);
toc
%%
tic 
[V1,D1] = eig(exp_A);
toc
%%
clc
clear all
close all

M = csvread('citation_34000.csv');
% A1 = zeros(8297,8297);
First_row = M(:,1);
Second_row = M(:,2);
G = digraph(First_row,Second_row);
B = adjacency(G);
%%
good = zeros(9912553,1);
% B = zeros(82168,82168);
assign = zeros(9912553,1);
for i = 1 : size(M,1)
    good(M(i,1)) = 1;
    good(M(i,2)) = 1;
    %B(M(i,1)+1,M(i,2)+1) = 1;
end
prev = 0;
for i = 1 : 9912553
    if good(i)==1
       assign(i) = prev+1;
       prev = prev + 1;
    end
end
A = zeros(prev,prev);
for i = 1 : size(M,1)
   A(assign(M(i,1)),assign(M(i,2))) = 1;
end

%A1 = A(1:10000,1:10000);
A1 = A;