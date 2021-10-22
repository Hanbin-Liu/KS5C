function [K,sigma] = gaussian_L(X,c,L)
nx=size(X,2);
XX=X'*X;
xx=sum(X.*X,1);
D=repmat(xx',1,nx) + repmat(xx,nx,1) - 2*XX;
alpha = mean(real(D(:).^0.5));
sigma = c*alpha;
K=exp(-D/(2*sigma^2));
K=K(:,L);
end