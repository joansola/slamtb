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

return

%%

syms rx ry rz ra rb rc rd sx sy sz sa sb sc sd u0 v0 au av x y z real
Rf.x = [rx ry rz ra rb rc rd]';
Rf = updateFrame(Rf);
Sf.x = [sx sy sz sa sb sc sd]';
Sf = updateFrame(Sf);
k = [u0 v0 au av]';
l = [x y z]';

[u, U_r, U_s, U_k, U_d, U_l] = ...
    projEucPntIntoPhdOnRob(Rf, Sf, k, [], l);

% simplify(U_r - jacobian(u,Rf.x)) % Too slow

