function [L,L_f,L_lf] = fromFrameAPlucker(F,Lf)

% FROMFRAMEAPLUCKER  Anchored Plucker fromFrame transform.
%   FROMFRAMEAPLUCKER(F,Lf) transforms the anchored Plucker line from frame
%   F to the global frame.
%
%   The anchored Plucker line is defined by L = [x; n; v], where
%       x  : is the anchor, a 3-point
%       n  : is the 3-normal to the plane containing the line and the anchor
%       v  : is a director 3-vector of the line
%
%   [L,L_f,L_lf] = FROMFRAMEAPLUCKER(F,Lf) returns the Jacobians wrt F and
%   Lf.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

xf = Lf(1:3);
nf = Lf(4:6);
vf = Lf(7:9);

t = F.t;
q = F.q;

if nargout == 1
    
    R = F.R;
    x = R*xf + t;
    n = R*nf;
    v = R*vf;
    L = [x;n;v];
    
else
    
    [x,X_f,X_xf] = fromFrame(F,xf);
    [n,N_q,N_nf] = Rp(q,nf);
    [v,V_q,V_vf] = Rp(q,vf);
    Z33 = zeros(3);
    
    L = [x;n;v];
    
    L_f = [...
        X_f
        Z33 N_q
        Z33 V_q];
    
    L_lf = [...
        X_xf Z33  Z33
        Z33  N_nf Z33
        Z33  Z33  V_vf];
    
end

return

%% jac

syms t1 t2 t3 x1 x2 x3 a b c d n1 n2 n3 v1 v2 v3 real

F = [t1;t2;t3;a;b;c;d];
Lf = [x1;x2;x3;n1;n2;n3;v1;v2;v3];

[L,L_f,L_lf] = fromFrameAPlucker(F,Lf);

simplify(L    - fromFrameAPlucker(F,Lf))
simplify(L_f  - jacobian(L,F))
simplify(L_lf - jacobian(L,Lf))









