function [u,s,U_r,U_s,U_pk,U_pd,U_l]  = prjIdpPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l)

if nargout <= 2  % No Jacobians requested

    p     = idp2p(l);
    [u,s] = prjEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, p);

else            % Jacobians requested

    % function calls
    [p,P_l]                     = idp2p(l);
    [u,s,U_r,U_s,U_pk,U_pd,U_p] = prjEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, p);
    
    % chain rule
    U_l = U_p*P_l;

end
