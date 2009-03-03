function [L,Lt,Le,Lli] = fromFramePluckerEuler(t,e,Li)

% FROMFRAMEPLUCKEREULER  Transform plucker line from a given frame.
%   L = FROMFRAMEPLUCKEREULER(T,E,Li) expresses in global frame the line Li
%   originally expressed in frame (T,E). E is the vector of Euler angles.
%
%   The formula for transformation is
%
%       L = [ R        [t]_x*R ]
%           [ zeros(3)       R ] * Li
%
%   where  
%       R    = e2R(e)
%      [t]_x = hat(t).
%
%   [L,Lt,Le,Lli] = FROMFRAMEPLUCKEREULER(...) returns the Jacobians wrt T, E
%   and Li. 
%
%   See also TOFRAMEPLUCKER, TXP, HAT, CROSS, E2R.

%   (c) 2008 Joan Sola, LAAS-CNRS


ai = Li(1:3);
bi = Li(4:6);

if nargout == 1

    R = e2R(e);

    b = R*bi;
    a = R*ai + hat(t)*b;

    L = [a;b];

else

    [b,Be,Bbi]      = Ep(e,bi);
    [txb,TXBt,TXBb] = crossJ(t,b);
    [Ra,RAe,RAai]   = Ep(e,ai);
    
    a   = Ra + txb;
    
    At  = TXBt;
    Ae  = RAe + TXBb*Be;
    Aai = RAai;
    Abi = TXBb*Bbi;

    L   = [a;b];
    
    Lt  = [At;zeros(3)];
    Le  = [Ae;Be];
    Lli = [Aai Abi;zeros(3) Bbi];
    
end

return

%% test jacobians

syms a b c d x y z real
syms L1 L2 L3 L4 L5 L6 real

e = [a;b;c];
t = [x;y;z];
Li = [L1;L2;L3;L4;L5;L6];

[L,Lt,Le,Lli] = fromFramePluckerEuler(t,e,Li);

simplify(Lt  - jacobian(L,t))
simplify(Le  - jacobian(L,e))
simplify(Lli - jacobian(L,Li))


%% test inv. transform
Li2 = toFramePluckerEuler(t,e,L);

EL = simplify(Li - Li2);

