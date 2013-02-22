function [l,L_f,L_lf] = fromFrameAhmLin(F,lf)

% FROMFRAMEAHMLIN  Transforms AHM line from local frame to global frame.
%   I = FROMFRAMEAHMLIN(F,LF) transforms the Anchored homogeneous line LF from the
%   local frame F to the global frame. The frame F must be specified via a
%   structure containing at least the fields F.t, F.q, F.R and F.Rt
%   (translation, quaternion, rotation matrix and its transpose).
%
%   [I,L_f,L_lf] = FROMFRAMEAHMLIN(...) returns the Jacobians wrt F and IF.

%   Copyright 2009 Teresa Vidal.

if nargout == 1
    [p1f,p2f] = ahmLin2ahmPnts(lf);

    p1 = fromFrameAhm(F,p1f);
    p2 = fromFrameAhm(F,p2f);

    l  = [p1;p2(4:7,:)];

else
    [p1f,p2f,P1f_lf,P2f_lf] = ahmLin2ahmPnts(lf);

    [p1,P1_f,P1_p1f] = fromFrameAhm(F,p1f);
    [p2,P2_f,P2_p2f] = fromFrameAhm(F,p2f);

    l  = [p1;p2(4:7)];
    
    % Jacobians
    L_f   = [P1_f;P2_f(4:7,:)];
    P2_lf = P2_p2f*P2f_lf;
    L_lf  = [P1_p1f*P1f_lf;P2_lf(4:7,:)];

    
end

return

%% jac

syms x y z a b c d X Y Z A1 B1 C1 R1 A2 B2 C2 R2 real
F.x = [x;y;z;a;b;c;d];
F   = updateFrame(F);
l_F = [X;Y;Z;A1;B1;C1;R1;A2;B2;C2;R2];

[l,L_f,L_lf] = fromFrameAhmLin(F,l_F);

simplify(L_f  - jacobian(l,F.x))
simplify(L_lf - jacobian(l,l_F))











