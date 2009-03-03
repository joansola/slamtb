function [u,Ui] = idpProject(idp)

x0     = idp(1:3);   % origin
m      = idp(4:5);   % pitch and roll
r      = idp(6);     % inverse depth

[v,Vm] = py2vec(m);  % unity vector

[u,Uv] = project(v); % canonic projection


if nargout > 1 % jacobians
    
    Mi = [1 0 0;0 1 0];
        
    Ui = Uv*Vm*Mi;

end

