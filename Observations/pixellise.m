function [pix,PIXu,PIXk] = pixellise(u,k)

% PIXELLISE  Metric to pixellic conversion
%   PIXELLISE(U,K) maps the projected point U to the pixels matrix defined
%   by the camera calibration parameters K = [u0 v0 au av]. It works with
%   sets of pixels if they are defined by a matrix U = [U1 U2 ... Un] ,
%   where Ui = [ui;vi]
%
%   [p,Pu,Pk] = PIXELLISE(...) returns the jacobians wrt U and K. This
%   only works for single pixels U=[u;v], not for sets of pixels.
%
%   See also PINHOLE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

u0 = k(1);
v0 = k(2);
au = k(3);
av = k(4);

pix = [...
    u0 + au*u(1,:)
    v0 + av*u(2,:)];

if nargout > 1 % jacobians
    PIXu = [...
        [ au,  0]
        [  0, av]];
    PIXk = [...
        [  1,  0, u(1),    0]
        [  0,  1,    0, u(2)]];
end

return

%% build jacobians

syms u1 u2 u0 v0 au av real

u = [u1;u2];
k = [u0 v0 au av]';

pix = pixellise(u,k);

PIXu = jacobian(pix,u)
PIXk = jacobian(pix,k)



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

