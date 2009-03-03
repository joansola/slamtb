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
blockUpdateInn(Rob.r,pr,Lmk.Hr,Lmk.Hp,Inn,'simple');

% quaternion normalization
qr  = WDIM+1:WDIM+ODIM; % quat. range
[Map.X(qr),Qq] = normvec(Map.X(qr));
Map.P(qr,:)    = Qq*Map.P(qr,:); 
Map.P(:,qr)    = Map.P(:,qr)*Qq';

% Robot pose and matrices update
Rob.X = Map.X(Rob.r);
updateFrame(Rob);

