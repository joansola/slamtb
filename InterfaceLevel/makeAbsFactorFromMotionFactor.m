function [Frm, Fac] = makeAbsFactorFromMotionFactor(Frm, Fac)

Fac.type = 'absolute'; 
Fac.frames = Frm.frm;

% Ranges
Fac.state.r1 = Frm.state.r;
Fac.state.r2 = [];

% Measurement is the straight data
Fac.meas.y = Frm.state.x;

% Expectation has zero covariance -- and info is not defined
Fac.exp.e = Fac.meas.y; % expectation
