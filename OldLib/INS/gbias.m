function [bg,BGwm,BGqm,BGwe] = gbias(wm,qm,wE)

% GBIAS  Gyrometer bias from sensed data
%   GBIAS(WM,QM,WE) is the bias in the accelerometer when at standstill is
%   sensing WM angular rate. QM is the sensor attitude quaternion 
%   provided by external means (INS for example) and WE is the Earth's
%   rotation spped vector in local ENU frame. 
%
%   [bg,BGwm,BGqm,BGwe) = ... returns all Jacobians

% OK jacobians 

[RtwE,RTWEqm,RTWEwe] = Rtp(qm,wE);

bg = wm - RtwE;

BGwm = eye(3);
BGqm = -RTWEqm;
BGwe = -RTWEwe;
