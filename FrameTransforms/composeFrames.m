function [H, H_f, H_g] = composeFrames(F,G)

% COMPOSEFRAMES  Compose two 3D frames.
%   H = COMPOSEFRAMES(F,G) composes frames F and G, where frame G is
%   specified in frame F, to get a single frame transform H. Frames are
%   structures with at least the following fields:
%       .t  translation vector
%       .q  orientation quaternion
%
%   The resulting frame H, however, contains the full frame structure.
%
%   [H, H_f, H_g] = COMPOSEFRAMES(...) returns the Jacobians of H.x wrt F.x
%   and G.x.
%
%   See also FRAME, SPLITFRAME, QUATERNION.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout == 1
    
    H.t = fromFrame(F,G.t);
    H.q = qProd(F.q,G.q);
    H.x = [H.t;H.q];
    H   = updateFrame(H);
    
else
    
    [H.t, T_f, T_tg] = fromFrame(F,G.t);
    [H.q, Q_qf, Q_qg] = qProd(F.q,G.q);
    
    H.x = [H.t;H.q];
    H   = updateFrame(H);
    
    H_f = zeros(7);
    H_g = zeros(7);
    
    H_f(1:3,:)   = T_f;
    H_f(4:7,4:7) = Q_qf;
    H_g(1:3,1:3) = T_tg;
    H_g(4:7,4:7) = Q_qg;
    
end








