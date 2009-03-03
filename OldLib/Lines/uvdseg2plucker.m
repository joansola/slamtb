function [L,L_u] = uvdseg2plucker(StHead,uvdSeg)

% UVDSEG2PLUCKER  Retro projection of a stereo segment onto 3D Plucker line.
%   UVDSEG2PLUCKER(STHEAD,UVDSEG) retroprojects the stereo segment UVDSEG =
%   (u1,v1,d1,u2,v2,d2) onto a 3D plucker line, using the stereo head
%   STHEAD. This is a structure with fields:
%       STHEAD.alpha = alpha, the scale factor = baseline * au.
%       STHEAD.cal   = [u0 v0 au av] the intrinsic parameters.
%
%   [L,L_uvdseg] = (...) returns the Jacobian wrt the segment.

%   (c) 2008 Joan Sola @ LAAS-CNRS.

uvd1 = uvdSeg(1:3);
uvd2 = uvdSeg(4:6);

switch nargout
    case 1

        p = uvd2hp(StHead,uvd1);
        q = uvd2hp(StHead,uvd2);

        L = points2plucker(p,q);

    case 2 % Jac only wrt uvdSeg

        [p,P_u1] = uvd2hp(StHead,uvd1);
        [q,Q_u2] = uvd2hp(StHead,uvd2);

        [L,L_p,L_q] = points2plucker(p,q);
        
        L_u1 = L_p*P_u1;
        L_u2 = L_q*Q_u2;
        
        L_u = [L_u1 L_u2];

    case {3,4} % All Jacobians

end

return

%% jac
syms u1 v1 d1 u2 v2 d2 u0 v0 au av a real

H.alpha = a;
H.cal = [u0 v0 au av];
uvdSeg = [u1;v1;d1;u2;v2;d2];

[L,L_u] = uvdseg2plucker(H,uvdSeg)

L_u-jacobian(L,uvdSeg)
