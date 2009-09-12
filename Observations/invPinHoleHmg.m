function [p, P_k, P_uin, P_nob] = invPinHoleHmg(k,uin,nob)

% INVPINHOLEHMG Inverse pin-hole camera model for HMG.
%   P = INVPINHOLEHMG(K,U,NOB) gives the retroprojected HMG point P of a
%   pixel U at inverse-depth NOB, from a pin-hole camera with calibration
%   parameters K. Pixel U can be Euclidean or homogeneous.
%
%   [P, P_K, P_U, P_NOB] = ... returns the Jacobians wrt K, U and NOB.
%
%   See also INVINTRINSIC.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

iK = invIntrinsic(k);

if nargout == 1
    
    if numel(uin) == 2
        uh = euc2hmg(uin);
    else
        uh = uin;
    end

    p = [normvec(iK*uh);nob];

else % we want Jacobians
    
    if numel(uin) == 2
        [uh, UH_uin] = euc2hmg(uin);
    else
        uh = uin;
        UH_uin = eye(3);
    end

    [u0,v0,au,av] = split(k);
    [u,v,w] = split(uh);

    vh = iK*uh;
    VH_k = [...
        [        -1/au*w,              0, (-u+u0*w)/au^2,              0]
        [              0,        -1/av*w,              0, (-v+v0*w)/av^2]
        [              0,              0,              0,              0]];
    VH_uh = iK;
    
    [wh, WH_vh] = normvec(vh,1);

    p   = [wh;nob];
    P_wh = [eye(3);0 0 0];
    
    P_vh   = P_wh*WH_vh;
    P_k   = P_vh*VH_k;
    P_uin = P_vh*VH_uh*UH_uin;

    P_nob = [0;0;0;1];

%     if numel(u) == 2
%         Pu = Pu(:,1:2);
%     end
end

return

%% jac
syms u0 v0 au av u v w n real
k = [u0 v0 au av]';
uin = [u;v;w]; % try this Hmg. or the Euc. below
% uin = [u;v]; % this is Euc.

[p, P_k, P_uin, P_n] = invPinHoleHmg(k,uin,n);

simplify(P_k   - jacobian(p,k))
simplify(P_uin - jacobian(p,uin))
simplify(P_n   - jacobian(p,n))


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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

