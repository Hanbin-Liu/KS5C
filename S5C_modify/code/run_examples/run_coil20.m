% Run on coil20 datasets

%% cd /X/application/.. from /X/application
cd ..

%% load dataset
	  
load ../data/COIL20.mat             % We used the resized raw images provided along with the SSC codes.
L = 20;
Y0 = double(fea');
A0 = gnd;

    
%% run experiments

[CE, ET] = run_S5C(roundn(Y0,-4),A0,L,20*L);

%% show clustering error and elapsed time

CE
ET
    

%% cd /X/application from /X/application/..
cd application
