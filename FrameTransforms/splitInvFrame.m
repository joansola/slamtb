function [it,Rt,Pc] = splitInvFrame(F)

% SPLITINVFRAME  Split inverse frame information.
%   [iT,Rt] = SPLITINVFRAME(F), for a frame F, returns the inverse
%   translation vector iT and the transposed rotation matrix Rt. The frame
%   F can be either a 7-vector F=[T;Q] or a structure containing, at least,
%   the fields F.it and F.Rt.
%
%   [iT,Rt,Pc] = SPLITINVFRAME(F) returns in addition the conjugated Pi
%   matrix Pc. See toFrame for explanations on matrices Pi and Pc. If F is
%   a frame structure, it needs to contain the field F.Pc.
%
%   See also FRAME, SPLITFRAME, UPDATEFRAME, TOFRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if isa(F,'struct')
    it = F.it;
    Rt = F.Rt;

    if nargout > 2
        Pc = F.Pc;
    end
    
else % F is a 7-vector
    Rt = q2R(F(4:7))';
    it = -Rt*F(1:3);
    
    if nargout > 2
        Pc = q2Pi(q2qc(F(4:7)));
    end
end
