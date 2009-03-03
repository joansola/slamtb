function  dispRob = drawRobot(dispRob,Rob)

% DRAWROBOT  Dispaly camera graphics
%   RH = DRAWROBOT(CH,Rob) updates graphics handle RH for a robot Rob.


[te,Re,Ret] = getTR(Rob);
Te = repmat(te,1,size(Rob.graphics.vert,1));
Rob.graphics.vert = Rob.graphics.vert0*Ret+Te'; 
set(dispRob,'vertices',Rob.graphics.vert);
