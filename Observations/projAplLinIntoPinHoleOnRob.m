function [hm, v, HM_r, HM_s, HM_k, HM_l] = ...
    projAplLinIntoPinHoleOnRob(Rf, Sf, Spk, l)

% PROJAPLLININTOPINHOLEONROB Project anchored Plucker line into pinhole on robot.
%    [HML,S] = PROJAPLLININTOPINHOLEONROB(RF, SF, SPK, SPD, L) projects 3D
%    Plucker line L into a pin-hole camera mounted on a robot, providing
%    also the non-measurable vector. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       L  : 3D Plucker line [nx ny nz vz vy vz]'
%    The output parameters are:
%       HML : 2D homogeneous line [a b c]'
%       V   : non-measurable vector [vx vy vz]'
%
%    [HML,S,HM_R,HM_S,HM_K,HM_L] = ... gives also the jacobians of the
%    observation HML wrt all input parameters. 
%
%    See also PINHOLEPLUCKER, TOFRAMEPLUCKER, PROJEUCPNTINTOPINHOLEONROB.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

if nargout <= 2 % only pixel
    
    pl     = unanchorPlucker(l);
    [hm,v] = projPlkLinIntoPinHoleOnRob(Rf, Sf, Spk, pl);
    
else % Jacobians
    
    % Same functions with Jacobians
    [pl,PL_l]                   = unanchorPlucker(l);
    [hm,v,HM_r,HM_s,HM_k,HM_pl] = projPlkLinIntoPinHoleOnRob(Rf, Sf, Spk, pl);

    % The chain rule for Jacobians
    HM_l  = HM_pl*PL_l;

end

