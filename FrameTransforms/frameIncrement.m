function [I, I_f, I_g] = frameIncrement(F, G)

% FRAMEINCREMENT  Frame increment
%   I = FRAMEINCREMENT(F,G) is the incremental frame going from F to G,
%   that is, the expression of frame G expressed in frame F.
%
%   If both frames F and G are structures as defined in FRAME, then so is I.
%   If both frames F and G are 7-vectors, then so is I.
%   Otherwise is an error.
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
