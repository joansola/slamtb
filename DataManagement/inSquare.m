function inSq = inSquare(data,sq,m)

% INSQUARE  Points inside square.
%   INSQUARE(DATA,SQ) returns TRUE for those points in point
%   matrix DATA that are inside a rectangle SQ.
%
%   INSQUARE(DATA,SQ,MARGIN) considers a point inside the
%   rectangle if it is further than MARGIN units from its
%   borders.
%
%   SQ is defined by its limits as SQ = [xmin xmax ymin ymax].
%
%   DATA is a 2D-points matrix : DATA = [P1 ... PN] ,
%   with Pi = [xi;yi].

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 3
    inSq = (data(1,:) >= sq(1)) & ...
        (data(1,:) <= sq(2)) & ...
        (data(2,:) >= sq(3)) & ...
        (data(2,:) <= sq(4));
else
        inSq = (data(1,:) >= sq(1) + m) & ...
        (data(1,:) <= sq(2) - m) & ...
        (data(2,:) >= sq(3) + m) & ...
        (data(2,:) <= sq(4) - m);
end


return

%%

all(data>=sq([1 3])')
all(data<=sq([2 4])')
all(data>=sq([1 3])') && all(data<=sq([2 4])')










