function [gm1,GMgm,GMu] = gaussmarkovpredict(gm,u,dt,tau)

% GAUSSMARKOVPREDICT  Prediction step of a Gauss-Markov error model
%   [GM,Ggm,Gu] = GAUSSMARKOVPREDICT(GM,U,DT,TAU) preforms one discrete time step 
%   to GM following the Gauss-Markov model:
%
%       GM = phi*GM + U
%
%   where 
%       phi = exp(-DT/TAU) is the state transition parameter, 
%       DT  is the sampling time
%       TAU is the time constant of the process.
%
%   U can be given empty [] to account for white Gaussian noise.

if isempty(u)
    u = zeros(size(gm));
end

phi  = exp(-dt/tau);

gm1  = phi*gm + u;
GMgm = phi*eye(length(gm));
GMu  = eye(length(gm));
