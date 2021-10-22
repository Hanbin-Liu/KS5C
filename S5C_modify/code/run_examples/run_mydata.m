%
% Perform experiments on Yale B dataset.
%

%% cd /X/application/.. from /X/application
cd ..

%%
load ../data/linear.mat  
Y = Y;
L = 10;
A0 = randn(1,2000);
for i = 1:10
    A0(:,(i-1)*200+1:200*i) = i;
end
%% run experiments

[CE, ET] = run_S5C(normc(Y),A0',L,20*L);

%% show clustering error and elapsed time

CE
ET

%% cd /X/application from /X/application/..
cd application
