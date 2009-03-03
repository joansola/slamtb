function [p,Pi,Pc,Pd] = idpPinHole(idp,cam,depth)

% IDPPINHOLE  Pin hole camera for IDP coded points
%   P = IDPPINHOLE(IDP,CAM) gives the pixel P resulting from projecting a
%   point represented by the Inverse Depth IDP into a camera CAM. 
%   CAM is a structure containing:
%       .cal: calibration parameters (required)
%       .dist: distortion parameters (optional)
%
%   P = IDPPINHOLE(IDP,CAM,DEPTH) with DEPTH~=0 adds the depth of the point
%   in camera frame as the third component of the output vector P.
%
%   [P,Pi,Pc,Pd] = IDPPINHOLE(...) returns the Jacobians wrt IDP, CAM.cal
%   and CAM.dist. NOTE: The Jacobians are always 2xN matrices, ignoring the
%   fact that P can be a 3-vector when DEPTH==1.
%
%   See also IDP2P to obtain information on the inverse depth
%   representation of IDP.

% (c) 2008 Joan Sola

cal = cam.cal;
if isfield(cam,'dist')
    dist = cam.dist;
else
    dist = [];
end

if nargout < 2

    pu =     idp2p(idp);
    pp =   project(pu);
    pd =   distort(pp,dist);
    p  = pixellise(pd,cal);

else % jacobians

    [pu,PUi]         =     idp2p(idp);
    [pp,PPpu]        =   project(pu);
    [pd,PDpp,PDdist] =   distort(pp,dist);
    [p,Ppd,Pc]       = pixellise(pd,cal);

    Pi = Ppd*PDpp*PPpu*PUi;
    Pd = Ppd*PDdist;

end

if depth
    p(3) = pu(3);
end