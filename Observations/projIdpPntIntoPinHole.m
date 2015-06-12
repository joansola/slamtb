function [u,s,U_s,U_pk,U_pd,U_idp]  = projIdpPntIntoPinHole(Sf, Spk, Spd, idp)

% PROJIDPPNTINTOPINHOLE Project Idp pnt into pinhole.
%    [U,S] = PROJIDPPNTINTOPINHOLE(RF, SF, SPK, SPD, L) projects 3D Inverse
%    Depth points into a pin-hole camera, providing also the non-measurable
%    depth. The input parameters are:
%       SF : pin-hole sensor frame
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       SPD: radial distortion parameters [K2 K4 K6 ...]'
%       L  : 3D inverse depth point [x y z pitch yaw rho]'
%    The output parameters are:
%       U  : 2D pixel [u v]'
%       S  : non-measurable depth
%
%    The function accepts an idp points matrix L = [L1 ... Ln] as input.
%    In this case, it returns a pixels matrix U = [U1 ... Un] and a depths
%    row-vector S = [S1 ... Sn].
%
%    [U,S,U_S,U_K,U_D,U_L] = ... gives also the jacobians of the
%    observation U wrt all input parameters. Note that this only works for
%    single points.
%
%    See also PINHOLE, PY2VEC, PROJIDPPNTINTOPINHOLEONROB.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

p0 = idp(1:3,:);   % origin
py = idp(4:5,:);   % pitch and roll
r  = idp(6,:);     % inverse depth

t = Sf.t; % frame things
q = Sf.q;

if nargout <= 2  % No Jacobians requested

    m = py2vec(py);    % vector from anchor
    v = m - (t-p0).*r;  % vector from sensor
    w = Rtp(q,v);
    u = pinHole(w, Spk, Spd); % pixel
    
    e = w./r;  % euclidean
    s = e(3,:);

else            % Jacobians requested

    if size(idp,2) == 1

        % function calls
        [m,M_py] = py2vec(py);    % vector from anchor
        v        = m - (t-p0)*r;  % vector from sensor
        V_m      = 1;
        V_p0     = r;  %  r*eye(3);
        V_t      = -r; % -r*eye(3);
        V_r      = p0-t;
        [w, W_q, W_v] = Rtp(q,v);
        [u, ~, U_w, U_pk, U_pd] = pinHole(w, Spk, Spd); % pixel
        
        e = w/r;   % euclidean
        s = e(3);  % depth of point


        % chain rule
        U_v  = U_w*W_v;
        U_p0 = U_v*V_p0;
        U_py = U_v*V_m*M_py;
        U_r  = U_v*V_r;
        
        U_t  = U_v*V_t;
        U_q  = U_w*W_q;
        
        U_idp = [U_p0 U_py U_r];
        U_s   = [U_t U_q];

    else
        error('??? Jacobians not available for multiple IDP points.')

    end

end

return
 
%% jac
syms x y z a b c d real
syms au av u0 v0 real
syms d1 d2 d3 real
syms x0 y0 z0 p y r real

Sf.x = [x;y;z;a;b;c;d];
Sf   = updateFrame(Sf);
Spk  = [u0;v0;au;av];
Spd  = [d1;d2;d3];
idp  = [x0;y0;z0;p;y;r];

[u,s,U_s,U_pk,U_pd,U_idp]  = projIdpPntIntoPinHole(Sf, Spk, Spd, idp);
u,s  = projIdpPntIntoPinHole(Sf, Spk, Spd, idp);

simplify(U_pk  - jacobian(u,Spk))
simplify(U_pd  - jacobian(u,Spd))
% simplify(U_idp - jacobian(u,idp))



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

