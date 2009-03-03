function s = regionSize(r)

% REGIONSIZE  Size of a region
%   REGIONSIZE(REG) is the rectangular area spanned by the region
%   REG. 
%
%   See also COV2PAR for an explanetion of the region parameters.

s = (r.XM-r.Xm)*(r.YM-r.Ym);

