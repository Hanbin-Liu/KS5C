%
% Perform experiments on Yale B dataset.
%

%% cd /X/application/.. from /X/application
cd ..

load ../data/nonlinear.mat  
Y = Xn;
L = k;

%% run experiments

[CE, ET,Kernel_time] = run_S5C(normc(Y),Label',L,20*L);

%% show clustering error and elapsed time

Kernel_time
CE
ET

%% cd /X/application from /X/application/..
cd application
