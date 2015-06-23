function [u, U_r, U_s, U_k, U_d, U_l] = ...
    projEucPntIntoPhdOnRob(Rf, Sf, Spk, Spd, l)


if nargout == 1
    % Project landmark
    u = pinHoleDepth(toFrame(composeFrames(Rf,Sf), l), Spk, Spd);
    
else
    % Sensor frame in global frame
    [RSf, RS_r, RS_s] = composeFrames(Rf,Sf);
    
    % Landmark in sensor frame
    [lrs, LRS_rs, LRS_l] = toFrame(RSf, l);
    
    % Project landmark
    [u, U_lrs, U_k, U_d] = pinHoleDepth(lrs, Spk, Spd);
    
    % Chain rule for Jacobians
    U_l = U_lrs * LRS_l;
    U_rs = U_lrs * LRS_rs;
    U_r = U_rs * RS_r;
    U_s = U_rs * RS_s;
    
end
