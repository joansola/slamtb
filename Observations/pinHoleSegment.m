function [s,d,S_k,S_si] = pinHoleSegment(k,si)

% PINHOLESEGMENT  Pin hole projection of a segment.
%   [S,D] = PINHOLESEGMENT(K,SI) projects into a pinhole camera with
%   intrinsic aprameters K the segment SI. It returns the projected segment
%   S and the non-observable depths D of the two endpoints.
%
%   SI is a 6-vector containing the two endpoints of the 3D segment.
%   S is a 4-vector conteining the two endpoints of the 2D segment.
%
%   [S,D,S_k,S_si] = POINHOLESEGMENT(...) returns the Jacobians of S wrt K
%   and SI.
%
%   See also PINHOLE.

p1 = si(1:3,:);
p2 = si(4:6,:);

if nargout <= 2

    [e1,d1] = pinHole(p1,k);
    [e2,d2] = pinHole(p2,k);
    s       = [e1;e2];
    d       = [d1;d2];

else % Jacobians

    if size(si,2) == 1

        [e1,d1,E1_p1,E1_k] = pinHole(p1,k);
        [e2,d2,E2_p2,E2_k] = pinHole(p2,k);
        s       = [e1;e2];
        d       = [d1;d2];

        S_k = [...
            E1_k
            E2_k];

        Z23 = zeros(2,3);

        S_si = [...
            E1_p1 Z23
            Z23   E2_p2];

    else

        error('Jacobians not available for multiple segments.')

    end

end

return

%% test
syms p1 p2 p3 q1 q2 q3 u0 v0 au av real
k  = [u0;v0;au;av];
si = [p1;p2;p3;q1;q2;q3];

[s,d,S_k,S_si] = pinHoleSegment(k,si);

simplify(S_k - jacobian(s,k))
simplify(S_si - jacobian(s,si))
