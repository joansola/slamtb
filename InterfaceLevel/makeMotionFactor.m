function Fac = makeMotionFactor(Frm1, Frm2, Fac, factorRob)


Fac.used = true; % Factor is being used ?
%     Fac.fac = fac; % index in Fac array
%     Fac.id = []; % Factor unique ID

Fac.type = 'motion'; % {'motion','measurement','absolute'}
Fac.frmId = [Frm1.id Frm2.id]; % frame ids
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
Fac.meas.W = E^-1; % measurement information matrix

% Expectation has zero covariance -- and info in not defined
Fac.exp.e = Fac.meas.y; % expectation
Fac.exp.E = zeros(size(E)); % expectation cov
%     Fac.exp.W = Fac.meas.W; % expectation information matrix

% Error is zero at this stage, and takes covariance and info from measurement
Fac.err.z = zeros(size(e)); % error or innovation (we call it error because we are on graph SLAM)
Fac.err.Z = Fac.meas.R; % error cov matrix
Fac.err.W = Fac.meas.W; % error information matrix

% Jacobians are zero at this stage. Just make size correct.
Fac.err.E_node1 = zeros(6,length(con.u)); % Jac. of error wrt. node 1
Fac.err.E_node2 = zeros(6,length(con.u)); % Jac. of error wrt. node 2

