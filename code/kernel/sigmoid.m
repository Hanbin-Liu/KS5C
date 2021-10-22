function [K] = sigmoid(X,c,theta)
nx=size(X,2);
XX=X'*X;
xx=sum(X.*X,1);
D=repmat(xx',1,nx) + repmat(xx,nx,1) - 2*XX;
alpha = mean(real(D(:).^0.5));
sigma = c*alpha;

beta = c/(2*sigma^2);
K = tanh(beta*(X'*X)+theta);
end