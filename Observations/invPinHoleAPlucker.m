function [l,L_k,L_hm,L_beta] = invPinHoleAPlucker(Sk,hm,beta)

% INVPINHOLEPALUCKER Retro-projects anchored plucker line
%   INVPINHOLEAPLUCKER(K,L,BETA) retro-projects the anchored Plucker line
%   from the homogeneous 2D line HM and a pin hole camera K=[u0;v0;au;av]
%   at the origin. BETA specifies the unobservable direction of the line.
%   BETA is a 2-vector expressed in the plane base given by
%   PLANEVEC2PLANEBASE.
%
%   [l,L_k,L_hm,L_beta] = ... returns Jacobians wrt K, HM and BETA.
%
%   See also INVPINHOLEPLUCKER.

if nargout == 1
    % Plucker line 
    pl = invPinHolePlucker(Sk,hm,beta) ;

    % anchored Plucker line L
    l = anchorPlucker(pl,[0;0;0]);

else
    % Plk lin in Sensor Frame
    [pl, PL_k, PL_hm, PL_beta] = invPinHolePlucker(Sk,hm,beta) ;
    
    % L in sensor frame
    [l, L_pl] = anchorPlucker(pl,[0;0;0]);
    
    % chain rule
    L_k    = L_pl * PL_k;
    L_hm   = L_pl * PL_hm;
    L_beta = L_pl * PL_beta;

end
