function q = linVec(f,x,P)

% LINVEC  Linearity measure based on the propagation error vector.

[z,J,H] = f(x);
m = length(z);
n = length(x);
q = zeros(m,1);
for i = 1:m
    for j = 1:n
        for k = 1:n
            q(i) = q(i) + H(i,j,k)*P(j,k);
        end
    end
end













