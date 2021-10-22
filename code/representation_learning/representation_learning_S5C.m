function [C, S_t] = representation_learning_S5C(X, K, lambda, num_subsamples, ...
						 reltol, num_I_t, seed, verbose)
%% parameter spesification
if ~exist('reltol','var')
    reltol = 10^-3;
end
if ~exist('num_I_t','var')
    num_I_t = 1;
end
if ~exist('seed','var')
  %rng(1234)
  rng('shuffle')
else
  %rng(seed)
  rng('shuffle')
end
if ~exist('verbose','var')
   verbose = false;
end

[m,n] = size(X);
if( n < num_subsamples)
  warning = ['number of subsamples are set to be larger than the number of ' ...
             'datapoints. automatically fixed it to be number of datapoints']
  num_subsamples = n;
end

% iteration is taken to be long enough
max_t = num_subsamples*2;
num_rand_idx = num_subsamples*2*num_I_t;
if n >= num_rand_idx
    rand_idx = randperm(n, num_rand_idx);
else
    rand_idx=[];
    for it = 1:ceil( num_rand_idx / n )
        rand_idx = [rand_idx, randperm(n)];
    end
end

S_t = []; % S_t is a set of indices of subsamples at t-th iteration

norms = ones(1,size(X,1)) * (X.^2);                                        
stats = struct (...
    'reltol', reltol,...
    'Lambda', lambda,...
    'time_for_CD',0,...
    'time_for_fit',0,...
    'normsSt', [] ,...
    'KSt',[],...
    'W', zeros(num_subsamples,n)); % C_St                                


%% select selective subsamples. 
selectiontic = tic;
for t = 1:max_t                                                          
    I_t = rand_idx((t-1)*num_I_t+1:t*num_I_t);                             
    
    if(size(S_t,2) ~= 0)      
      for i=I_t                                                            
        stats = mylasso(K, S_t, stats, i);                              
      end
    end
    
    candidate = setdiff(1:n, S_t);                                       
    
    grad_L=[];
    Z = linspace(1,size(S_t,2),size(S_t,2));
    for s=1:size(candidate,2)
        temp = K(I_t,candidate(s)) - K(candidate(s),S_t)*stats.W(Z,I_t);
        
        grad_L = [grad_L temp];
    end
    
    grad = zeros(num_I_t, n);    
    grad(:, candidate) = min(grad_L+lambda, max(0, grad_L-lambda));        
    
    for j=1:num_I_t
      grad(j, I_t(j)) = 0;
    end

    [max_vals, idx] = sort(sum(grad.^2,1),'descend');


    if( max_vals(1) ~= 0)
      dSt = idx(1);    
      S_t = [S_t dSt];                                                    
      stats.normsSt = [stats.normsSt norms(dSt)];                          
      KK = K(:,S_t);
      stats.KSt = KK(S_t,:);
      
      if(size(S_t,2) == num_subsamples)
	break
      end    
    end  
end
selectiontime = toc(selectiontic);
%% solve all lasso with final S_t                                    
lassotic = tic;                           
for i=1:n                                                               
 stats = mylasso(K, S_t, stats, i);                                        
end
lassotime = toc(lassotic);

%% put C into sparse matrix format
settic = tic;
num_St = size(S_t, 2);
row_idx = repmat( S_t, 1, n);
col_idx = repmat( 1:n, num_St, 1);
C = sparse( row_idx, col_idx, stats.W(1:num_St,:), n, n);
setctime = toc(settic);

%% show stats
if verbose
  timestats = containers.Map();
  timestats('1.selection') = selectiontime;
  timestats('2.final lasso') = lassotime;
  timestats('3.fit in all lasso') = stats.time_for_fit;
  timestats('4.CD in fit') = stats.time_for_CD;
  timestats('5.set C') = setctime;

  timestats = [keys(timestats) ; values(timestats)]
end

end
