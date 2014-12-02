function [d,D_l,D_p] = lp2d(l,p)

% LP2D  Line-point signed distance, in 2D.
%   LP2D(HM,P) is the orthogonal signed distance from point P to the 2-D
%   homogeneous line HM. The point P can be either an Euclidean 2-vector or
%   a projective (homogeneous) 3-vector.
%
%   [d,D_hm,D_p) = LP2D(...) returns the Jacobians wrt HM and P.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if numel(p) == 2
    [p,P_p] = euc2hmg(p);
else
    P_p = 1;
end

n   = l(1:2);
nn2 = dot(n,n);
nn  = sqrt(nn2);
ltp = l'*p;

d   = ltp/p(3)/nn;

if nargout > 1 % jac
    
    nn3     = nn2*nn;

    [u,v,w] = split(p);
    [a,b,c] = split(l);
    
    D_l = [ u/w/nn-ltp/w/nn3*a, v/w/nn-ltp/w/nn3*b,  1/nn             ];
    D_p = [ a/w/nn,             b/w/nn,              c/w/nn-ltp/w^2/nn]*P_p;

end

return

%% jac

syms a b c u v w real
l = [a;b;c];

%% Euclidean build
p = [u;v];
d = lp2d(l,p)

D_l = jacobian(d,l)
D_p = jacobian(d,p)

%% Euclidean test
p = [u;v];
[d,D_l,D_p] = lp2d(l,p)

D_l - jacobian(d,l)
D_p - jacobian(d,p)

%% Homog build
p = [u;v;w];
d = lp2d(l,p)

D_l = jacobian(d,l)
D_p = jacobian(d,p)

%% Homog test
p = [u;v;w];
[d,D_l,D_p] = lp2d(l,p)

simplify(D_l - jacobian(d,l))
simplify(D_p - jacobian(d,p))



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

