function [K,sigma] = gaussian_tSNE(X,beta)
nx=size(X,2);
XX=X'*X;
xx=sum(X.*X,1);
D=repmat(xx',1,nx) + repmat(xx,nx,1) - 2*XX;
B=repmat(beta,1,nx);
K=exp(-D.*B/2);
K=(K+K')/2;
end