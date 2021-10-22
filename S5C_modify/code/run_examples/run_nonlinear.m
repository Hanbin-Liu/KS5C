%
% Perform experiments on Yale B dataset.
%

%% cd /X/application/.. from /X/application
cd ..

load ../data/nonlinear.mat  
Y = Xn;
L = k;

%% run experiments

[CE, ET] = run_S5C(normc(Y),Label',L,20*L);

%% show clustering error and elapsed time

CE
ET

%% cd /X/application from /X/application/..
cd application
