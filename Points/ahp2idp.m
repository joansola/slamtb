function [idp, IDP_ahp] = ahp2idp(ahp)

% AHP2IDP IDP to AHP point transformation.
%   AHP2IDP(IDP) transforms the IDP point into its AHP representation.
%
%   [ahp, AHP_idp] = AHP2IDP(...) returns the Jacobian.

%   Copyright 2010 Joan Sola

x0 = ahp(1:3,:);
v  = ahp(4:6,:);
r  = ahp(7,:);

if nargout == 1
    
    idp = [x0; vec2py(v); r];
    
else
    
    if size(ahp,2) == 1
        
        [py,PY_v] = vec2py(v);
        idp = [x0;py;r];
        IDP_ahp = [...
            eye(3) zeros(3,4)
            zeros(2,3) PY_v zeros(2,1)
            zeros(1,6) 1];
        
    else
        
        error ('Jacobians not defined for multiple ahps.');
        
    end
    
end
        
return

%%
syms x y z u v w r real
ahp = [x;y;z;u;v;w;r];
[idp,IDP_ahp] = ahp2idp(ahp);

simplify(IDP_ahp - jacobian(idp,ahp))
