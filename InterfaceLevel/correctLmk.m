function [Rob,Sen,Lmk,Obs] = correctLmk(Rob,Sen,Lmk,Obs)

%  CORRECTLMKS  Correct landmarks.
%    [ROB,SEN,LMK,OBS] = correctLmks(ROB,SEN,LMK,OBS) returns the
%    measurement update of robot and sensor based on correction of
%    subsisting maps. For each map, first we recuperate the previously
%    stored Jacobians and the covariances matrix of the innovation, and
%    then apply the correction equations to get the updated maps
%       ROB:  the robot
%       SEN:  the sensor
%       LMK:  the set of landmarks
%       OBS:  the observation structure for the sensor SEN
%
%    See also CORRECTKNOWNLMKS, PROJECTLMK.

%   (c) 2009 David Marquez @ LAAS-CNRS.

global Map

% get landmark range
lr = Lmk.state.r ;        % lmk range in Map

% Rob-Sen-Lmk range and Jacobian
if Sen.frameInMap
    rslr  = [Rob.frame.r ; Sen.frame.r ; lr]; % range of robot, sensor, and landmark
    H_rsl = [Obs.Jac.E_r Obs.Jac.E_s Obs.Jac.E_l];
    
else
    rslr  = [Rob.frame.r ; lr]; % range of robot and landmark
    H_rsl = [Obs.Jac.E_r Obs.Jac.E_l];
end

P_xrsl = Map.P(Map.used,rslr);

K      = P_xrsl*H_rsl'*Obs.inn.iZ;

Map.x(Map.used)          = Map.x(Map.used) + K*Obs.inn.z;
Map.P(Map.used,Map.used) = Map.P(Map.used,Map.used) - K*Obs.inn.Z*K';

Rob = map2rob(Rob);
Sen = map2sen(Sen);

Obs.updated = true;





