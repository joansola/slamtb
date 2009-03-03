function [pix,sc] = regionScan(patch,region)

% REGIONSCAN  scan region for a given patch
%   REGIONSCAN(PATCH,REGION) scans the region REGION for a
%   patch PATCH and returns the matching pixel.
%
%   REGION is a structure with the following fields:
%     type: 'ellipse' or 'ray'
%     data: a Ray structure or an Ellipse structure
%     ns:   number of sigma-bound.
%
%   [PIX,SC] = REGIONSCAN(...) returns also the correlation
%   score.
%
%   See also ZNCC, PATCHCORR

switch region.type
    case 'ray'
    case 'ellipse'
        U = region.data.U;
        Q = inv(U);
        Qxx = Q(1,1);
        Qyy = Q(2,2);
        Qxy = Q(1,2);
        h = region.ns/sqrt(Qxx); % length of semiline
        v = region.ns/sqrt(Qyy); % length of semicolumn
        H = region.ns*sqrt(U(1,1)); % semiwidth of bounding box
        V = region.ns*sqrt(U(2,2)); % semiheight of bounding box
        mx = -Qxx/Qxy; % slope if x ordinate
        my = -Qyy/Qxy; % slope if y ordinate
end