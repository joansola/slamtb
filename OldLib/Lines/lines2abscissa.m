function [t,T_l,T_r] = lines2abscissa(L,r)

% LINES2ABSCISSA  Abscissa of Plucer line at the intersection with ray.
%   LINES2ABSCISSA(L,R) gives the abscissa in the line L corresponding to
%   the intersection point of L and R. Both L and R are Plucker lines.
%
%   [t,T_l,T_r] = LINES2ABSCISSA(L,R) returns the Jacobians wrt L and R.

if nargout == 1

    p0 = lineOrigin(L);
    e  = lines2Epoint(L,r);

    u  = normvec(L(4:6));

    % solve the system e = p0 + t*u for variable t:
    t = u'*(e - p0); % note that pinv(u) = u' because norm(u) = 1.

else % jac

    [p0,P0_l]   = lineOrigin(L);
    [e,E_l,E_r] = lines2Epoint(L,r);

    [u,U_v] = normvec(L(4:6),1);
    U_l     = [zeros(3) U_v];
    
    % solve the system e = p0 + t*u for variable t:
    t    = u'*(e - p0); % note that pinv(u) = u' because norm(u) = 1.
    T_u  = (e-p0)';
    T_e  = u';
    T_p0 = u';
    
    T_l = T_e*E_l + T_u*U_l + T_p0*P0_l;
    T_r = T_e*E_r;
    
end


%%

