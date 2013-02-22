function [l, L_rf, L_sf, L_k, L_seg, L_n] = ...
    retroProjAhmLinFromPinHoleOnRob(Rf, Sf, k, seg, n)

% RETROPROJAHMLINFROMPINHOLEONROB retroprj Ahm Line from pinhole on robot.

%   Copyright 2009 Teresa Vidal.


if nargout == 1
    
    ls = invPinHoleAhmLin(k, seg, n) ;
    lr = fromFrameAhmLin(Sf, ls);
    l  = fromFrameAhmLin(Rf, lr);
    
else % Jacobians requested
    
    [ls, LS_seg, LS_n, LS_k] = invPinHoleAhmLin(seg, n, k) ;
    [lr, LR_sf, LR_ls]       = fromFrameAhmLin(Sf, ls);
    [l, L_rf, L_lr]          = fromFrameAhmLin(Rf, lr);

    L_sf  = L_lr*LR_sf;
    L_ls  = L_lr*LR_ls;
    L_k   = L_ls*LS_k;
    L_seg = L_ls*LS_seg;
    L_n   = L_ls*LS_n;
    
end









