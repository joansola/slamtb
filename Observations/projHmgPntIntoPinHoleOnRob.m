function [u, s, U_r, U_s, U_k, U_d, U_l] = ...
    projHmgPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l)


% PROJHMGPNTINTOPINHOLEONROB Project Hmg pnt into pinhole on robot.
%    [U,S] = PROJHMGPNTINTOPINHOLEONROB(RF, SF, SPK, SPD, P) projects 3D
%    homogeneous points into a pin-hole camera mounted on a robot, providing
%    also the non-measurable depth. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       SPD: radial distortion parameters [K2 K4 K6 ...]'
%       P  : 3D point [x y z]'
%    The output parameters are:
%       U  : 2D pixel [u v]'
%       S  : non-measurable depth
%
%    The function accepts a points matrix P = [P1 ... Pn] as input.
%    In this case, it returns a pixels matrix U = [U1 ... Un] and a depths
%    row-vector S = [S1 ... Sn].
%
%    [U,S,U_R,U_S,U_K,U_D,U_P] = ... gives also the jacobians of the
%    observation U wrt all input parameters. Note that this only works for
%    single points.
%
%    See also PINHOLE, TOFRAME, PROJIDPPNTINTOPINHOLEONROB.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout <= 2 % only pixel
    
    % landmark position in euclidian space:
    leucl = hmg2euc(l) ;
    
    % projection in euclidian space
    [u,s] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, leucl) ;
        
else % Jacobians
    
    % landmark position in euclidian space:
    [leucl, LEUCLl] = hmg2euc(l) ;
    
    if size(l,2) == 1  % single point
        
        % projection in euclidian space
        [u, s, U_r, U_s, U_k, U_d, U_leucl] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, leucl) ;
        
        % jacobian return in Hmg space
        U_l = U_leucl*LEUCLl ;
        
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

