function [u,s,U_cf,U_k,U_d,U_pap]  = projPapPntIntoPinHole(Cf, k, d, pap)
% PROJPAPPNTINTOPINHOLEONROB Project Pap pnt into pinhole on robot.
%    [U,S] = PROJPAPPNTINTOPINHOLEONROB(RF, SF, SPK, SPD, L) projects 3D
%    Parallax angle parametrization points into a pin-hole camera mounted
%    on a robot, providing also the non-measurable depth. The input
%    parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       SPD: radial distortion parameters [K2 K4 K6 ...]'
%       L  : 3D parallax angle parametrization point. It can be in the
%            complete form:  [xm ym zm xa ya za pitch yaw parallax]'; or in
%            the reduced form: [xm ym zm pitch yaw]'. If in the reduced
%            form, the current frame will be considered as the anchor.
%    The output parameters are:
%       U  : 2D pixel [u v]'
%       S  : non-measurable depth
%
%    The function accepts a pap points matrix L = [L1 ... Ln] as input. In
%    this case, it returns a pixels matrix U = [U1 ... Un] and a depths
%    row-vector S = [S1 ... Sn].
%
%    [U,S,U_R,U_S,U_K,U_D,U_L] = ... gives also the jacobians of the
%    observation U wrt all input parameters. Note that this only works for
%    single points.
%
%    See also PINHOLE, TOFRAME, PROJEUCPNTINTOPINHOLEONROB.

%   Copyright 2015 Ellon Paiva @ LAAS-CNRS.

% Rf = updateFrame(Rf);
% Sf = updateFrame(Sf);

[xm, xa, py, par, completeForm] = splitPap( pap );
if ~completeForm
    error('Cannot project pap in reduced form to pinHole camera on robot.');
end

if nargout <= 2  % No Jacobians requested

    uvecMtoP = py2vec(py); % unit vector
    uvecMtoA = (xa - xm) / norm(xa - xm); % unit vector
    
    phi = acos( dot(uvecMtoP,uvecMtoA) );
    
    vecCtoP = sin(par + phi)*norm(xa - xm)*uvecMtoP - sin(par)*(Cf.t - xm);
    
    vecCtoPInCf = Cf.Rt*vecCtoP;
    
    u = pinHole(vecCtoPInCf,k,d);
    
    s = vecCtoPInCf(3);
    
else            % Jacobians requested
   
    if size(pap,2) == 1
        
        [uvecMtoP, UVECMTOP_py] = py2vec(py); % unit vector
        
        xaxm = xa - xm;
        XAXM_xa = eye(3);
        XAXM_xm = -eye(3);
        
        [uvecMtoA, UVECMTOA_xaxm] = normvec(xaxm); % unit vector

        phi = acos( dot(uvecMtoP,uvecMtoA) );
        PHI_uvecmtop = -1/(1 - dot(uvecMtoP,uvecMtoA)^2)^(1/2) * uvecMtoA';
        PHI_uvecmtoa = -1/(1 - dot(uvecMtoP,uvecMtoA)^2)^(1/2) * uvecMtoP';
        
        [normxaxm, NORMXAXM_xaxm] = vecnorm(xaxm);

        sinparphi = sin(par + phi);
        SINPARPHI_par = cos(par + phi);
        SINPARPHI_phi = cos(par + phi);
        
        vecCtoP = sinparphi*normxaxm*uvecMtoP - sin(par)*(Cf.t - xm);
        %TODO: Check the jacobians below using info on https://en.wikipedia.org/wiki/Matrix_calculus
        VECCTOP_xm  = kron(( (SINPARPHI_phi*PHI_uvecmtoa*UVECMTOA_xaxm*XAXM_xm)*normxaxm + sinparphi*(NORMXAXM_xaxm*XAXM_xm) ),uvecMtoP) + sin(par)*eye(3);
        VECCTOP_xa  = kron(( (SINPARPHI_phi*PHI_uvecmtoa*UVECMTOA_xaxm*XAXM_xa)*normxaxm + sinparphi*(NORMXAXM_xaxm*XAXM_xa) ),uvecMtoP);
        VECCTOP_py  = normxaxm*( uvecMtoP*(SINPARPHI_phi*PHI_uvecmtop*UVECMTOP_py) + sinparphi*(UVECMTOP_py) );
        VECCTOP_par = SINPARPHI_par*normxaxm*uvecMtoP - cos(par)*(Cf.t - xm);
        VECCTOP_cft = - sin(par)*eye(3);
        
        
        [vecCtoPInCf, VECCTOPINCF_cfq, VECCTOPINCF_vecctop] = Rtp(Cf.q, vecCtoP);

        [u, s, U_vecctopincf, U_k, U_d] = pinHole(vecCtoPInCf,k,d);

        % chain rule
        U_xm  = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_xm;
        U_xa  = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_xa;
        U_py  = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_py;
        U_par = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_par;
        U_pap = [U_xm U_xa U_py U_par];
        
        U_cft = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_cft;
        U_cfq = U_vecctopincf * VECCTOPINCF_cfq;
        U_cf = [U_cft U_cfq];
        
    else
        error('??? Jacobians not available for multiple PAP points.')

    end

end



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

