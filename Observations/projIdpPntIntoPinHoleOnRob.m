function [u,s,U_r,U_s,U_pk,U_pd,U_l]  = projIdpPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l)

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

if nargout <= 2  % No Jacobians requested

    p     = idp2euc(l);
    [u,s] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, p);

else            % Jacobians requested

    if size(l,2) == 1
        
        % function calls
        [p,P_l]                     = idp2euc(l);
        [u,s,U_r,U_s,U_pk,U_pd,U_p] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, p);

        % chain rule
        U_l = U_p*P_l;

    else
        error('??? Jacobians not available for multiple IDP points.')

    end

end
