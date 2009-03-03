function [pc,PCi,PCc] = idp2pc(idp,cam)

% IDP2PC  get camera referenced point from IDP representation
%   IDP2PC(IDP,CAM) expresses the IDP coded point as a 3D point in the
%   camera frame CAM. The conversion follows the method in the paper on IDP
%   by Civera etal. where this camera-referenced point is rho-proportional
%   to the true 3D point. (rho is the inverse depth itself). This
%   proportionality has no effect after the projection operation made by
%   the camera.
%
%   [pc,PCi,PCc] = IDP2PC(...) returns the Jacobians wrt IDP and CAM.X
%
%   See also UPDATEFRAME to obtain information about the camera frame
%   structure and IDP2P to obtain information on the inverse depth
%   representation of IDP.

% desglossar idp
x0 = idp(1:3);
py = idp(4:5);
r  = idp(6);

% desglossar cam
qc = cam.q;
tc = cam.t;

% vector director
[m,Mpy]  = py2vec(py);

% punt intermig
p1 = r*(x0-tc) + m;

if nargout < 2
    
    % punt en ref. camera
    pc = Rtp(qc,p1);
    
else % jacobians

    % punt en ref. camera
    [pc,PCqc,PCp1] = Rtp(qc,p1);

    % jac. del punt intermig p1
    P1x0 = r;
    P1m  = eye(3);
    P1tc = -r;
    P1r  = x0-tc;

    % jacobians parcials
    PCx0 = PCp1*P1x0;
    PCpy = PCp1*P1m*Mpy;
    PCr  = PCp1*P1r;

    PCtc = PCp1*P1tc;

    % jacobians finals
    PCc  = [PCtc PCqc];
    PCi  = [PCx0 PCpy PCr];
end

return

%% test jacobians

syms x y z pt yw ro real
syms xc yc zc ac bc cc dc real
idp = [x y z pt yw ro]';
cam.X = [xc yc zc ac bc cc dc]';
cam = updateFrame(cam);

[pc,PCi,PCc] = idp2pc(idp,cam);

EPCi = PCi - simple(jacobian(pc,idp))
EPCc = PCc - simple(jacobian(pc,cam.X))
