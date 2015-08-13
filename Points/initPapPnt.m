function pap = initPapPnt(CamM, MeasM, CamA, MeasA, kM, CorrM, kA, CorrA)
%INITPAPPNT Initialize a pap pnt from camera poses, measurements and camera
%parameters.

% use the same camera parameters for associated camera if only one set of
% parameters is supplied
if nargin < 7
    kA = kM;
    CorrA = CorrM;
end

% get direction vectors from measurements and camera parameters
vecMtoPInC = invPinHole(MeasM,1,kM,CorrM);
vecAtoPInC = invPinHole(MeasA,1,kA,CorrA);

% Rotate the vectors to match the global frame
vecMtoP = CamM.R*vecMtoPInC;
vecAtoP = CamA.R*vecAtoPInC;

% get pitch yaw angles from vector from main anchor
py = vec2py(vecMtoP);

% get parallax angle from the vectors from anchors to landmark
par = parallaxFromDirVec(vecMtoP,vecAtoP);

% compose the pap pnt
pap(1:3,1) = CamM.t;
pap(4:6,1) = CamA.t;
pap(7:8,1) = py;
pap(9,1)   = par;

end

function par = parallaxFromDirVec(vecMtoP,vecAtoP)

% TODO JS: Check quadrants. Consider vecsAngle().
par = acos( dot(vecMtoP,vecAtoP) / (norm(vecMtoP)*norm(vecAtoP)) );

end