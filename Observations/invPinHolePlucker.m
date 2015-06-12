function [L,Lk,Ll,Lbeta] = invPinHolePlucker(k,l,beta)

% INVPINHOLEPLUCKER Retro-projects plucker line
%   INVPINHOLEPLUCKER(K,L,BETA) retro-projects the Plucker line L from a
%   pin hole camera K=[u0;v0;au;av] at the origin. BETA specifies the
%   unobservable direction of the line. BETA is a 2-vector expressed in the
%   plane base given by PLANEVEC2PLANEBASE.
%
%   [l,Lk,Ll,Lbeta] = ... returns Jacobians wrt K, L and BETA.
%
%   See also PLANEVEC2PLANEBASE, PLANEBASE2DIRVECTOR.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 3
    beta = [1;0];
end

if nargout == 1

    an = aInvPinHolePlucker(k,l); % sub-vector A defines the plane

    a  = normvec(an,1); % normalize

    b = planeBase2dirVector(a,beta); % sub-vector b defines the line direction

    L = [a;b];  % Plucker Line

else % jacobians

    [an,ANk,ANl] = aInvPinHolePlucker(k,l); % sub-vector A defines the plane
    [a,Aan]      = normvec(an,0);
    [b,Ba,Bbeta] = planeBase2dirVector(a,beta);

    Ak    = Aan*ANk;
    Al    = Aan*ANl;
    Abeta = zeros(3,2);
    
    Bk    = Ba*Ak;
    Bl    = Ba*Al;
    % Bbeta is already defined

    L     = [a;b];

    Lk    = [Ak;Bk];
    Ll    = [Al;Bl];
    Lbeta = [Abeta;Bbeta];
    
%     Aan
%     ANl
%     LCa = [eye(3);Ba]

end

return

%%
syms u0 v0 au av a b c b1 b2 real

k    = [u0 v0 au av]';
l    = [a;b;c];
beta = [b1;b2];

[L,Lk,Ll,Lbeta] = invPinHolePlucker(k,l,beta);
% L = invPinHolePlucker(k,l,beta);

simplify(Lk    - jacobian(L,k))
simplify(Ll    - jacobian(L,l))
simplify(Lbeta - jacobian(L,beta))



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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

