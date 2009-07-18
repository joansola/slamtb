
function [idp_W, IDPWidps, IDPWrf, IDPWsf] = idpS2idpW(idp_S, Rf, Sf)

% IDPS2IDPW  Transform idp vector from "Sensor frame" to "World frame".
%   IDP_W = IDPS2IDPW(IDP_S, RF, SF) returns ths idp vector in world frame
%   from the idp vector in sensor frame (IDP_S), the Robot frame (RF) witch
%   support the sensor, and the Sensor frame (SF).
%
%   [IDP_W, IDPWIDPS, IDPWRF, IDPWSF] = IDPS2IDPW(IDP_S, RF, SF) the same
%   operation but return the jacobians wrt parameters.
%
%   See also FROMFRAME, PY2VEC, VEC2PY.
%


% Algorithm:
%
% idp_S = [0; 0; 0; pitch_sen; yaw_sen; rho_sen]
% idp_W = [x0, pitch, yaw, rho]'
% with :
%   x0 = camera position:
%         x0 = fromFrame(Rob(rob).frame,Sen(sen).frame.t)
%   py_sen = [pitch_sen; yaw_sen], angles in sensor Frame. So:
%   py = vec2py(R_rob*R_sen*py2vec(py_sen))
%         R_rob = Rob(rob).frame.R
%         R_sen = Sen(sen).frame.R
%   rho = rho_sen
%


if (nargout > 1)
    [x0, X0rf, X0sft] = fromFrame(Rf,Sf.t) ;
    [v, Vidps45]      = py2vec(idp_S(4:5)) ;
    v                 = Rf.R*Sf.R*v ;
    Vidps45           = Rf.R*Sf.R*Vidps45 ;
    [py,PYv]          = vec2py(v) ;

    idp_W = [x0 ; py ; idp_S(6)] ;

    IDPWx0   = [1 0 0 ; ...
        0 1 0 ; ...
        0 0 1 ; ...
        0 0 0 ; ...
        0 0 0 ; ...
        0 0 0 ] ;
    IDPWpy   = [0 0 ; ...
        0 0 ; ...
        0 0 ; ...
        1 0 ; ...
        0 1 ; ...
        0 0 ] ;
    IDPWidps6 =[0 ; ...
        0 ; ...
        0 ; ...
        0 ; ...
        0 ; ...
        1 ] ;
    IDPWidps123 = zeros(6,3) ;
    IDPWidps45  = IDPWpy*PYv*Vidps45 ;
    IDPWidps    = [IDPWidps123, IDPWidps45, IDPWidps6] ;
    IDPWrf      = IDPWx0*X0rf ;
    IDPWsft     = IDPWx0*X0sft ;
    IDPWsf      = [IDPWsft, zeros(6,4)] ;
else
    x0    = fromFrame(Rf,Sft) ;
    v     = py2vec(idp_S(4:5)) ;
    v     = Rf.R*Sf.R*v ;
    py    = vec2py(v) ;
    idp_W = [x0 ; py ; idp_S(6)] ;
end


return

%% jac

syms x0 y0 z0 p y r xr yr zr ar br cr dr xs ys zs as bs cc ds real
Rf.x  = [xr;yr;zr;ar;br;cr;dr];
Sf.x  = [xs;ys;zs;as;bs;cc;ds];
Rf    = updateFrame(Rf);
Sf    = updateFrame(Sf);
idp_S = [x0;y0;z0;p;y;r];

[idp_W, IDPWidps, IDPWrf, IDPWsf] = idpS2idpW(idp_S, Rf, Sf);

simplify(IDPWidps - jacobian(idp_W,idp_S))
simplify(IDPWrf   - jacobian(idp_W,Rf.x))
simplify(IDPWsf   - jacobian(idp_W,Sf.x))




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

