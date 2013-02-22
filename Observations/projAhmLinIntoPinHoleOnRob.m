function [s, d, S_rf, S_sf, S_k, S_l] = projAhmLinIntoPinHoleOnRob(Rf, Sf, Sk, l)

% PROJAHMLININTOPINHOLEONROB Project Ahm line into pinhole on robot.
%   [s, d] = PROJAHMLININTOPINHOLEONROB(Rf, Sf, Sk, l) projects the
%   inverse-depth line l into a pin/hole camera with intrinsic parameters
%   Sk mounted on a robot. The robot frame is Rf and the sensor frame in
%   the robot is Sf.
%
%   The results are a 2D segment S and a distances vector D.
%
%   [s, d, S_rf, S_sf, S_k, S_l] = (...) returns the Jacobians wrt all
%   input parameters.

%   Copyright 2009 Teresa Vidal.


if nargout <= 2
    
    sw = ahmLin2seg(l);
    s   = projSegLinIntoPinHoleOnRob(Rf, Sf, Sk, sw);
    d   = 1./l([6 9]);

else
    
    [sw, SW_l] = ahmLin2seg(l);
    [s, d, S_rf, S_sf, S_k, S_sw] = projSegLinIntoPinHoleOnRob(Rf, Sf, Sk, sw);
    S_l  = S_sw*SW_l;
    
end








