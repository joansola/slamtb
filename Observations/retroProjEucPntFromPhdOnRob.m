function [p, P_r, P_s, P_k, P_c, P_v] = retroProjEucPntFromPhdOnRob(Rf, Sf, k, c, v)

if nargout == 1
    
    p = fromFrame(composeFrames(Rf, Sf),  invPinHoleDepth(v, k, c));
    
else
    
    [RSf, RS_r, RS_s] = composeFrames(Rf, Sf);
    
    [prs, PRS_v, PRS_k, PRS_c] = invPinHoleDepth(v, k, c);
    
    [p, P_rs, P_prs] = fromFrame(RSf, prs);
    
    P_r = P_rs * RS_r;
    P_s = P_rs * RS_s;
    P_k = P_prs * PRS_k;
    P_c = P_prs * PRS_c;
    P_v = P_prs * PRS_v;
    
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

[p, P_r, P_s, P_k, P_c, P_u] = retroProjEucPntFromPhdOnRob(Rf, Sf, k, [], u);


% simplify(U_r - jacobian(u,Rf.x)) % Too slow
