function [p,P_v,P_s,P_k,P_c] = invPinHoleDepth(v,k,c)

if nargout == 1
    
    p = invPinHole(v(1:2),v(3),k,c);
    
else
    
    u = v(1:2);
    s = v(3);
    [p,P_u,P_s,P_k,P_c] = invPinHole(u,s,k,c);
    P_v = [P_u , P_s];
    
end
