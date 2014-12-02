function [u, s, U_r, U_s, U_k, U_d, U_l] = ...
    projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l)

% PROJEUCPNTINTOPINHOLEONROB Project Euc pnt into pinhole on robot.
%    [U,S] = PROJEUCPNTINTOPINHOLEONROB(RF, SF, SPK, SPD, L) projects 3D
%    Euclidean points into a pin-hole camera mounted on a robot, providing
%    also the non-measurable depth. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       SPD: radial distortion parameters [K2 K4 K6 ...]'
%       L  : 3D point [x y z]'
%    The output parameters are:
%       U  : 2D pixel [u v]'
%       S  : non-measurable depth
%
%    The function accepts a points matrix L = [L1 ... Ln] as input.
%    In this case, it returns a pixels matrix U = [U1 ... Un] and a depths
%    row-vector S = [S1 ... Sn].
%
%    [U,S,U_R,U_S,U_K,U_D,U_L] = ... gives also the jacobians of the
%    observation U wrt all input parameters. Note that this only works for
%    single points.
%
%    See also PINHOLE, TOFRAME, PROJIDPPNTINTOPINHOLEONROB.

%   Copyright 2009 David Marquez @ LAAS-CNRS.

if nargout <= 2 % only pixel
    
    lr    = toFrame(Rf,l);
    ls    = toFrame(Sf,lr);
    
    [u,s] = pinHole(ls,Spk,Spd);
    
else % Jacobians
    
    if size(l,2) == 1  % single point
        
        % Same functions with Jacobians
        [lr, LR_r, LR_l]   = toFrame(Rf,l);
        [ls, LS_s, LS_lr]  = toFrame(Sf,lr);
        [u,s,U_ls,U_k,U_d] = pinHole(ls,Spk,Spd);
        
        % The chain rule for Jacobians
        U_lr = U_ls*LS_lr;
        U_r  = U_lr*LR_r;
        U_s  = U_ls*LS_s;
        U_l  = U_lr*LR_l;
        
    else
        error('??? Jacobians not available for multiple points.')
        
    end
    
end
return

%% test Jacobians - WARNING! IT TAKES AGES TO COMPUTE !!
syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd u0 v0 au av d2 d4 d6 lx ly lz real

Rf.x=[rx;ry;rz;ra;rb;rc;rd];
Sf.x=[sx;sy;sz;sa;sb;sc;sd] ;

Rf = updateFrame(Rf);
Sf = updateFrame(Sf);
Spk = [u0;v0;au;av];
Spd = [d2;d4;d6];
l = [lx;ly;lz];

[u,s,U_r,U_s,U_k,U_d,U_l] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l);


simplify(U_r - jacobian(u,Rf.x))
simplify(U_s - jacobian(u,Sf.x))
simplify(U_k - jacobian(u,Spk))
simplify(U_d - jacobian(u,Spd))
simplify(U_l - jacobian(u,l))



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

