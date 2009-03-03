function [h,H_k,H_al] = pinHoleAPlucker(k,aL)

% PINHOLEAPLUCKER Projects anchored Plucker line.
%   PINHOLEAPLUCKER(K,L) projects the anchored Plucker line L into a pin
%   hole camera K=[u0;v0;au;av] at the origin.
%
%   [l,Lk,Ll] = ... returns the Jacobians wrt K and L.
%
%   See also PINHOLEPLUCKER.

% (c) 2008 Joan Sola @ LAAS-CNRS

if nargout == 1
    
    h = pinHolePlucker(k,unanchorPlucker(aL));

else

    [L,L_al]    = unanchorPlucker(aL);
    [h,H_k,H_l] = pinHolePlucker(k,L);
    
    H_al = H_l*L_al;

end

return

%%

