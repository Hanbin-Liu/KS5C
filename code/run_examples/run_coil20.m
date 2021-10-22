% Run on coil20 datasets

%% cd /X/application/.. from /X/application
cd ..

%% load dataset
	  
load ../data/COIL20.mat             % We used the resized raw images provided along with the SSC codes.
L = 20;
Y0 = double(fea');
A0 = gnd;

    
%% run experiments

[CE, ET,Kernel_time] = run_S5C(Y0,A0,L,72*L);

%% show clustering error and elapsed time
Kernel_time
CE
ET
    

%% cd /X/application from /X/application/..
cd application
    