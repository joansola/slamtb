function [L,Lc,Lli] = fromFramePlucker(C,Li)

% FROMFRAMEPLUCKER  Transform plucker line from a given frame.
%   L = FROMFRAMEPLUCKER(C,Li) expresses in global frame the line Li
%   originally expressed in frame C=(t,q).
%
%   The formula for transformation is
%
%       L = [ R        [t]_x*R ]
%           [ zeros(3)       R ] * Li
%
%   where  
%       R    = q2R(q)
%      [t]_x = hat(t).
%
%   [L,Lc,Lli] = FROMFRAMEPLUCKER(...) returns the Jacobians wrt C
%   and Li. 
%
%   See also TOFRAMEPLUCKER, TXP, HAT, CROSS, Q2R.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


ai = Li(1:3);
bi = Li(4:6);

t = C.t;
q = C.q;

if nargout == 1

    R = C.R;

    b = R*bi;
    a = R*ai + hat(t)*b;

    L = [a;b];

else

    [b,Bq,Bbi]      = Rp(q,bi);
    [txb,TXBt,TXBb] = crossJ(t,b);
    [Ra,RAq,RAai]   = Rp(q,ai);
    
    a   = Ra + txb;
    
    At  = TXBt;
    Aq  = RAq + TXBb*Bq;
    Aai = RAai;
    Abi = TXBb*Bbi;

    L   = [a;b];
    
    Lc  = [At Aq;zeros(3) Bq];
    Lli = [Aai Abi;zeros(3) Bbi];
    
end

return

%% test jacobians

syms a b c d x y z real
syms L1 L2 L3 L4 L5 L6 real

q   = [a;b;c;d];
t   = [x;y;z];
C.x = [t;q];
C   = updateFrame(C);
Li  = [L1;L2;L3;L4;L5;L6];

[L,Lc,Lli] = fromFramePlucker(C,Li);

simplify(Lc  - jacobian(L,C.x))
simplify(Lli - jacobian(L,Li))


%% test inv. transform
Li2 = toFramePlucker(C,L);

EL = simplify(Li - Li2);

simplify(subs(EL,d,sqrt(1-a^2-b^2-c^2)))









