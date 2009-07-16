function [w, W_f, W_v] = fromFrameVec(F,v)



w = F.R*v;


if nargout > 1   % Jacobians.

    if size(v,2) == 1
        
        s = 2*F.Pi*v;

        W_q = [...
            s(2) -s(1)  s(4) -s(3)
            s(3) -s(4) -s(1)  s(2)
            s(4)  s(3) -s(2) -s(1)];
        W_v = F.R;
        W_f = [zeros(3) W_q];

    else % multiple points
        error('??? Can''t give Jacobians for multiple points');
    end
end