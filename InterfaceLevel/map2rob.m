function Rob = map2rob(Rob)
% MAP2ROB  Update Rob structure from the Map information.
%   ROB = MAP2ROB(ROB) updates the structure ROB to reflect the information
%   contained in the golbal map Map.
%
%   See also UPDATEFRAME.

global Map

% normalize quaternion - mean and cov
[Map.x(Rob.frame.r(4:7)), NQ_q] = normvec(Map.x(Rob.frame.r(4:7)),1);
Map.P(Rob.frame.r(4:7),Map.used) = NQ_q*Map.P(Rob.frame.r(4:7),Map.used);
Map.P(Map.used,Rob.frame.r(4:7)) = Map.P(Map.used,Rob.frame.r(4:7))*NQ_q';

% means
Rob.state.x = Map.x(Rob.state.r);
Rob.frame.x = Map.x(Rob.frame.r);
Rob.vel.x   = Map.x(Rob.vel.r);

Rob.frame   = updateFrame(Rob.frame);

% covariances
% Rob.state.P = Map.P(Rob.state.r,Rob.state.r);
% Rob.frame.P = Map.P(Rob.frame.r,Rob.frame.r);
% Rob.vel.P   = Map.P(Rob.vel.r,Rob.vel.r);

