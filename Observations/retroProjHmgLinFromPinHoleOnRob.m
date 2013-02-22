function [l, L_rf, L_sf, L_k, L_seg, L_n] = ...
    retroProjHmgLinFromPinHoleOnRob(Rf, Sf, k, seg, n)

% RETROPROJHMGLINFROMPINHOLEONROB retroprj Hmg Line from pinhole on robot.

%   Copyright 2009 Teresa Vidal.


if nargout == 1
    
    ls = invPinHoleHmgLin(k, seg, n) ;
    lr = fromFrameHmgLin(Sf, ls);
    l  = fromFrameHmgLin(Rf, lr);
    
else % Jacobians requested
    
    [ls, LS_seg, LS_n, LS_k] = invPinHoleHmgLin(seg, n, k) ;
    [lr, LR_sf, LR_ls]       = fromFrameHmgLin(Sf, ls);
    [l, L_rf, L_lr]          = fromFrameHmgLin(Rf, lr);

    L_sf  = L_lr*LR_sf;
    L_ls  = L_lr*LR_ls;
    L_k   = L_ls*LS_k;
    L_seg = L_ls*LS_seg;
    L_n   = L_ls*LS_n;
    
end









