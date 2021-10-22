% Run on gtsrb500 datasets

%% cd /X/application/.. from /X/application
cd ..

%% load dataset
	  
load ../data/GTSRB_500.mat             % We used the resized raw images provided along with the SSC codes.
L = 14;
Y0 = double(X);
A0 = Label';

    
%% run experiments

[CE, ET] = run_S5C(Y0,A0,L,20*L);

%% show clustering error and elapsed time

CE
ET
    

%% cd /X/application from /X/application/..
cd application
