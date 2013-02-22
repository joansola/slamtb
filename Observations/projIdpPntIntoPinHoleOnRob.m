function [u,s,U_r,U_s,U_k,U_d,U_idp]  = projIdpPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, idp)

% PROJIDPPNTINTOPINHOLEONROB Project Idp pnt into pinhole on robot.
%    [U,S] = PROJIDPPNTINTOPINHOLEONROB(RF, SF, SPK, SPD, L) projects 3D
%    Inverse Depth points into a pin-hole camera mounted on a robot,
%    providing also the non-measurable depth. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       SPD: radial distortion parameters [K2 K4 K6 ...]'
%       L  : 3D inverse depth point [x y z pitch yaw rho]'
%    The output parameters are:
%       U  : 2D pixel [u v]'
%       S  : non-measurable depth
%
%    The function accepts an idp points matrix L = [L1 ... Ln] as input.
%    In this case, it returns a pixels matrix U = [U1 ... Un] and a depths
%    row-vector S = [S1 ... Sn].
%
%    [U,S,U_R,U_S,U_K,U_D,U_L] = ... gives also the jacobians of the
%    observation U wrt all input parameters. Note that this only works for
%    single points.
%
%    See also PINHOLE, TOFRAME, PROJEUCPNTINTOPINHOLEONROB.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


if nargout <= 2  % No Jacobians requested

    idpr  = toFrameIdp(Rf,idp);
    [u,s] = projIdpPntIntoPinHole(Sf, Spk, Spd, idpr);

else            % Jacobians requested

    if size(idp,2) == 1
        
        % function calls
        [idpr, IDPR_r, IDPR_idp]  = toFrameIdp(Rf,idp);
        [u,s, U_s, U_k, U_d, U_idpr] = projIdpPntIntoPinHole(Sf, Spk, Spd, idpr);

        % chain rule
        U_r   = U_idpr*IDPR_r;
        U_idp = U_idpr*IDPR_idp;

    else
        error('??? Jacobians not available for multiple IDP points.')

    end

end









