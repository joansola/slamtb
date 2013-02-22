function [l, L_rf, L_sf, L_k, L_seg, L_n] = ...
    retroProjIdpLinFromPinHoleOnRob(Rf, Sf, k, seg, n)

% RETROPROJIDPLINFROMPINHOLEONROB retroprj Idp Line from pinhole on robot.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


if nargout == 1
    
    ls = invPinHoleIdpLin(k, seg, n) ;
    lr = fromFrameIdpLin(Sf, ls);
    l  = fromFrameIdpLin(Rf, lr);
    
else % Jacobians requested
    
    [ls, LS_seg, LS_n, LS_k] = invPinHoleIdpLin(seg, n, k) ;
    [lr, LR_sf, LR_ls]       = fromFrameIdpLin(Sf, ls);
    [l, L_rf, L_lr]          = fromFrameIdpLin(Rf, lr);

    L_sf  = L_lr*LR_sf;
    L_ls  = L_lr*LR_ls;
    L_k   = L_ls*LS_k;
    L_seg = L_ls*LS_seg;
    L_n   = L_ls*LS_n;
    
end









