function [s,idx] = randSort(list)

% RANDSORT  Random sort
%   RANDSORT(V) randomly sorts the terms of V.
%
%   [SORTED,I] = RANDSORT(...) returns the vector I 
%   of list indices so that
%
%     SORTED = V(I);
%
%   See also SORT, RAND

lgt = length(list);
r = rand(1,lgt);
[rs,idx] = sort(r);
s = list(idx);