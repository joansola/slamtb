function [ahm,AHM_f,AHM_ahmf] = fromFrameAhm(F,ahmf)

% FROMFRAMEAHM  Transforms AHM from local frame to global frame.
%   AHM = FROMFRAMEAHM(F,AHMF) transforms the Inverse Depth point IF from the
%   local frame F to the global frame. The frame F can be specified either
%   with a 7-vector F=[T;Q], where T is the translation vector and Q the
%   orientation quaternion, of via a structure containing at least the
%   fields F.t, F.q, F.R and F.Rt (translation, quaternion, rotation matrix
%   and its transpose).
%
%   [AHM,AHM_f,AHM_if] = FROMFRAMEAHM(...) returns the Jacobians wrt F and AHMF.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


xf  = ahmf(1:3,:);
mf  = ahmf(4:6,:);
sf  = ahmf(7,:);

[t,q,R,Rt] = splitFrame(F);

if nargout == 1

    x  = fromFrame(F,xf);
    m  = R*mf;

    ahm  = [x;m;sf];

else

    if size(ahmf,2) > 1
        error('Jacobians not available for multiple ahms')
    else

        [x, X_f, X_xf] = fromFrame(F,xf);
        [m,M_q,M_mf]   = Rp(q,mf);

        ahm    = [x;m;sf];

        AHM_f = [...
            X_f
            zeros(3,3) M_q
            zeros(1,7)];

        AHM_ahmf = [...
            X_xf          zeros(3,4)
            zeros(3,3) M_mf zeros(3,1)
            zeros(1,6)           1];

    end
end

return

%% jac

syms x y z a b c d X Y Z U V W R real
F   = [x;y;z;a;b;c;d];
ahmf = [X;Y;Z;U;V;W;R];

[ahm,AHM_f,AHM_ahmf] = fromFrameAhm(F,ahmf);

simplify(AHM_f  - jacobian(ahm,F))
simplify(AHM_ahmf - jacobian(ahm,ahmf))












