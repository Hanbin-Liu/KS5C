% Compares performance on mnist dataset.

%% cd /X/application/.. from /X/application
cd ..

%% load dataset
load ../data/htru_2.mat;
L = 2;    
Y0 = X';
A0 = Label+1; % labels start from 1

%% run_experiments


[CE, ET, Kernel_time] = run_S5C(Y0,A0,L,20*L);

%% show clustering error and elapsed time

Kernel_time
CE
ET

%% cd /X/application from /X/application/..
cd application
