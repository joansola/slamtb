function prj = projectLine(prj,Cam,Line,innSpace)

% PROJECTLINE  Project Plucker line into normalized homogeneous line
%   PROJECTLINE(PRJ,CAM,LINE,INNSPACE) projects the line LINE into camera
%   CAM, and converts the resulting line to the space specified by
%   INNSPACE. It takes the structure PRJ and fills in the following fields:
%       .u expectation
%       .U
%       .dU determinant of U
%       .Hc Jacobian wrt CAM

global Map

% ranges
cr = Cam.r;
lr = Line.r;
rr = [cr lr];

% var and covariances
li = Map.X(lr);
P_c_li = Map.P(rr,rr);

% expectation and Jacobians
[l,L_c,L_k,L_li] = projectPlucker(Cam.X,Cam.cal,li);
L_c_li = [L_c L_li];
L = L_c_li * P_c_li * L_c_li';

% Innovation space
[u,U_l] = hm2inn(l,innSpace,prj);

% full Jacobians
U_c     = U_l*L_c;
U_k     = U_l*L_k;
U_li    = U_l*L_li;
U_c_li  = [U_c U_li];

% expectations covariance
U = U_c_li*P_c_li*U_c_li';

% Output structure
%prj.y
%prj.R = R;
prj.hm = l;
prj.HM = L;
prj.u = u;
prj.U = U;
prj.dU = det(U);
%prj.z
%prj.Z
prj.Hc = U_c;
prj.Hk = U_k;
prj.Hl = U_li;
prj.vis = true;
prj.matched = false;
prj.updated = false;
%prj.dispImg

