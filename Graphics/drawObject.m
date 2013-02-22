function  handle = drawObject(handle,Obj,frame)

%DRAWOBJECT Draw 3D object graphics.
%   RH = DRAWOBJECT(CH,Obj) updates graphics handle RH for an object Obj.
%   The object to be drawn in Obj.graphics, and the position Obj.frame.
%
%   RH = DRAWOBJECT(CH,Obj,F) ignores the Obj.frame and uses F instead.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


if nargin < 3
    F = Obj.frame;
else
    F = frame;
end

objGraph = get(handle,'userdata');

[te,~,Ret]       = getTR(F);
Te                = repmat(te,1,size(objGraph.vert,1));
objGraph.vert     = objGraph.vert0*Ret+Te'; 

set(handle,'vertices',objGraph.vert);









