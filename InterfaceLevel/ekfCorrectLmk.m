function [Rob,Sen,Lmk,Obs] = ekfCorrectLmk(Rob,Sen,Lmk,Obs)

%  EKFCORRECTLMK  Correct landmarks.
%    [ROB,SEN,LMK,OBS] = EKFCORRECTLMK(ROB,SEN,LMK,OBS) returns the
%    measurement update of robot and sensor based on EKF correction of
%    subsisting maps. For each map, first we recuperate the previously
%    stored Jacobians and the covariances matrix of the innovation, and
%    then apply the correction equations to get the updated maps
%       ROB:  the robot
%       SEN:  the sensor
%       LMK:  the set of landmarks
%       OBS:  the observation structure for the sensor SEN
%
%    See also CORRECTKNOWNLMKS, PROJECTLMK.

%   Copyright 2009 David Marquez @ LAAS-CNRS.

% get landmark range
lr = Lmk.state.r ;        % lmk range in Map

% Rob-Sen-Lmk range and Jacobian of innovation wrt active states.
if Sen.frameInMap
    rslr  = [Rob.frame.r ; Sen.frame.r ; lr]; % range of robot, sensor, and landmark
    Z_rsl = [Obs.Jac.Z_r Obs.Jac.Z_s Obs.Jac.Z_l];
    
else
    rslr  = [Rob.frame.r ; lr]; % range of robot and landmark
    Z_rsl = [Obs.Jac.Z_r Obs.Jac.Z_l];
end

% correct map. See that Jac of innovation is changed sign, as corresponds
% to the jacobian Z_x of z=y-h(x) wrt x in comparison of the Jacobian
% H_x of y=h(x) wrt x: it happens that H_x = -Z_x.
correctBlockEkf(rslr,-Z_rsl,Obs.inn);

% % Rob and Sen synchronized with Map
% Rob = map2rob(Rob);
% Sen = map2sen(Sen);










