function  handle = drawObject(handle,Obj,frame)

% DRAWOBJECT  Dispaly object graphics
%   RH = DRAWOBJECT(CH,Obj) updates graphics handle RH for an object Obj.
%   The object to be drawn in Obj.graphics, and the position Obj.frame.
%
%   RH = DRAWOBJECT(CH,Obj,F) ignores the Obj.frame and uses F instead.

% (c) 2009 Joan Sola @ LAAS-CNRS.


if nargin < 3
    F = Obj.frame;
else
    F = frame;
end

[te,Re,Ret]       = getTR(F);
Te                = repmat(te,1,size(Obj.graphics.vert,1));
Obj.graphics.vert = Obj.graphics.vert0*Ret+Te'; 

set(handle,'vertices',Obj.graphics.vert);
