function [res, err_max] = computeResidual(Rob,Sen,Lmk,Obs,Frm,Fac)

% COMPUTERESIDUAL Compute the residual.
%   COMPUTERESIDUAL(Rob,Sen,Lmk,Obs,Frm,Fac) gets the residual of all
%   factors in structure array Fac given all the states in trajectory
%   frames Frm, all landmarks Lmk, and the measurement models and
%   parameters derived from the robot Rob and sensor Sen.
%
%   The residual is the sum of all Mahalanobis distances squared of all
%   factors.
%
%   [res, err_max] = COMPUTERESIDUAL(...) returns also the maximum of the
%   squared mahalanobis error of all factors.
%
%   See also COMPUTEERROR, SOLVEGRAPHCHOLESKY.

% Copyright 2015-     Joan Sola @ IRI-UPC-CSIC.


res = 0;
err_max = 0;

for fac = [Fac([Fac.used]).fac]
    
    rob = Fac(fac).rob;
    sen = Fac(fac).sen;
    lmk = Fac(fac).lmk;
    frames = Fac(fac).frames;
    
    % Compute factor error, and info mat
    [Fac(fac), e, W] = computeError(Rob(rob),Sen(sen),Lmk(lmk),Obs(sen,lmk),Frm(frames),Fac(fac));

    err_maha = e' * W * e;
    
    if err_maha > err_max
        err_max = err_maha;
    end
    
    res = res + err_maha;
    
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

