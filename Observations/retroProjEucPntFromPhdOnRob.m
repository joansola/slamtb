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

