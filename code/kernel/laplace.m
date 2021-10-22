function [K,sigma] = laplace(X,c)
nx=size(X,2);
XX=X'*X;
xx=sum(X.*X,1);
D=repmat(xx',1,nx) + repmat(xx,nx,1) - 2*XX;
alpha = mean(real(D(:).^0.5));
sigma = c*alpha;
K=exp(-real(D.^0.5)/sigma);
end