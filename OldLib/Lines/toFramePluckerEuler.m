function [L,Lt,Le,Lli] = toFramePluckerEuler(t,e,Li)

% TOFRAMEPLUCKEREULER  Transform plucker line to a given frame.
%   L = TOFRAMEPLUCKEREULER(T,E,Li) expresses in frame (T,E) the line Li
%   originally expressed in global frame. E is a vector of Euler angles.
%
%   The formula for transformation is
%
%       L = [ Rt       [it]_x*Rt ]
%           [ zeros(3)        Rt ] * Li
%
%   where 
%       Rt    = e2R(e)'
%      [it]_x = hat(it)
%       it    = te2it(t,e).
%
%   [L,Lt,Le,Lli] = TOFRAMEPLUCKER(...) returns the Jacobians wrt T, E
%   and Li. 
%
%   See also FROMFRAMEPLUCKER, TXP, HAT, CROSS, Q2R, Q2QC, T2IT.

%   (c) 2008 Joan Sola, LAAS-CNRS


% extract input vectors ai and bi
ai = Li(1:3);
bi = Li(4:6);

if nargout == 1
    
    % get it and Rt of inverse transform
    it = te2it(t,e);
    Rt = e2R(e)';

    % compute a and b
    b  = Rt*bi;
    a  = Rt*ai + hat(it)*b;

    % Build output
    L = [a;b];

else

    % get it and iq of inverse transform
    [it,ITt,ITe]     = te2it(t,e);

    % compute a and b
    [b,Be,Bbi]       = Etp(e,bi);
    [txb,TXBit,TXBb] = txp(it,b);
    [Ra,RAe,RAai]    = Etp(e,ai);
    
    a = Ra + txb;
    
    % Jacobians from the chain rule
    At  = TXBit*ITt;
    Ae  = RAe + TXBit*ITe + TXBb*Be;
    Aai = RAai;
    Abi = TXBb*Bbi;
    
    % Build outputs
    L   = [a;b];
    
    Lt  = [At;zeros(3)];
    Le  = [Ae;Be];
    Lli = [Aai Abi;zeros(3) Bbi];
    
end

return

%%

syms a b c x y z real
syms L1 L2 L3 L4 L5 L6 real

e = [a;b;c];
t = [x;y;z];
Li = [L1;L2;L3;L4;L5;L6];

[L,Lt,Le,Lli] = toFramePluckerEuler(t,e,Li);

simplify(Lt  - jacobian(L,t))
simplify(Le  - jacobian(L,e))
simplify(Lli - jacobian(L,Li))

