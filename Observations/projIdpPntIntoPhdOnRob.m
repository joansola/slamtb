function [u, U_r, U_s, U_k, U_d, U_l] = ...
    projIdpPntIntoPhdOnRob(Rf, Sf, k, d, l)

% PROJIDPPNTINTOPHDONROB Project Inverse-depth point into Pinhole-depth in
% Robot
%   [u, U_r, U_s, U_k, U_d, U_l] = PROJIDPPNTINTOPHDONROB(Rf, Sf, k, d, l)
%   projects the Inverse Depth point l into a pinhole+depth camera
%   installed on a robot. The robot frame is Rf, and the camera frame in
%   the robot is Sf. k is the intrinsic vector of the subjacent pinhole
%   model, and d the distortion vector.
%
%   See also PINHOLEDEPTH, RETROPROJEUCPNTFROMPHDONROB.

%   Copyright 2015-     Ellon Paiva @ LAAS-CNRS.



if nargout == 1
    % Project landmark
    u = pinHoleDepth(toFrame(composeFrames(Rf,Sf), idp2euc(l)), k, d);
    
else
    % IDP to EUC
    [e,E_l] = idp2euc(l);
    
    % Sensor frame in global frame
    [RSf, RS_r, RS_s] = composeFrames(Rf,Sf);
    
    % Landmark in sensor frame
    [lrs, LRS_rs, LRS_e] = toFrame(RSf, e);
    
    % Project landmark
    [u, U_lrs, U_k, U_d] = pinHoleDepth(lrs, k, d);
    
    % Chain rule for Jacobians
    U_l  = U_lrs * LRS_e * E_l;
    U_rs = U_lrs * LRS_rs;
    U_r  = U_rs  * RS_r;
    U_s  = U_rs  * RS_s;
    
end

return

%%

% Verify jacobian when projecting to anchor camera
syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd u0 v0 au av x y z real
Rf.x = [rx ry rz ra rb rc rd]';
Rf = updateFrame(Rf);
Sf.x = [sx sy sz sa sb sc sd]';
Sf = updateFrame(Sf);
Cam = composeFrames(Rf,Sf);
k = [u0 v0 au av]';
l = p2idp([x y z]',Cam.t);

[u, U_r, U_s, U_k, U_d, U_l] = ...
    projIdpPntIntoPhdOnRob(Rf, Sf, k, [], l);

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

