function Fac = makeMotionFactor(Frm1, Frm2, Fac, RobMotion)


Fac.used = true; % Factor is being used ?
%     Fac.fac = fac; % index in Fac array
%     Fac.id = []; % Factor unique ID

Fac.type = 'motion'; % {'motion','measurement','absolute'}
Fac.frmId = [Frm1.id Frm2.id]; % frame ids
%     Fac.sen = []; % sen index
%     Fac.lmk = []; % lmk index
%     Fac.id1 = []; % id of block 1
%     Fac.id2 = []; % id of block 2

Fac.meas.y = RobMotion.state.x;
Fac.meas.R = RobMotion.state.P;
Fac.meas.W = 1/RobMotion.state.P; % measurement information matrix

Fac.exp.e = Fac.meas.y; % expectation
Fac.exp.E = zeros(size(con.U)); % expectation cov
%     Fac.exp.W = Fac.meas.W; % expectation information matrix

Fac.err.z = zeros(size(con.u)); % error or innovation (we call it error because we are on graph SLAM)
Fac.err.Z = Fac.meas.R; % error cov matrix
Fac.err.W = Fac.meas.W; % error information matrix

Fac.err.E_node1 = zeros(7,length(con.u)); % Jac. of error wrt. node 1
Fac.err.E_node2 = zeros(7,length(con.u)); % Jac. of error wrt. node 2

