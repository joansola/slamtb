function H = getHomogeneous(F)

% GETHOMOGENEOUS  Extract homogeneous matrix from frame structure

H = [F.R F.X(1:3);0 0 0 1];
