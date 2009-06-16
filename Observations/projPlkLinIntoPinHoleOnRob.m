function [hm, v, HM_r, HM_s, HM_k, HM_l] = ...
    projPlkLinIntoPinHoleOnRob(Rf, Sf, Spk, l)

% PROJPLKLININTOPINHOLEONROB Project Plucker line into pinhole on robot.
%    [U,S] = PROJPLKLININTOPINHOLEONROB(RF, SF, SPK, SPD, L) projects 3D
%    Plucker line L into a pin-hole camera mounted on a robot, providing
%    also the non-measurable vector. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       L  : 3D Plucker line [nx ny nz vz vy vz]'
%    The output parameters are:
%       HM : 2D homogeneous line [a b c]'
%       V  : non-measurable vector [vx vy vz]'
%
%    [HM,S,HM_R,HM_S,HM_K,HM_L] = ... gives also the jacobians of the
%    observation HM wrt all input parameters. 
%
%    See also PINHOLEPLUCKER, TOFRAMEPLUCKER, PROJEUCPNTINTOPINHOLEONROB.

%   (c) 2009 David Marquez @ LAAS-CNRS.

if nargout <= 2 % only pixel
    
    lr    = toFramePlucker(Rf,l);
    ls    = toFramePlucker(Sf,lr);
    
    [hm,v] = pinHolePlucker(Spk,ls);
    
else % Jacobians
    
    % Same functions with Jacobians
    [lr, LR_r, LR_l]  = toFramePlucker(Rf,l);
    [ls, LS_s, LS_lr] = toFramePlucker(Sf,lr);
    [hm,v,HM_k,HM_ls] = pinHolePlucker(Spk,ls);

    % The chain rule for Jacobians
    HM_lr = HM_ls*LS_lr;
    HM_r  = HM_lr*LR_r;
    HM_s  = HM_ls*LS_s;
    HM_l  = HM_lr*LR_l;

end
return

%% test Jacobians
syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd u0 v0 au av nx ny nz vx vy vz real

Rf.x=[rx;ry;rz;ra;rb;rc;rd];
Sf.x=[sx;sy;sz;sa;sb;sc;sd] ;

Rf = updateFrame(Rf);
Sf = updateFrame(Sf);
Spk = [u0;v0;au;av];
l   = [nx ny nz vx vy vz]';

[hm,v,HM_r,HM_s,HM_k,HM_l] = projPlkLinIntoPinHoleOnRob(Rf, Sf, Spk, l);

%% down here tha Jac test - WARNING! IT TAKES AGES TO COMPUTE !!
simplify(HM_r - jacobian(hm,Rf.x))
simplify(HM_s - jacobian(hm,Sf.x))
simplify(HM_k - jacobian(hm,Spk))
simplify(HM_l - jacobian(hm,l))

%% test non-jacobian sections
syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd u0 v0 au av nx ny nz vx vy vz real

Rf.x = [rx;ry;rz;ra;rb;rc;rd];
Sf.x = [sx;sy;sz;sa;sb;sc;sd] ;

Rf   = updateFrame(Rf);
Sf   = updateFrame(Sf);
Spk  = [u0;v0;au;av];
l    = [nx ny nz vx vy vz]';

[hm,v] = projPlkLinIntoPinHoleOnRob(Rf, Sf, Spk, l)
