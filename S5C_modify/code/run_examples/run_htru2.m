%% Test performance on cifar10 datasets. 

%% cd /X/application/.. from /X/application
cd ..

%% loading dataset

load ../data/htru_2.mat
L = 2;
Y0 = X';
A0 = Label+1;

%% run experiments

[CE, ET] = run_S5C(Y0,A0,L,20*L);

%% show clustering error and elapsed time

CE
ET

%% cd /X/application from /X/application/..
cd application
