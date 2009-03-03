% INITOBS  Initialize observations

global BDIM

% OBSERVATIONS
Obs.y = zeros(BDIM,1);
pixNoise = .5 * ones(BDIM,1); % observation noise in pixels
Obs.R = diag(pixNoise.^2);

