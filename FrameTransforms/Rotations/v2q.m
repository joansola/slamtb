function [q,Qv] = v2q(v)

% V2Q Rotaiton vector to quaternion conversion.
%   [Q,Qv] = V2Q(V) returns the quaternion Q correscponding to the rotation
%   encoded in rotation vector V, and the associated Jacobian Qv = dQ/dV.

if nargout == 1
    
    [a,u] = v2au(v);
    q = au2q(a,u);

else
    a = sqrt(dot(v,v));

    if isnumeric(a) && a < 1e-6
        
        % Use small signal approximation:
        q = [1-norm(v)^2/8
            v(:)/2];
        
        Qv = [-1/4*v(:)'
            0.5*eye(3)];

    else

        [a,u,Av,Uv] = v2au(v);
        [q,Qa,Qu] = au2q(a,u);
        Qv = Qa*Av + Qu*Uv;

    end
end


return

%%
syms r s t real
v = [r;s;t];
[q,Qv] = v2q(v)

simplify(Qv - jacobian(q,v))









