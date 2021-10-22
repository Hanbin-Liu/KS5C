% Run KS5C algorithm. Lambda is cross-validated in range [2^-1, 2^-2,..., 2^-10].
%
% Param:
%       Y: data matrix (each column is a data point)
%       A0: labels of each datapoints
%       L: number of labels
%       numS: number of subsamples 
%       
% Return:
%       clustering_errors: clustering errors for each lambda
%       elapsed_times: elapsed times for each lambda
%
%


function [clustering_errors, elapsed_times, kernel_time] = run_S5C(Y,A0,L,numS)

  %% addpath
  addpath representation_learning
  addpath spectral_clustering
  addpath utils
  addpath kernel

  %% for reproducible results
  s = RandStream('mcg16807','Seed',25);
  RandStream.setGlobalStream(s);
  initState = RandStream.getGlobalStream();
  
  %% t-SNE perplexity
  %[P,beta] = x2p(normc(Y)',1000,0.0001);
  
  %% Kernel matrix
  start0 = tic;
  
  [K, sigma] = gaussian(normc(Y),5);  % Gaussian kernel with sigma = 2alpha
  %[K] = gaussian_tSNE(normc(Y),beta);
  %[K, sigma] = gaussian_L(normc(Y),0.5,B);
  %K = polynomial(normc(Y),1.5);
  %K = sigmoid(normc(Y),0.5,0);
  %[K, sigma] = laplace(normc(Y),1);
  %K = linear(normc(Y));
  %disp(sigma);
  kernel_time = toc(start0);

  %% Our S5C algorithm
  fprintf('Running KS5C..\n'); 

  elapsed_times = [];	 
  clustering_errors = [];
  iter = 1;  
  for plambda = 1:10
    stream.State = initState;
    lambda = 2^-plambda
    %lambda = 0
    
    start1 = tic;
    [C,~] = representation_learning_S5C(normc(Y), K, lambda, numS);
    elapsed_time_1 = toc(start1);
    
    W = abs(C) + abs(C)';
 
    start2 = tic;
    A = spectral_clustering_S5C(W, L);
    elapsed_time_2 = toc(start2);
    
    elapsed_times(iter) = elapsed_time_1 + elapsed_time_2;
    clustering_errors(iter) = clustering_error(A,A0);      
    iter = iter + 1;	
  end    
end
