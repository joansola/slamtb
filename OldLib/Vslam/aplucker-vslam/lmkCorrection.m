function Cam = lmkCorrection(Cam,Lmk,Obs)

% LMKCORRECTION  Landmark correction.
%   CAM = LMKCORRECTION(CAM,LMK,OBS) performs an EKF correction on global
%   Map from previously computed landmark LMK parameters. It also updates
%   the camera CAM.
%
%   WARNING Proper quaternion normalization on CAM structure updates must
%   be performed after this funciton.
%
%   See also NORMQUATROB.

global Map

cr  = Cam.r;
lr  = Lmk.r;
H_c = Obs.Hc;
H_l = Obs.Hl;

% Innovations
Inn.z = Obs.z;
Inn.Z = Obs.Z;
Inn.iZ = Obs.iZ;

% Map correction
blockUpdateInn(cr,lr,H_c,H_l,Inn,'simple');

% Normalize quaternion
cqr = cr(4:7);
cq  = Map.X(cqr);
[ucq,UCQ_cq] = hm2uhm(cq);

% Update map w/ normalized quat
mr  = find(Map.used);
Map.X(cqr)    = ucq;
Map.P(mr,cqr) = Map.P(mr,cqr)*UCQ_cq';
Map.P(cqr,mr) = UCQ_cq*Map.P(cqr,mr);

% Update camera struct
Cam.X = Map.X(cr);
Cam = updateFrame(Cam);
