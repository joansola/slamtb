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

