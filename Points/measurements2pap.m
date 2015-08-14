function pap = measurements2pap(maincampose, mainmeas, assocampose, assomeas, mk, mc, ak, ac)
%MEASUREMENTS2PAP Initialize a pap pnt from camera poses, measurements and camera
%parameters.

% use the same camera parameters for associated camera if only one set of
% parameters is supplied
if nargin < 7
    ak = mk;
    ac = mc;
end

% get direction vectors in camera frame
vecMtoPInCf = invPinHole(mainmeas,1,mk,mc);
vecAtoPInCf = invPinHole(assomeas,1,ak,ac);

% Rotate the vectors to match the global frame
vecMtoP = maincampose.R*vecMtoPInCf;
vecAtoP = assocampose.R*vecAtoPInCf;

% get pitch yaw angles from vector from main anchor
py = vec2py(vecMtoP);

% get parallax angle from the vectors from anchors to landmark
par = angleBetweenVectors(vecMtoP,vecAtoP);

% compose the pap pnt
pap(1:3,1) = maincampose.t;
pap(4:6,1) = assocampose.t;
pap(7:8,1) = py;
pap(9,1)   = par;

end

function angle = angleBetweenVectors(v1,v2)
% ANGLEBETWEENVECTORS Return the angle between two vectors
%
% ANGLE = ANGLEBETWEENVECTORS(V1,V2) returns the angle between V1 and V2.
% ANGLE has ranges from 0 to pi.

% TODO: which one is better: 0 <= par <= pi or -pi/2 <= par <= pi/2?
angle = acos( dot(v1,v2) / (norm(v1)*norm(v2)) );
end