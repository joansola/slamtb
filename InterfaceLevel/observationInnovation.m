function Obs = observationInnovation(Obs)

% OBSERVATIONINNOVATION  Observation innovation.
%   Obs = OBSERVATIONINNOVATION(Obs) updates the structure Obs.inn with the
%   innovation. The used fields are Obs.meas and Obs.exp.
%
%   See also INNOVATION, OBSERVEKNOWNLMKS.

[Obs.inn.z, Obs.inn.Z, Obs.inn.iZ, Obs.inn.MD2] = innovation(...
    Obs.meas.y, Obs.meas.R,...
    Obs.exp.e, Obs.exp.E);
