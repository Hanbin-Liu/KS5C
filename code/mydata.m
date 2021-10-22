function [X] = mydata(A0, alpha)
X = [];
for i = 1:10
    A = randn(50,5);
    B = randn(5,200);
    Xi = (A + alpha * A0) * B;
    X = [X Xi];
end