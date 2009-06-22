function H = homogeneous(f)

% HOMOGENEOUS Builds homogeneous motion matrix from frame f.


[t,q,R] = splitFrame(f);

H = [R t;0 0 0 1];

end
