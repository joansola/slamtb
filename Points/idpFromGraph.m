function idp = idpFromGraph(Lmk,Sen,Frm,Fac)

% IDPFROMGRAPH(LMK,SEN,FRM,FAC) return the inverse depth point stored in
% the graph-SLAM. IDP is the inverse depth point composed by the anchor,
% which is recovered by the estimated anchor frame composed with the sensor
% frame, and the estimated direction angles and the estimated inverse
% depth.

% Copyright 2015- Ellon Paiva @ LAAS-CNRS

global Map;

% Get some indices
frm = Fac(Lmk.anchorFac).frames(1);
sen = Fac(Lmk.anchorFac).sen;
% Compose frame and sensor frame to get camera anchor pose
pose.x = vpose2qpose(Map.x(Frm(frm).state.r));
anchorpose = composeFrames(updateFrame(pose),Sen(sen).frame);

% Return the inverse depth point
% EP-WARNING: why Map.x(Lmk.state.r) == [0;0;0] at the begining?
idp = [anchorpose.x(1:3); Map.x(Lmk.state.r)];

end