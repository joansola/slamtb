function H = homogeneous(f)

% HOMOGENEOUS Buils homogeneous motion matrix from frame vector

t = f(1:3);
q = f(4:7);

H = [q2R(q) t;0 0 0 1];
