function [s, d, S_rf, S_sf, S_k, S_seg] = ...
    projSegLinIntoPinHoleOnRob(Rf, Sf, k, seg)

% PROJSEGLININTOPINHOLEONROB Project segment line into pinhole on robot.
%    [S,D] = PROJSEGLININTOPINHOLEONROB(RF, SF, SPK, SEG) projects 3D line
%    segments SEG into a pin-hole camera mounted on a robot, providing also
%    the non-measurable depth. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       SEG: 3D line segment, SEG = [E1;E2], with Ei a 3D point
%    The output parameters are:
%       S  : 2D segment [e1;e2]', with ei a 2D pixel
%       D  : non-measurable depths [d1;d2].
%
%    The function accepts a segments matrix SEG = [SEG1 ... SEGn] as input.
%    In this case, it returns a segments matrix S = [S1 ... Sn] and a
%    depths row-vector D = [D1 ... Dn].
%
%   [S, D, S_rf, S_sf, S_k, S_seg] = PROJSEGLININTOPINHOLEONROB(...)
%   returns the Jacobians wrt all input parameters.
%
%   See also TOFRAMESEGMENT, PINHOLESEGMENT, PROJEUCPNTINTOPINHOLEONROB.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



if nargout <= 2
    
    sr    = toFrameSegment(Rf,seg);
    ss    = toFrameSegment(Sf,sr);
    [s,d] = pinHoleSegment(k,ss);

else % we want Jacobians
    
    % partial values and Jacobians
    [sr, SR_rf, SR_seg] = toFrameSegment(Rf,seg);
    [ss, SS_sf, SS_sr]  = toFrameSegment(Sf,sr);
    [s, d, S_k, S_ss]   = pinHoleSegment(k,ss);
    
    % chain rule
    S_sr  = S_ss*SS_sr;
    S_sf  = S_ss*SS_sf;
    S_rf  = S_sr*SR_rf;
    S_seg = S_sr*SR_seg;

end








