function f = cloister(xmin,xmax,ymin,ymax,n)

% CLOISTER  generates features in a cloister shape
%   CLOISTER(XMIN,XMAX,YMIN,YMAX) generates a 2D cloister
%   in the limits indicated as parameters

if nargin < 5
    n = 9;
end

hsize = xmax-xmin;
vsize = ymax-ymin;
tsize = diag([hsize vsize]);

midle  = (n-3)/2;
int    = (n-1)/2;
ext    = (n+1)/2;
cmidle = [-midle:midle];
cint   = [cmidle int];
cext   = [-int cint];
zmidle = zeros(1,n-2);
zint   = zeros(1,n-1);
zext   = zeros(1,n);

northint = [cint;zint+int];
northext = [cext;zext+ext];

southint = [-cint;zint-int];
southext = [-cext;zext-ext];

eastint  = [zint+int;-cint];
eastext  = [zext+ext;-cext];

westint  = [zint-int;cint];
westext  = [zext-ext;cext];

centh  = [cmidle;zmidle];
centv  = [zmidle;cmidle];

% remove central doubled point
s = size(centh,2);
if mod(s,2) ~= 0
    c = (s+1)/2;
    centh(:,c) = [];
end



f = [northint northext southint southext eastint eastext westint westext centh centv];
% f = f-n/2-1;
f = tsize*f/(n+1);
