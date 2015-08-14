function [u,s,U_rf,U_sf,U_k,U_d,U_minpap,U_mf,U_af] = ...
projPapPntWithAnchorsIntoPinHoleOnRob(Rf, Sf, k, d, minpap, Mf, Af)
% PROJPAPPNTWITHANCHORSINTOPINHOLEONROB Project Pap pnt from the anchors
% into pinhole on robot.
%    [U,S] = PROJPAPPNTWITHANCHORSINTOPINHOLEONROB(RF, SF, SPK, SPD, MINL)
%    projects 3D Parallax Angle Parametrizaton points into a pin-hole
%    camera mounted on a robot. It assumes the robot pose is the main
%    anchor frame, and thus the landmark is not fully observable, so it
%    provides also the non-measurable depth. The input parameters are:
%       RF   : robot frame (also the main anchor frame)
%       SF   : pin-hole sensor frame in robot
%       SPK  : pin-hole intrinsic parameters [u0 v0 au av]'
%       SPD  : radial distortion parameters [K2 K4 K6 ...]'
%       MINL : minimal representation of a 3D parallax angle point [pitch yaw par]'
%    The output parameters are:
%       U  : 2D pixel [u v]'
%       S  : non-measurable depth
%
%    U = PROJPAPPNTWITHANCHORSINTOPINHOLEONROB(..., MF) projects 3D
%    Parallax Angle Parametrizaton points into a pin-hole camera mounted on
%    a robot. It assumes the robot pose is the associated anchor frame,
%    thus the landmark is fully observable. The new input parameter is:
%       MF   : main anchor frame
%
%    U = PROJPAPPNTWITHANCHORSINTOPINHOLEONROB(..., AF) projects 3D
%    Parallax Angle Parametrizaton points into a pin-hole camera mounted on
%    a robot. It assumes the robot pose is a different frame from the
%    anchors. The new input parameter is:
%       AF   : associated anchor frame
%
%    [U,S,U_R,U_S,U_K,U_D,U_MINL,U_MF,U_AF] = ... gives also the jacobians
%    of the observation U wrt all input parameters.
%
%    See also PINHOLE, TOFRAME, PROJIDPPNTINTOPINHOLEONROB.

%   Copyright 2015 Ellon Paiva @ LAAS-CNRS.

% Rf = updateFrame(Rf);
% Sf = updateFrame(Sf);

% Error check on minimal pap 
if numel(minpap) > 3
    error('Pap point not in the minimal form.')
end

if nargout <= 2  % No Jacobians requested
    
    Cf = composeFrames(Rf,Sf);
    
    if nargin < 6
        % projection to main anchor frame
        py = minpap(1:2,1);
        idp = [Cf.t; py; 0.1];
        [u,s] = projIdpPntIntoPinHole(Cf, k, d, idp);
        
    else
        if nargin < 7
            % projection to associated anchor frame
            Af = Rf;
        end
        
        Mcf = composeFrames(Mf,Sf);
        Acf = composeFrames(Af,Sf);

        ma  = Mcf.t;
        aa  = Acf.t;
        py  = minpap(1:2,1);
        par = minpap(3,1);
        
        uvecMtoP = py2vec(py); % unit vector
        uvecMtoA = (aa - ma) / norm(aa - ma); % unit vector

        phi = acos( dot(uvecMtoP,uvecMtoA) );

        vecCtoP = sin(par + phi)*norm(aa - ma)*uvecMtoP - sin(par)*(Cf.t - ma);

        vecCtoPInCf = Cf.Rt*vecCtoP;

        u = pinHole(vecCtoPInCf,k,d);

        s = vecCtoPInCf(3);

    end

else            % Jacobians requested

    [Cf, CF_rf, CF_sf] = composeFrames(Rf,Sf);
    
    if nargin < 6
        % projection to main anchor frame
        py = minpap(1:2,1);
        idp = [Cf.t; py; 0.1];
        [u,s,U_cf,U_k,U_d,U_idp] = projIdpPntIntoPinHole(Cf, k, d, idp);
        U_sf = U_cf*CF_sf;
        U_rf = U_cf*CF_rf;
        U_mf = U_rf;
        U_af = [];
        % projection does not depend on parallax here
        U_minpap = [U_idp(:,4:5) zeros(2,1)];
    else
        if nargin < 7
            % projection to associated anchor frame
            Af = Rf;
        end
        
        [Mcf, MCF_mf, MCF_sf] = composeFrames(Mf,Sf);
        [Acf, ACF_af, ACF_sf] = composeFrames(Af,Sf);

        ma  = Mcf.t;
        aa  = Acf.t;
        py  = minpap(1:2,1);
        par = minpap(3,1);
        
        [uvecMtoP, UVECMTOP_py] = py2vec(py); % unit vector

        aama = aa - ma;
        AAMA_aa = eye(3);
        AAMA_ma = -eye(3);

        [uvecMtoA, UVECMTOA_aama] = normvec(aama); % unit vector

        phi = acos( dot(uvecMtoP,uvecMtoA) );
        PHI_uvecmtop = -1/(1 - dot(uvecMtoP,uvecMtoA)^2)^(1/2) * uvecMtoA';
        PHI_uvecmtoa = -1/(1 - dot(uvecMtoP,uvecMtoA)^2)^(1/2) * uvecMtoP';

        [normaama, NORMAAMA_aama] = vecnorm(aama);

        sinparphi = sin(par + phi);
        SINPARPHI_par = cos(par + phi);
        SINPARPHI_phi = cos(par + phi);

        vecCtoP = sinparphi*normaama*uvecMtoP - sin(par)*(Cf.t - ma);
        %TODO: Check the jacobians below using info on https://en.wikipedia.org/wiki/Matrix_calculus
        VECCTOP_ma  = kron(( (SINPARPHI_phi*PHI_uvecmtoa*UVECMTOA_aama*AAMA_ma)*normaama + sinparphi*(NORMAAMA_aama*AAMA_ma) ),uvecMtoP) + sin(par)*eye(3);
        VECCTOP_aa  = kron(( (SINPARPHI_phi*PHI_uvecmtoa*UVECMTOA_aama*AAMA_aa)*normaama + sinparphi*(NORMAAMA_aama*AAMA_aa) ),uvecMtoP);
        VECCTOP_py  = normaama*( uvecMtoP*(SINPARPHI_phi*PHI_uvecmtop*UVECMTOP_py) + sinparphi*(UVECMTOP_py) );
        VECCTOP_par = SINPARPHI_par*normaama*uvecMtoP - cos(par)*(Cf.t - ma);
        VECCTOP_cft = - sin(par)*eye(3);


        [vecCtoPInCf, VECCTOPINCF_cfq, VECCTOPINCF_vecctop] = Rtp(Cf.q, vecCtoP);

        [u, s, U_vecctopincf, U_k, U_d] = pinHole(vecCtoPInCf,k,d);

        % chain rule
        U_py  = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_py;
        U_par = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_par;
        U_minpap = [U_py U_par];
        
        U_ma  = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_ma;
        U_mcf = [U_ma zeros(2,4)];
        U_mf = U_mcf*MCF_mf;
        % WARNING: computation of U_sf is wrong below, but we're not using it.
        % TODO: compute U_sf properly
        U_sf = U_mcf*MCF_sf;

        if nargin < 7
            % associated anchor is the camera position, so given the
            % equation of vecCtoP above we need to add the jacobians
            VECCTOP_aa = VECCTOP_aa + VECCTOP_cft;
            U_aa  = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_aa;           
            U_cft = U_aa;
        else
            U_aa  = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_aa;           
            U_cft = U_vecctopincf * VECCTOPINCF_vecctop * VECCTOP_cft;
        end

        U_cfq = U_vecctopincf * VECCTOPINCF_cfq;
        U_cf = [U_cft U_cfq];
        U_rf = U_cf * CF_rf;
        
        U_acf = [U_aa zeros(2,4)];
        U_af = U_acf * ACF_af;
        % WARNING: computation of U_sf is wrong below, but we're not using it.
        % TODO: compute U_sf properly
%         U_sf = U_acf*ACF_sf;


    end

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

