function [ba,BAam,BAqm,BAge] = abias(am,qm,gE)

% ABIAS  Accelerometer bias from sensed data
%   ABIAS(AM,QM,G) is the bias in the accelerometer when at standstill is
%   sensing AM accelerations. QM is the sensor attitude quaternion given
%   provided by external means (INS for example) and G is the gravity
%   vector in local ENU frame. The default for G is [0;0;-9.81] m/s^2.
%
%   [ba,BAam,BAqm,BAg) = ... returns all Jacobians

% OK jacobians

if nargin < 3
    gE = [0;0;-9.81];
end

[RtgE,RTGEqm,RTGEge] = Rtp(qm,gE);

ba = am + RtgE;

BAam = eye(3);
BAqm = RTGEqm;
BAge = RTGEge;
