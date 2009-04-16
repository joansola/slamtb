function [Rob,Sen,Lmk,Obs] = correctLmk(Rob,Sen,Lmk,Obs)

% CORRECTLMK  Correct landmark.
% TODO: help

global Map

% get landmark range
lr = Lmk.state.r ;        % lmk range in Map

% Rob-Sen-Lmk range and Jacobian
if Sen.frameInMap
    rslr = [Rob.frame.r ; Sen.frame.r ; lr]; % range of robot, sensor, and landmark
    jac  = [Obs.Jac];
    Hrsl = [jac.E_r jac.E_s jac.E_l];
    
else
    rslr = [Rob.frame.r ; lr]; % range of robot and landmark
    jac  = [Obs.Jac];
    Hrsl = [jac.E_r jac.E_l];
end

Pxrsl = Map.P(Map.used,rslr);

K     = Pxrsl*Hrsl'*Obs.inn.iZ;

Map.x(Map.used)          = Map.x(Map.used) + K*Obs.inn.z;
Map.P(Map.used,Map.used) = Map.P(Map.used,Map.used) - K*Obs.inn.Z*K';

Rob = map2rob(Rob);
Sen = map2sen(Sen);

Obs.updated = true;

% Update Obs and Lmk structures.




