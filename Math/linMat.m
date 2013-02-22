function Q = linMat(f,x,P)

% LINMAT  Linearity measure based on the quadratic Jacobian error.

[z,J,H] = f(x);
m = length(z);
n = length(x);
Q = zeros(m);
for k = 1:size(H,n)
    Q = Q + H(:,:,k)*P*H(:,:,k)';
end

    








