function [v, V_p, V_k, V_d] = pinHoleDepth(p,k,d)


% PINHOLEDEPTH Pin hole projection with distance measurement
%
%   See also PINHOLE

% Copyright 2015 Joan Sola @ IRI-UPC-CSIC

if nargout == 1
    [v(1:2,:),v(3,:)] = pinHole(p,k,d);
else
    [u,s,U_p,U_k,U_d] = pinHole(p,k,d);
    v = [u;s];
    V_p = [U_p ; 0 0 1];
    V_k = [U_k ; zeros(1, length(k))];
    V_d = [U_d ; zeros(1, length(d))];
end
