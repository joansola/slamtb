function [hmhm,HMHM_l] = stereoPlucker(StHead,L)

% STEREOPLUCKER Plucker stereo projection, homogeneous outputs.
%   STEREOPLUCKER(SH,L)  Projects the Plucker line L into the two
%   images of the stereo head SH. The result is a 6-vector with stacked
%   homogeneous representations of the lines in the left and right images.
%
%   [hmhm,HMHM_l] = STEREOPLUCKER(...) returns the Jacobians wrt L.
%
%   See also STEREOPLUCKERINRHOTHETA, HM2RT.


if nargout == 1

    hmL = pinHolePlucker(StHead.cal,L);

    rightFrame = [StHead.alpha/StHead.cal(3);0;0;1;0;0;0];

    LR = toFramePlucker(rightFrame,L);

    hmR = pinHolePlucker(StHead.cal,LR);

    hmhm = [hmL;hmR];

else

    [hmL,HML_k,HML_l] = pinHolePlucker(StHead.cal,L);

    rightFrame = [StHead.alpha/StHead.cal(3);0;0;1;0;0;0];

    [LR,LR_rf,LR_l] = toFramePlucker(rightFrame,L);

    [hmR,HMR_k,HMR_lr] = pinHolePlucker(StHead.cal,LR);
    
    hmhm = [hmL;hmR];

    HMHM_l = [HML_l;HMR_lr*LR_l];
    
end


return

%% jac

syms n1 n2 n3 v1 v2 v3 real
syms u0 v0 au av a real
L = [n1;n2;n3;v1;v2;v3];
StHead.cal = [u0;v0;au;av];
StHead.alpha = a;

[hmhm,HMHM_l] = stereoPlucker(StHead,L)

HMHM_l - jacobian(hmhm,L)
