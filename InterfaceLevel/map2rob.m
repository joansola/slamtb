function Rob = map2rob(Rob)
% MAP2ROB  Update Rob structure from the Map information.
%   ROB = MAP2ROB(ROB) updates the structure ROB to reflect the information
%   contained in the golbal map Map.
%
%   See also UPDATEFRAME.

global Map

% means
Rob.state.x = Map.x(Rob.state.r);
Rob.frame.x = Map.x(Rob.frame.r);
Rob.vel.x   = Map.x(Rob.vel.x);

Rob.frame   = updateFrame(Rob.frame);

% covariances
Rob.state.P = Map.P(Rob.state.r,Rob.state.r);
Rob.frame.P = Map.P(Rob.frame.r,Rob.frame.r);
Rob.vel.P   = Map.P(Rob.vel.x,Rob.vel.x);

