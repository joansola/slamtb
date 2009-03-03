function [L,L_h,L_u] = retroProjectStereoPlucker(StHead,uvdSeg)

% RETROPROJECTSTEREOPLUCKER  Retro project Plucker line
%   L = RETROPROJECTSTEREOPLUCKER(STHEAD,UVDSEG) retro-projects the
%   stereo segment UVDSEG perceived in a stereo head STHEAD. STHEAD is a structure containing
%       .cal    intrinsic pin hole camera parameters
%       .alpha  extrinsic stereo scale factor
%       .X      pose of the stereo head (at the left camera).
%
%   [L,L_h,L_u] = ... returns the Jacobians wrt .X and UVDSEG.

% (c) 2008 Joan Sola @ LAAS-CNRS

if nargout == 1

    LC = invStereoPlucker(StHead,uvdSeg);   % the line in C frame

    L  = fromFramePlucker(StHead.X,LC);     % the line in global frame

else

    [LC,LC_u]    = invStereoPlucker(StHead,uvdSeg);

    [L,L_h,L_lc] = fromFramePlucker(StHead.X,LC);

    L_u  = L_lc * LC_u;                     % the full Jacobian

end

return

%% jac
syms x y z a b c d real
syms u0 v0 au av aa real
syms u1 v1 d1 u2 v2 d2 real
H.X=[x;y;z;a;b;c;d];
H.alpha = aa;
H.cal = [u0;v0;au;av];
seg = [u1;v1;d1;u2;v2;d2];

%% build
L1 = retroProjectStereoPlucker(H,seg)

%% test
[L,L_h,L_u] = retroProjectStereoPlucker(H,seg)

simplify(L - L1)
simplify(L_h - jacobian(L,H.X))
simplify(L_u - jacobian(L,seg))
