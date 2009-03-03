function [seg,SEG_l,SEG_s] = ls2seg(L,s)

% LS2SEG  Plucker line and abscissas to segment
%   LS2SEG(L,S) is the segment of the Plucker line L defined by
%   endpoints' abscissas vector S=[S1;S2].
%
%   [seg,SEG_l,SEG_s] = LS2SEG(...) returns the Jacobians wrt L ans S.

if nargout == 1

    [e1,e2] = ls2ee(L,s(1),s(2));
    seg  = [e1;e2];

else % Jac

    [e1,e2,E1_l,E2_l,E1_s1,E2_s2] = ls2ee(L,s(1),s(2));
    seg   = [e1;e2];
    
    SEG_l = [E1_l;E2_l];

    Z = zeros(3,1);
    SEG_s = [E1_s1 Z;Z E2_s2];

end

return

%% jac
