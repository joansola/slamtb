function [I, I_f, I_g] = frameIncrement(F, G)

% FRAMEINCREMENT  Frame increment
%   I = FRAMEINCREMENT(F,G) is the incremental frame going from F to G,
%   that is, the expression of frame G expressed in frame F.
%
%   If both frames F and G are structures as defined in FRAME, then so is I.
%   If both frames F and G are 7-vectors, then so is I.
%   Otherwise an error is issued.
%
%   [I, I_f, I_g] returns the Jacobians of I.x wrt. F.x and G.x.
%
%   See also FRAME, COMPOSEFRAMES, UPDATEFRAME.

if isstruct(F) && isstruct(G)
    
    [iF, IF_f] = invertFrame(F);
    [I, I_if, I_g] = composeFrames(iF,G);
    
    I_f = I_if * IF_f;
    
elseif isvector(F) && isvector(G)

    if length(F) == 7 && length(G) == 7
        
        [pi, PI_f, PI_pg] = toFrame(F, G(1:3));
        [qcf, QCF_qf] = q2qc(F(4:7));
        [qi, QI_qcf, QI_qg] = qProd(qcf,G(4:7));
        
        I(1:3,1) = pi;
        I(4:7,1) = qi;
        
        I_f(1:3,1:7) = PI_f;
        I_f(4:7,4:7) = QI_qcf * QCF_qf;
        I_g(1:3,1:3) = PI_pg;
        I_g(4:7,4:7) = QI_qg;
        
    else
        error('??? One or both frame vectors, F or G, have incorrect size.')
    end
    
else
    
    error('??? Both inputs F and G must be frame structures or 7-vectors. See FRAME.')
    
end

return

%%
syms ax ay az aa ab ac ad bx by bz ba bb bc bd real
F=[ax;ay;az;aa;ab;ac;ad];
G = [bx;by;bz;ba;bb;bc;bd];

% As vectors
[I, I_f, I_g] = frameIncrement(F, G);

simplify(I_f - jacobian(I,F))
simplify(I_g - jacobian(I,G))

% As frames
F2.x = F; F2 = updateFrame(F2);
G2.x = G; G2 = updateFrame(G2);
[I2, I2_f, I2_g] = frameIncrement(F2, G2);

simplify(I2_f - jacobian(I2.x,F2.x))
simplify(I2_g - jacobian(I2.x,G2.x))

% Check that vector and frame results match
simplify(I2.x - I)

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

