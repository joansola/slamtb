function [L,Lc,Lli] = toFramePlucker(C,Li)

% TOFRAMEPLUCKER  Transform plucker line to a given frame.
%   L = TOFRAMEPLUCKER(C,Li) expresses in frame C=[t;q] the line Li
%   originally expressed in global frame.
%
%   The formula for transformation is
%
%       L = [ Rt       [it]_x*Rt ]
%           [ zeros(3)        Rt ] * Li
%
%   where 
%       Rt    = q2R(iq)
%      [it]_x = hat(it)
%       iq    = q2qc(q)
%       it    = t2it(t,q)
%       t     = C(1:3)
%       q     = C(4:7)
%
%   [L,Lc,Lli] = TOFRAMEPLUCKER(...) returns the Jacobians wrt C
%   and Li. 
%
%   See also FROMFRAMEPLUCKER, TXP, HAT, CROSS, Q2R, Q2QC, T2IT.

%   (c) 2008 Joan Sola, LAAS-CNRS


% extract input vectors ai and bi
ai = Li(1:3);
bi = Li(4:6);

t = C(1:3);
q = C(4:7);

if nargout == 1
    
    % get it and Rt of inverse transform
    it = t2it(t,q);
    Rt = q2R(q)';

    % compute a and b
    b  = Rt*bi;
    a  = Rt*ai + hat(it)*b;

    % Build output
    L = [a;b];

else

    % get it and iq of inverse transform
    [it,ITt,ITq]     = t2it(t,q);

    % compute a and b
    [b,Bq,Bbi]       = Rtp(q,bi);
    [txb,TXBit,TXBb] = crossJ(it,b);
    [Ra,RAq,RAai]    = Rtp(q,ai);
    
    a = Ra + txb;
    
    % Jacobians from the chain rule
    At  = TXBit*ITt;
    Aq  = RAq + TXBit*ITq + TXBb*Bq;
    Aai = RAai;
    Abi = TXBb*Bbi;
    
    % Build outputs
    L   = [a;b];
    
    Lc  = [At Aq;zeros(3) Bq];
    Lli = [Aai Abi;zeros(3) Bbi];
    
end

return

%%

syms a b c d x y z real
syms L1 L2 L3 L4 L5 L6 real

q = [a;b;c;d];
t = [x;y;z];
C = [t;q];
Li = [L1;L2;L3;L4;L5;L6];

[L,Lc,Lli] = toFramePlucker(C,Li);

simplify(Lc  - jacobian(L,C))
simplify(Lli - jacobian(L,Li))

