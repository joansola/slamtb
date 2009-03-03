function [im,im0] = cutIm(Im,Im0,sze,fill)

% CUTIM  Cut image
%   [IMOUT,IMOUT0] = CUTIM(IM,IM0,SIZE) gets a rectangular piece of image IM
%   centered at IM0 and of size SIZE = [Hsze,Vsze].
%   If SIZE is scalar, a square region is extracted.
%   Cut image is returned as IMOUT with central pixel IMOUT0.
%   Non overlapped pixels are filled with zeros.
%   
%   CUTIM(IM,IM0,SIZE,FILL) fills the non overlapped pixels with the FILL
%   value.

if nargin < 4 % default filling value
    fill = 0;
end

if length(sze) == 1 % destination size
    sx = sze;
    sy = sze;
else
    sx = sze(1);
    sy = sze(2);
end

sx2 = (sx-1)/2; % half destination sizes
sy2 = (sy-1)/2;

x0 = Im0(1); % original image origin
y0 = Im0(2);

S = size(Im); % original image size
Sx = S(2);
Sy = S(1);

if     ((x0-sx2) >= 1   && ...
        (x0+sx2) <= Sx  && ...
        (y0-sy2) >= 1   && ...
        (y0+sy2) <= Sy  )
    rx = x0-sx2:x0+sx2; % cutting range
    ry = y0-sy2:y0+sy2;
    im = Im(ry,rx); % output image
else
    im = fill*ones(sy,sx);
    
    Xm = max(x0-sx2 , 1); % index bounds in original image
    XM = min(x0+sx2 , Sx);
    Ym = max(y0-sy2 , 1);
    YM = min(y0+sy2 , Sy);
    
    xm = max(sx2-x0+2    , 1); % index bounds in destination im.
    xM = min(Sx-x0+sx2+1 , sx);
    ym = max(sy2-y0+2    , 1);
    yM = min(Sy-y0+sy2+1 , sy);
    
    im(ym:yM,xm:xM) = Im(Ym:YM,Xm:XM); % output image
end
    
im0 = [sx2+1;sy2+1];




