function [b,i] = vBiggest(v,n)

% VBIGGEST  get biggest members
%   VBIGGEST(V,N) gets indices of the N biggest members of vector V. If N is
%   omitted the sorted vector is returned.
%
%   [B,I] = VBIGGEST(...) returns the N biggest members of V
%   so that
%
%      B = V(I)
%

% (c) 2005 Joan sola

if nargin < 2
    [b,i] = sort(v,'descend');
else
    n = min(n,length(v));
    [s,i] = sort(v,'descend');
    b     = s(1:n);
    i     = i(1:n);
end
