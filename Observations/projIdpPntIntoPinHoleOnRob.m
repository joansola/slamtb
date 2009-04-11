function [u,s,U_r,U_s,U_pk,U_pd,U_l]  = projIdpPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l)

if nargout <= 2  % No Jacobians requested

    p     = idp2p(l);
    [u,s] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, p);

else            % Jacobians requested

    if size(l,2) == 1
        % function calls
        [p,P_l]                     = idp2p(l);
        [u,s,U_r,U_s,U_pk,U_pd,U_p] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, p);

        % chain rule
        U_l = U_p*P_l;

    else
        error('??? Jacobians not available for multiple IDP points.')

    end

end
