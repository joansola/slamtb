function [t,q,R,Rt,Pi,Pc] = splitFrame(F)

% SPLITFRAME  Split frame information into useful matrices and vectors.
%   [T,Q,R,Rt] = SPLITFRAME(F), for a frame F, returns the translation
%   vector T, quaternion Q, rotation matrix R and its transpose Rt. The
%   frame F can be either a 7-vector F=[T;Q] or a structure containing, at
%   least, the fields F.t, F.q, F.R and F.Rt.
%
%   [T,Q,R,Rt,Pi,Pc] = SPLITFRAME(F) returns in addition the Pi matrix and
%   its conjugate Pc. See fromFrame and toFrame for explanations on
%   matrices Pi and Pc. If F is a frame structure, it needs to contain the
%   fields F.Pi and F.Pc.

if isa(F,'struct')
    t  = F.t;
    q  = F.q;
    R  = F.R;
    Rt = F.Rt;

    if nargout > 4
        Pi = F.Pi;
        Pc = F.Pc;
    end
    
else % F is a 7-vector
    t  = F(1:3);
    q  = F(4:7);
    R  = q2R(q);
    Rt = R';
    
    if nargout > 4
        Pi = q2Pi(q);
        Pc = pi2pc(Pi);
    end
end
