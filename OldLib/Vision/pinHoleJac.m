function [PHp,PHcal,PHdist] = pinHoleJac(p,cam)

% PINHOLEJAC Jacobians of PINHOLE function
%   PINHOLEJAC(P,CAM) gives the Jacobian wrt point position P
%
%   PINHOLEJAC(P,CAM) accepts radial distortion parameters
%   CAM.dist up to the fourth order: CAM.dist = [k2 k4 k6 k8].
%   See DISTORT for more information on the distortion model.
%
%   [PHP,PHCAL] = PINHOLE(...) gives also the Jacobian wrt the
%   calibration parameters CAM.cal.
%
%   [PHP,PHCAL,PHDIST] = PINHOLE(...) gives also the
%   Jacobian wrt the distortion parameters CAM.dist.
%
%   See also DISTORT, PROJECT, PIXELLISE, PINHOLE.

% (c) 2006 Joan Sola @ LAAS-CNRS

x  = p(1);
y  = p(2);
z  = p(3);

u0 = cam.cal(1);
v0 = cam.cal(2);
au = cam.cal(3);
av = cam.cal(4);

if ~isfield(cam,'dist') 
    % No distortion
    PHp = [au/z   0   -au*x/z^2
             0  av/z  -av*y/z^2];

    if nargout==2
        PHcal = [1 0 x/z  0
                 0 1  0  y/z];
    end

else
    % Distortion vector
    dist = cam.dist;
    dist(end+1:4) = 0; % fill with zeros up to length 4
    k1 = dist(1);
    k2 = dist(2);
    k3 = dist(3);
    k4 = dist(4);

    % metric projected pixel
    up   = project(p);
    up1  = up(1);
    up2  = up(2);
    r2   = (up1^2+up2^2);
    r4   = r2^2;
    r6   = r2*r4;
    r8   = r4^2;
    t0   = 1+k1*r2+k2*r4+k3*r6+k4*r8;
    t1   = (2*k1*up1+4*k2*r2*up1+6*k3*r4*up1+8*k4*r6*up1);
    t2   = (2*k1*up2+4*k2*r2*up2+6*k3*r4*up2+8*k4*r6*up2);
    Up_p = [    1/z,      0, -x/z^2
                  0,    1/z, -y/z^2];

    % metric distorted pixel
    rmax2 = (u0/au)^2 + (v0/av)^2;
    rmax  = sqrt(rmax2); % maximum radius in normalized coordinates

    ud    = distort(up,dist,rmax);
    ud1   = ud(1);
    ud2   = ud(2);
    Ud_up = [ t0+up1*t1,    up1*t2
                 up2*t1, t0+up2*t2];
    Ud_kd = [   up1*r2, up1*r4, up1*r6, up1*r8
                up2*r2, up2*r4, up2*r6, up2*r8];

    % Pixellic pixel
    Upx_ud = [ au,  0
                0, av];

    % Output
    PHp = Upx_ud * Ud_up * Up_p;

    % Extra outputs
    switch nargout
        case 2
            PHcal  = [   1,   0, ud1,   0
                         0,   1,   0, ud2];
        case 3
            PHcal  = [   1,   0, ud1,   0
                         0,   1,   0, ud2];
            PHdist = Upx_ud * Ud_kd;
    end

end

