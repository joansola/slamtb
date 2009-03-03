function [Um,UM,Vm,VM] = par2box(Xm,XM,Ym,YM,pixDist)

%
% PAR2BOX  Parallelogram to box
%   [Um,UM,Vm,VM] = PAR2BOX(Xm,XM,Ym,YM,PXDST) computes the
%   integer bounds [U,V] at PXDST pixel spacing of the box 
%   defined by the parallelogram bounds [X,Y].
%
%   See also COV2PAR

%   (c) 2005 Joan Sola

Um = bround(Xm,pixDist);
UM = bround(XM,pixDist);
Vm = bround(Ym,pixDist);
VM = bround(YM,pixDist);
