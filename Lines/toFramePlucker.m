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

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


% extract input vectors ai and bi
ai = Li(1:3);
bi = Li(4:6);

t = C.t;
q = C.q;

if nargout == 1
    
    % get it and Rt of inverse transform
    it = t2it(t,q);
    Rt = C.Rt;

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



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

