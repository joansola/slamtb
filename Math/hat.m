function [SQ,SQw] = hat(W)

% HAT  Hat operator.
%   SQ = HAT(W) gives the skew symmetric matrix SQ corresponding
%   to the vector W defined by the 'hat' operator:
%
%        [ 0  -Wz  Wy]
%   SQ = [ Wz  0  -Wx]
%        [-Wy  Wx  0 ]
%
%   W = HAT(SQ) performs the inverse operation, i.e. gives the vector W so
%   that HAT(W) = SQ.
%   NOTE: The matrix SQ is NOT checked for skew-symmetry.
%
%   It is an error if length(W) ~= 3 or size(SQ) ~= [3 3].
%
%   See also ESSENTIAL.

if numel(W) == 3;
    SQ = [...
        0    -W(3)  W(2)
        W(3)  0    -W(1)
        -W(2)  W(1)  0   ];

    if nargout > 1

        SQw = [...
            [  0,  0,  0]
            [  0,  0,  1]
            [  0, -1,  0]
            [  0,  0, -1]
            [  0,  0,  0]
            [  1,  0,  0]
            [  0,  1,  0]
            [ -1,  0,  0]
            [  0,  0,  0]];

    end

elseif numel(W) == 9 && size(W,1) == 3
%     SQ = [W(3,2);W(1,3);W(2,1)];
    SQ = W([6;7;2]);
else
    error('Input parameter W must be a 3x1 (or 1x3) vector, or a 3x3 matrix')
end

return

%%

syms x y z real
w = [x;y;z];
S = hat(w);
SQw = jacobian(S,w)