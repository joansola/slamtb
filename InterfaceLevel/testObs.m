function Obs = testObs(Obs, pos, COV)

% TESTOBS  Update OBS information to simulate a SLAM observation.
%   TESTOBS(OBS, POS, COV) updates .meas and .exp fields in OBS to simulate
%   a measurement at position POS with covariance COV. It also updates
%   flags .measured, .matched, .updated and .vis fields to control
%   displaying behavior.
%
%   This function is only for debugging purposes and can be modified to
%   suit the debugging needs. In particular, the three flags may be changed
%   to modify displaying behavior.

Obs.meas.y    = pos;
Obs.meas.R    = COV;

Obs.exp.e     = Obs.meas.y;
Obs.exp.E     = Obs.meas.R;

Obs.measured  = true;
Obs.matched   = true;
Obs.updated   = false;

Obs.vis       = true;
