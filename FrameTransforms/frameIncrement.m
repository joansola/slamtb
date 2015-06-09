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
        
        I(1:3,1) = toFrame(F, G(1:3));
        I(4:7) = qProd(q2qc(F(4:7)),G(4:7));
    else
        error('??? One or both frame vectors, F or G, have incorrect size.')
    end
    
else
    
    error('??? Both inputs F and G must be frame structures or 7-vectors. See FRAME.')
    
end
