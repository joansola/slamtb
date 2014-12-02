function [a,Ak,Al] = aInvPinHolePlucker(k,l)

% AINVPINHOLEPLUCKER  Inverse pin hole model for Plucker lines
%   A = AINVPINHOLEPLUCKER(K,L) returns the director vector A of the plane
%   defined by the detected line L and the optical center in a camera with
%   intrinsic parameters K=[u0 v0 au av].
%
%   [A,Ak,Al] = ... returns the Jacobians wrt L and K.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

iK = pluckerInvCamera(k);

a = iK*l;

if nargout > 1

    [u0,v0,au,av] = split(k);
    [l1,l2,l3]    = split(l);
    
    iauav = 1/au/av;
    iau2  = 1/au^2;
    iav2  = 1/av^2;
    d     = (u0*l1+v0*l2+l3);
    
    Ak = [...
        [        0,        0,          0,   -iav2*l1]
        [        0,        0,   -iau2*l2,          0]
        [ iauav*l1, iauav*l2, -d*iau2/av, -d/au*iav2]];

    Al = iK;

end

return

%% build jac

syms u0 v0 au av l1 l2 l3 real
k = [u0 v0 au av]';
l = [l1 l2 l3]';

a = aInvPinHolePlucker(k,l);

Ak1 = simplify(jacobian(a,k))
Al1 = simplify(jacobian(a,l))

%% test jac

syms u0 v0 au av l1 l2 l3 real
k = [u0 v0 au av]';
l = [l1 l2 l3]';

[a,Ak,Al] = aInvPinHolePlucker(k,l);

Ak1 = simplify(jacobian(a,k));
Al1 = simplify(jacobian(a,l));

simplify(Ak-Ak1)
simplify(Al-Al1)



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

