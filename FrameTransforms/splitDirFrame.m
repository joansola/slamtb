function [t,R,Pi] = splitDirFrame(F)

% SPLITDIRFRAME  Split direct frame information.
%   [T,R] = SPLITDIRFRAME(F), for a frame F, returns the translation vector
%   T and the rotation matrix R. The frame F can be either a 7-vector
%   F=[T;Q] or a structure containing, at least, the fields F.t and F.R.
%
%   [T,R,Pi] = SPLITDIRFRAME(F) returns in addition the Pi matrix. See
%   toFrame for explanations on matrices Pi and Pc. If F is a frame
%   structure, it needs to contain the field F.Pi.
%
%   See also FRAME, SPLITFRAME, UPDATEFRAME, TOFRAME.

if isa(F,'struct')
    t = F.t;
    R = F.R;

    if nargout > 2
        Pi = F.Pi;
    end
    
else % F is a 7-vector
    R = q2R(F(4:7));
    t = F(1:3);
    
    if nargout > 2
        Pi = q2Pi(F(4:7));
    end
end
