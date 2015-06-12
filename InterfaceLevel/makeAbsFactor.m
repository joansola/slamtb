function Fac = makeAbsFactor(Frm, Fac, factorRob)


Fac.used = true; % Factor is being used ?
%     Fac.fac = fac; % index in Fac array
Fac.id = newId; % Factor unique ID

Fac.type = 'absolute'; % {'motion','measurement','absolute'}
%     Fac.sen = []; % sen index
%     Fac.lmk = []; % lmk index
%     Fac.id1 = []; % id of block 1
%     Fac.id2 = []; % id of block 2

% Project into manifold, 7DoF --> 6DoF
[e, E_x] = qpose2epose(factorRob.state.x);
E = E_x * factorRob.state.P * E_x';

% Measurement is the straight data
Fac.meas.y = e;
Fac.meas.R = E;
Fac.meas.W = (E + 1e-10 * eye(numel(e) ) )^-1; % measurement information matrix

% Expectation has zero covariance -- and info is not defined
Fac.exp.e = Fac.meas.y; % expectation
Fac.exp.E = zeros(size(E)); % expectation cov
%     Fac.exp.W = Fac.meas.W; % expectation information matrix

% Error is zero at this stage, and takes covariance and info from measurement
Fac.err.z = zeros(size(e)); % error or innovation (we call it error because we are on graph SLAM)
Fac.err.Z = Fac.meas.R; % error cov matrix
Fac.err.W = Fac.meas.W; % error information matrix

% Jacobians are zero at this stage. Just make size correct.
Fac.err.E_node1 = zeros(6,factorRob.state.size); % Jac. of error wrt. node 1

% Cross link factor with frames
% Fac.frmId = Frm.id; % frame ids
Fac.frm = Frm.frm;

% Append factor ID to factors list.
Frm.factorIds = [Frm.factorIds Fac.id]; 
