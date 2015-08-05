function [idp, IDP_rf, IDP_sf, IDP_k, IDP_c, IDP_v] = retroProjIdpPntFromPhdOnRob(Rf, Sf, k, c, v)

% RETROPROJIDPPNTFROMPHDONROB Retro-proj Inverse depth point from
% Pinhole-depth in Rob 
%   [idp, IDP_rf, IDP_sf, IDP_k, IDP_c, IDP_v] =
%   RETROPROJIDPPNTFROMPHDONROB(Rf, Sf, k, c, v) retro-projects the
%   pixel+depth measurement v from a pinhole+depth camera installed on a
%   robot. The robot frame is Rf, and the camera frame in the robot is Sf.
%   k is the intrinsic vector of the subjacent pinhole model, and c the
%   distortion correction vector.
%
%   See also INVPINHOLEDEPTH, PROJEUCPNTINTOPHDONROB.

%   Copyright 2015-     Ellon Paiva @ LAAS-CNRS.


if nargout == 1
    
    idp = ahp2idp(retroProjAhmPntFromPinHoleOnRob(Rf, Sf, k, c, v(1:2), 1/v(3)));
    
else
    
    [ahp, AHP_rf, AHP_sf, AHP_k, AHP_c, AHP_u, AHP_rho] = retroProjAhmPntFromPinHoleOnRob(Rf, Sf, k, c, v(1:2), 1/v(3));
    [idp, IDP_ahp] = ahp2idp(ahp);
    
    IDP_rf  = IDP_ahp*AHP_rf;
    IDP_sf  = IDP_ahp*AHP_sf;
    IDP_k  = IDP_ahp*AHP_k;
    if ~isempty(c)
        IDP_c  = IDP_ahp*AHP_c;
    else
        IDP_c = [];
    end
    % EP-WARNING: Not sure this is the way to compute IDP_v
    IDP_v(:,1:2) = IDP_ahp*AHP_u;
    IDP_v(:,3) = IDP_ahp*AHP_rho*(-1/(v(3)^2));
    
end

return

%%

syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd u0 v0 au av x y z real
Rf.x = [rx ry rz ra rb rc rd]';
Rf = updateFrame(Rf);
Sf.x = [sx sy sz sa sb sc sd]';
Sf = updateFrame(Sf);
k = [u0 v0 au av]';
l = [x y z]';

[u, U_r, U_s, U_k, U_d, U_l] = ...
    projEucPntIntoPhdOnRob(Rf, Sf, k, [], l);

[p, P_r, P_s, P_k, P_c, P_u] = retroProjEucPntFromPhdOnRob(Rf, Sf, k, [], u);


% simplify(U_r - jacobian(u,Rf.x)) % Too slow



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

