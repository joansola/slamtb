function [b,i] = sBiggest(S,f,n)

% SBIGGEST  get biggest members of structure array
%   SBIGGEST(S,F,N) gets the N members of structure S that have
%   the biggest value in field F. If N is ommited the sorted
%   structure is returned.
%
%   [B,I] = SBIGGEST(...) returns the indices to S of the biggest
%   members so that
%
%      B = S(I)
%

% (c) 2005 Joan sola

if nargin < 3
    n = length(S);
end

[b,i] = vBiggest([S.(f)],n);

