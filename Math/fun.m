function [z, J, H] = fun(x)

[x1,x2,x3] = split(x);

z = [...
    x1*x2+sin(x3);
    x2/x1-cos(x3)];

if nargout > 1
    J = [...
              x2   x1 cos(x3)
        -x2/x1^2 1/x1 sin(x3)];

    if nargout > 2
        H(:,:,1) = [...
                    0       1 0
            2*x2/x1^3 -1/x1^2 0];

        H(:,:,2) = [...
                  1 0 0
            -1/x1^2 0 0];

        H(:,:,3) = [...
            0 0 -sin(x3)
            0 0  cos(x3)];
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











