function [p,Ph1,Ph2] = hh2p(h1,h2,euc)

% HH2P  Intersection of 2 homogeneous lines.
%   HH2P(H1,H2) is the intersection point in homogeneous coordinates of the
%   two homogeneous lines H1 and H2, defined in the projective plane P^2.
%
%   HH2P(H1,H2,EUC), with EUC ~= 0, returns the point in Euclidean
%   coordinates.
%
%   [P,P_h1,P_h2] = HH2P(...) returns the Jacobians wrt the lines H1 and H2.
%
%   See also PP2HM.

if nargout == 1

    p = cross(h1,h2);

    if nargin == 3 && euc % Return Euclidean point
        p = hmg2euc(p);
    end

else % Jac

    [p,Ph1,Ph2] = crossJ(h1,h2);
    
     if nargin == 3 && euc % Return Euclidean point
        [p,Pp] = hmg2euc(p);
        Ph1 = Pp*Ph1;
        Ph2 = Pp*Ph2;
     end
end

return

%% Jac
syms l1 l2 l3 m1 m2 m3 real
l = [l1;l2;l3];
m = [m1;m2;m3];

%% homogeneous
[p,Pl,Pm] = hh2p(l,m);

Pl - jacobian(p,l)
Pm - jacobian(p,m)

%% Euclidean
[p,Pl,Pm] = hh2p(l,m,1);

Pl - jacobian(p,l)
Pm - jacobian(p,m)
