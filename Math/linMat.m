function Q = linMat(f,x,P)

[z,J,H] = f(x);
m = length(z);
n = length(x);
Q = zeros(m);
for k = 1:size(H,n)
    Q = Q + H(:,:,k)*P*H(:,:,k)';
end

    