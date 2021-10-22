% Compares performance on mnist dataset.

%% cd /X/application/.. from /X/application
cd ..

%% load dataset
load ../data/fmnist_fea_500;
L = 10;    
Y0 = X;
A0 = Label' + 1; % labels start from 1

%% run_experiments
dim=[10000 60000]
%dim = [20000 50000];
YF = mat2cell(Y0,500,dim);
AF = mat2cell(A0,dim,1);
Y1 = YF{1,1};
A1 = AF{1,1};


[CE, ET] = run_S5C(Y1,A1,L,20*L);

%% show clustering error and elapsed time

CE
ET

%% cd /X/application from /X/application/..
cd application
