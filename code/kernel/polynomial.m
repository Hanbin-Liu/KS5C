function [K] = polynomial(X,d)
XX = X'*X;
K = (XX - min(min(XX))).^d;
%K = (XX - c).^d;
end