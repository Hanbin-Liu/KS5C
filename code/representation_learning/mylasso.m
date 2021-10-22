function STATS = mylasso(K,S,STATS,i)


% --------------------
% Lasso model fits
% --------------------
norms = STATS.normsSt;                                                                                                             
KS = STATS.KSt;
KI= K(i,S)';


w_size = size(S,2);                                                        
w_vec = STATS.W(1:w_size,i);                                               


fittic =tic;
[~,diag_col] = find(S==i);                                             
[w_vec,time_for_CD] = lassoFit(diag_col, KS, w_vec, i, ...               
                                 STATS.Lambda, ...
                                 STATS.reltol, norms,S,KI);
time_for_fit = toc(fittic);

STATS.W(1:w_size,i) = w_vec;

STATS.time_for_CD = STATS.time_for_CD + time_for_CD ;
STATS.time_for_fit = STATS.time_for_fit + time_for_fit ;

end



% ===================================================
%                 lassoFit() 
% ===================================================
function [w,time_for_CD] = lassoFit(diag_col, K, w, i, threshold, ...     
                                     reltol, norms, S,KI);
                                              

t_other = zeros(1,3);

active = (w ~= 0)';                                                        
time_for_CD = 0;

wold = w;

% Iterative coordinate descent until converged      
while true                                                                                                                                          

  start_CD = tic;
  
  rand_idx = int64(setdiff(find(active), diag_col) );
  [w] = cdescentCycle(K,i,w,rand_idx,active,norms,threshold,S,KI);      
  
  active = (w ~= 0)';
 
  time_for_CD = time_for_CD + toc(start_CD);

  if norm( (w-wold) ./ (1.0 + abs(wold)), Inf ) < reltol
    % Cycling over the active set converged.
    % Do one full pass through the predictors.
    % If there is no predictor added to the active set, we're done.
    % Otherwise, resume the coordinate descent iterations.
    wold = w;
  
    potentially_active = (KI-K*w)';
    potentially_active = abs(potentially_active) > threshold;
     
    if any(potentially_active)
      new_active = active | potentially_active;                     
      start_CD = tic;

      rand_idx = int64(setdiff(find(new_active), diag_col) );
      [w] = cdescentCycle(K,i,w,rand_idx,new_active,norms,threshold,S,KI);      

      new_active = (w ~= 0)';
      
      time_for_one_CD = toc(start_CD);
      time_for_CD = time_for_CD + time_for_one_CD ;
    else
      new_active = active;
    end

    if isequal(new_active, active)
      break
    else
      active = new_active;
    end
    
    if norm( (w-wold) ./ (1.0 + abs(wold)), Inf ) < reltol
      break
    end
    
  end % of if norm( (w-wold) ./ (1.0 + abs(wold)), Inf ) < reltol

  wold = w;
  
end % of while true

end                                                                        

% ===================================================
%                 cdescentCycle() 
% ===================================================

function [w] = cdescentCycle(K,i,w, rand_idx,active,norms, ...             
                               threshold,S,KI)

num_rand = size(rand_idx,1) * size(rand_idx,2);
if(num_rand == 0)
  return;
else
  rand_idx = rand_idx(randperm(num_rand));
end

S = int64(S);
[w] = cdescentCycleC(K,i,w,rand_idx,norms,threshold,S,KI);                 
 
end %-cdescentCycle

