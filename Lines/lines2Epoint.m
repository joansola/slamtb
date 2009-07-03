function [q,Q_la,Q_lb] = lines2Epoint(La,Lb)

% LINES2EPOINT Intersection point of 2 Plucker lines. Result in Euclidean.

na = La(1:3);
nb = Lb(1:3);
vb = Lb(4:6);

if nargout == 1

    q = cross(na,nb)/dot(na,vb);

else % jac

    % work in homogeneous for easiear Jacobians
    
    [pe,PE_na,PE_nb] = crossJ(na,nb);
    [ph,PH_na,PH_vb] = dotJ(na,vb);

    p = [pe;ph];
    Z33 = zeros(3);
    Z13 = zeros(1,3);
    P_la = [PE_na Z33;PH_na Z13];
    P_lb = [PE_nb Z33;Z13 PH_vb];
    
    [q,Q_p] = hm2eu(p);
    
    Q_la = Q_p*P_la;
    
    Q_lb = Q_p*P_lb;
    
end

