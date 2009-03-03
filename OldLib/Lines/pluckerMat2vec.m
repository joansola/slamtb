function l = pluckerMat2vec(L)

% PLUCKERMAT2VEC Plucker matrix to Plucker vector conversion.
%   PLUCKERMAT2VEC(L) is the vector l so that 
%   L =  [hat(n) -v
%         v'     0]
%   where n = l(1:3) and v = l(4:6);

l = L([7;9;2;4;8;12]);

