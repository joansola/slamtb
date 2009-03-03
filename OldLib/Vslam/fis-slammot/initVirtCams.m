% TEST virtual cameras: cameras at nominal extrinsic params

vCam = Cam;
erc = deg2rad(camEuDeg);
Rrc = e2R(erc);
Rcs = flu2rdf;
Rrs = Rrc*Rcs;
qrs = R2q(Rrs);
vCam(2).X(4:7) = qrs;
vCam(1) = updateFrame(vCam(1));
vCam(2) = updateFrame(vCam(2));
