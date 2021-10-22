clc
clear all
K=5;% number of subspaces (clusters), change if necessary
m=30;
n0=300;
r=3;
noise_amplitude=0.5;% noise level, change if necessary
X=[];
D_base=randn(m,r);
Label=[];
for k=1:K
    x=unifrnd(-1,1,[r,n0]);
    T=randn(m,r)*x...
        +1*(randn(m,r)*x.^2+randn(m,1)*[x(1,:).*x(2,:)]++randn(m,1)*[x(1,:).*x(3,:)]+randn(m,1)*[x(2,:).*x(3,:)]...
        +randn(m,r)*x.^3+randn(m,1)*[x(1,:).*x(2,:).*x(3,:)]+randn(m,1)*[x(1,:).^2.*x(2,:)]+randn(m,1)*[x(1,:).^2.*x(3,:)]...
        +randn(m,1)*[x(2,:).^2.*x(1,:)]+randn(m,1)*[x(2,:).^2.*x(3,:)]+randn(m,1)*[x(3,:).^2.*x(1,:)]+randn(m,1)*[x(3,:).^2.*x(2,:)]);
    X=[X T];
    Label=[Label ones(1,n0)*k];
end
[m,n]=size(X);
E=randn(m,n)*std(X(:))*noise_amplitude;
Xn=X+E;

save nonlinear.mat
