function r = addToMap(x,P,r)

global Map

if nargin == 2
    r = newRange(numel(x));
end
Map.used(r) = r;
Map.x(r)    = x;
Map.P(r,r)  = P;

