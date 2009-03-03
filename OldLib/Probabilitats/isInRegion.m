function ins = isInRegion(x,region)
%
% ISINREGION  true if point is inside the given region
%   ISINREGION(X,REGION) evaluates true if the point X is inside
%   the region REGION. 
%
%   REGION is a structure containing
%     REGION.type:   the type of region, 'ray' or 'ellipse'.
%     REGION.ns:     the number of sigma bounds that define
%       the scope of each ellipse of the region.
%     REGION.data:   one of these two configurations
%     - If REGION.type = 'ray' then REGION.data is a Ray structure.
%     - If REGION.type = 'ellipse' then REGION.data is an ellipse
%       structure containing xm (mean) and P (cov. matrix)
%
%   See also ISINRAY, ISINELLI, INITRAYS

if isequal(region.type,'ray')
    ins = isInRay(x,region.data,region.ns);
else
    ins = isInElli(x,region.data.u,region.data.U,region.ns);
end
