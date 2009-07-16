function [s, d, S_rf, S_sf, S_k, S_l] = projIdpLinIntoPinHoleOnRob(Rf, Sf, Sk, l)

if nargout <= 2
    
    sw = idpLin2seg(l);
    s   = projSegLinIntoPinHoleOnRob(Rf, Sf, Sk, sw);
    d   = 1./l([6 9]);

else
    
    [sw, SW_l] = idpLin2seg(l);
    [s, d, S_rf, S_sf, S_k, S_sw] = projSegLinIntoPinHoleOnRob(Rf, Sf, Sk, sw);
    S_l  = S_sw*SW_l;
    
end