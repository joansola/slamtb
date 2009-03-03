function [Gw,Gs,Gcal,Gundist] = invPinHoleJac(pix,s,cam)

% INVPINHOLEJAC Jacobians of Inverse Pin Hole Camera function.
%   [Gw,Gs] = INVPINHOLEJAC(PIX,S) returns the Jacobians
%   of INVPINHOLE wrt. pixel and range.
%   Default calibration parameters are:
%     u0 = 0
%     v0 = 0
%     au = 1
%     av = 1
%
%   [Gw,Gs] = INVPINHOLEJAC(PIX,S,CAM) allows the specification
%   of the calibration prameters of the camera:
%     CAM.cal = [u0 v0 au av]'
%
%   [Gw,Gs] = INVPINHOLEJAC(PIX,S,CAM) also allows the
%   specification of the inverse distortion prameters of the
%   camera (see DISTORT and UNDISTORT for details):
%     CAM.undist = [k2 k4 k6 ...]
%
%   [Gw,Gs,Gcal] = INVPINHOLEJAC(PIX,S,CAM) returns also the
%   jacobian wrt the calibration parameters CAM.cal.
%
%   [Gw,Gs,Gcal,Gundist] = INVPINHOLEJAC(...) returns also the
%   jacobian wrt the undistortion parameters CAM.undist.
%
%   See also PINHOLE, INVPINHOLE, PINHOLEJAC

u = pix(1);
v = pix(2);

if nargin == 2
    cam.cal = [0 0 1 1]';
end

u0 = cam.cal(1);
v0 = cam.cal(2);
au = cam.cal(3);
av = cam.cal(4);

if ~isfield(cam,'undist')
        Gw = s*[1/au  0
                 0   1/av
                 0    0  ];

        Gs = pix2dir(pix,cam.cal);

        if nargout == 3
            Gcal = s*[-1/au   0   -(u-u0)/au^2        0
                        0   -1/av        0     -(v-v0)/av^2
                        0     0          0            0 ];
        end

else
        % Undistort vector
        undist = cam.undist;
        undist(end+1:4) = 0; % fill with zeros up to length 4
        k1  = undist(1);
        k2  = undist(2);
        k3  = undist(3);
        k4  = undist(4);

        % metric distorted pixel
        ud   = depixellise(pix,cam.cal);
        ud1  = ud(1);
        ud2  = ud(2);

        Ud_u = [ 1/au,    0
                    0, 1/av];

        % metric undistorted pixel
        up  = undistort(ud,undist);
        up1 = up(1);
        up2 = up(2);
        r2  = (ud1^2+ud2^2);
        r4  = r2^2;
        r6  = r2*r4;
        r8  = r4*r4;
        t0  = 1+k1*r2+k2*r4+k3*r6+k4*r8;
        t1  = (2*k1*ud1+4*k2*r2*ud1+6*k3*r4*ud1+8*k4*r6*ud1);
        t2  = (2*k1*ud2+4*k2*r2*ud2+6*k3*r4*ud2+8*k4*r6*ud2);
        
        Up_ud = [ t0+ud1*t1,    ud1*t2
                     ud2*t1, t0+ud2*t2];

        % 3D point
        P_up = [ s, 0
                 0, s
                 0, 0];
        P_s = [ up1
                up2
                  1];

        % Output
        Gw  = P_up * Up_ud * Ud_u;
        Gs  = P_s;

        % Extra outputs
        if nargout >= 3
            Ud_cal = [-1/au,     0, -(u-u0)/au^2,            0
                          0, -1/av,            0, -(v-v0)/av^2];
            Gcal = P_up * Up_ud * Ud_cal;
        
            if nargout >=4
                Up_kd = [ ud1*r2, ud1*r4, ud1*r6, ud1*r8
                          ud2*r2, ud2*r4, ud2*r6, ud2*r8];
                Gundist = P_up * Up_kd;
            end
        end

end
