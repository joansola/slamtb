function [l,L_f,L_lf] = fromFrameIdpLin(F,lf)

% FROMFRAMEIDPLIN  Transforms IDP line from local frame to global frame.
%   I = FROMFRAMEIDPLIN(F,LF) transforms the Inverse Depth line LF from the
%   local frame F to the global frame. The frame F must be specified via a
%   structure containing at least the fields F.t, F.q, F.R and F.Rt
%   (translation, quaternion, rotation matrix and its transpose).
%
%   [I,L_f,L_lf] = FROMFRAMEIDPLIN(...) returns the Jacobians wrt F and IF.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout == 1
    [p1f,p2f] = idpLin2idpPnts(lf);

    p1 = fromFrameIdp(F,p1f);
    p2 = fromFrameIdp(F,p2f);

    l  = [p1;p2(4:6,:)];

else
    % idp parts
    xf  = lf(1:3);
    w1f = lf(4:5);
    r1  = lf(6);
    w2f = lf(7:8);
    r2  = lf(9);
    
    % dir. vectors
    [m1f, M1F_w1f] = py2vec(w1f); 
    [m2f, M2F_w2f] = py2vec(w2f); 
    
    % from frame
    [x, X_f, X_xf] = fromFrame(F,xf);
    [m1, M1_f, M1_m1f]   = fromFrameVec(F,m1f);
    [m2, M2_f, M2_m2f]   = fromFrameVec(F,m2f);

    % angle vectors
    [w1, W1_m1] = vec2py(m1);
    [w2, W2_m2] = vec2py(m2);
    
    % partial Jacobians
    W1_f   = W1_m1*M1_f;
    W2_f   = W2_m2*M2_f;
    W1_w1f = W1_m1*M1_m1f*M1F_w1f;
    W2_w2f = W2_m2*M2_m2f*M2F_w2f;
    R_f    = zeros(1,7);
    
    % new idp line
    l = [x;w1;r1;w2;r2];
    
    % Jacobians
    L_f  = [X_f;W1_f;R_f;W2_f;R_f];
    L_lf = [...
        X_xf        zeros(3)          zeros(3)
        zeros(2,3)  W1_w1f     [0;0]  zeros(2,3)
        0 0 0       0 0         1     0 0        0
        zeros(2,3)  zeros(2,3)        W2_w2f    [0;0]
        0 0 0       0 0         0     0 0        1    ] ;
    
end

return

%% jac

syms x y z a b c d X Y Z A1 B1 R1 A2 B2 R2 real
F.x = [x;y;z;a;b;c;d];
F   = updateFrame(F);
l_F = [X;Y;Z;A1;B1;R1;A2;B2;R2];

[l,L_f,L_lf] = fromFrameIdpLin(F,l_F);

simplify(L_f  - jacobian(l,F.x))
simplify(L_lf - jacobian(l,l_F))











