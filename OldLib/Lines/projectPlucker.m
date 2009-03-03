function [lo,LO_c,LO_k,LO_li] = projectPlucker(C,k,Li)

% PROJECTPLUCKER  Project Plucker line
%   PROJECTPLUCKER(C,K,Li)  projects the Plucker line Li into a camera with
%   intrinsic parameters K=[u0;v0;au;av] and at pose C=[t;q].
%
%   [lo,LO_c,LO_k,LO_li] = PROJECTPLUCKER(...) returns Jacobians wrt C, K and Li.

% (c) 2008 Joan Sola @ LAAS-CNRS

if nargout == 1

    L  = toFramePlucker(C,Li);

    lo = pinHolePlucker(k,L);
    
else
    
    [L,L_c,L_li] = toFramePlucker(C,Li);

    [lo,LO_k,LO_l]  = pinHolePlucker(k,L);

    LO_c  = LO_l*L_c;
    LO_li = LO_l*L_li;

end



return

%%

syms a b c d x y z real
syms L1 L2 L3 L4 L5 L6 real
syms u0 v0 au av real

t = [x;y;z];
q = [a;b;c;d];
C = [t;q];
k = [u0 v0 au av];
Li = [L1 L2 L3 L4 L5 L6]';

[lo,LO_c,LO_k,LO_li] = projectPlucker(C,k,Li);

simplify(LO_c - jacobian(lo,C))
simplify(LO_k - jacobian(lo,k))
simplify(LO_li - jacobian(lo,Li))


