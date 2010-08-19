function [ahp, AHP_idp] = idp2ahp(idp)

% IDP2AHP IDP to AHP point transformation.
%   IDP2AHP(IDP) transforms the IDP point into its AHP representation.
%
%   [ahp, AHP_idp] = IDP2AHP(...) returns the Jacobian.

%   Copyright 2010 Joan Sola

x0 = idp(1:3,:);
py = idp(4:5,:);
r = idp(6,:);

if nargout == 1
    
    ahp = [x0; py2vec(py); r];
    
else
    
    if size(idp,2) == 1
        
        [v,V_py] = py2vec(py);
        ahp = [x0;v;r];
        AHP_idp = [...
            eye(3) zeros(3)
            zeros(3) V_py zeros(3,1)
            zeros(1,5) 1];
        
    else
        
        error ('Jacobians not defined for multiple idps.');
        
    end
    
end
        
return

%%
syms x y z e a r real
idp = [x;y;z;e;a;r];
[ahp,AHP_idp] = idp2ahp(idp);

simplify(AHP_idp - jacobian(ahp,idp))
