%%
% some constants
bigeps = eps*1e6;

% IMU noises
nax   = 0.1; % 0.09;
nay   = 0.3; % 0.30;
naz   = 0.1; % 0.11;
na    = [nax nay naz]';
Na    = diag(na.^2);
ngx   = 0.0001;%0.0095;
ngy   = 0.0001;%0.0012;
ngz   = 0.0001;%0.0070;
ng    = [ngx ngy ngz]';
Ng    = diag(ng.^2);
rba   = 0;      % Gauss-Markov white noise.
tauba = 1e300;   % Gauss-Markov time constant
rbg   = 0;      % Gauss-Markov white noise.
taubg = 1e300;   % Gauss-Markov time constant

% Perturbations for simulation
ra   = 0;      % Gauss-Markov white noise.
taua = 15;     % Gauss-Markov time constant
rw   = 0;      % Gauss-Markov white noise.
tauw = 15;     % Gauss-Markov time constant

% VO noises
npvo  = 0.01;        % position increment errors
Npvo  = diag([npvo npvo npvo].^2);
novo  = deg2rad(1);   % orientation increment errors - enter degrees
Novo  = diag([novo novo novo].^2);
nvo   = [npvo npvo npvo novo novo novo]';
Nvo   = diag(nvo.^2);

