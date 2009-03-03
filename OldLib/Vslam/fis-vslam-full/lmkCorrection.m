function Rob = lmkCorrection(Rob,Lmk)

% LMKCORRECTION  Landmark correction
%   ROB = LMKCORRECTION(ROB,LMK) performs an EKF correction
%   on global Map from previously computed landmark LMK parameters.
%   It also updates the robot ROB block.

global Map WDIM ODIM

% Innovations
Inn.z  = Lmk.z;
Inn.Z  = Lmk.Z;
Inn.iZ = Lmk.iZ;

pr = loc2range(Lmk.loc);

% Map correction
blockUpdateInn(Rob.r,pr,Lmk.Hr,Lmk.Hp,Inn,'symmet');

% quaternion normalization
qr  = WDIM+1:WDIM+ODIM; % quat. range
iqn = 1/norm(Map.X(qr));
Map.X(qr)   = Map.X(qr)*iqn;
Map.P(qr,:) = Map.P(qr,:)*iqn; % FIXME use good jacobians
Map.P(:,qr) = Map.P(:,qr)*iqn;

% Robot pose and matrices update
Rob.X = Map.X(Rob.r);
updateFrame(Rob);

