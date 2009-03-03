function [scIm,scIm0] = par2scIm(Xm,XM,Ym,YM,pixDist)

% PAR2SCIM  Region parameters to scores image
%   [SCIM,SCIM0] = PAR2SCIM(Um,UM,Vm,VM,pxDst)

[Um,UM,Vm,VM] = par2box(Xm,XM,Ym,YM,pixDist);

% scores image, initialized
scIm = -ones(VM-Vm+1,UM-Um+1);
% scIm = zeros(VM-Vm+1,UM-Um+1);

% Offset from origin to indices
scIm0 = [-Um+1;-Vm+1];
