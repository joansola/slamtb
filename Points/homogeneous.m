function H = homogeneous(f)

% HOMOGENEOUS Buils homogeneous motion matrix from frame f.


[t,q,R] = splitFrame(f);

H = [R t;0 0 0 1];

end
