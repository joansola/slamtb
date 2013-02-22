function [z,J,H] = f21(x)

% F21, 2-input , 1-output MIMO function for linearity test purposes.
%   [z, J, H] = F321(x) with x=[x1;x2] returns z, the Jacobian
%   J(1-by-2) and the Hessian H(1-by-2-by-2).
%
%   See also F32, LINVEC, LINMAT, LINIDX.

[x1,x2] = split(x);

z = x1*sin(x2);

if nargout > 1
    J = [sin(x2) x1*cos(x2)];
    
    if nargout > 2
        H(:,:,1) = [   0        cos(x2)];
        H(:,:,2) = [cos(x2) -x1*sin(x2)];

    end
end
return

%% jac
syms x1 x2 x3 real
x = [x1;x2;x3];

z = fun(x);

J = jacobian(z,x)
H1 = diff(J,'x1')
H2 = diff(J,'x2')
H3 = diff(J,'x3')











