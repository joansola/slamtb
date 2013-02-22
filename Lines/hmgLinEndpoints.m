function [e1, e2, E1_l, E2_l] = hmgLinEndpoints(l,t1,t2)

% HMGLINENDPOINTS  HMG line endpoints.
%   HMGLINENDPOINTS(L,T) returns the 3D Euclidean endpoint of the
%   HMG line L at abscissa T.
%
%   [E1,E2] = HMGLINENDPOINTS(L,T1,T2) returns two 3D Euclidean endpoints
%   at abscissas T1 and T2.
%
%   [e1,e2,E1_l,E2_l] = HMGLINENDPINTS(...) returns the Jacobians of the
%   endopints wrt L.
%
%   See also HMGLINSEGMENT, HMGLIN2SEG, HMGLIN2IDPPNTS.

%   Copyright 2009 Teresa Vidal.

if nargout <= 2

    % support segment
    s  = hmgLin2seg(l);

    % support points
    p1 = s(1:3);
    p2 = s(4:6);

    % endpoints
    e1 = (1-t1)*p1 + t1*p2;
    e2 = (1-t2)*p1 + t2*p2;

else
    
    [s, S_l] = hmgLin2seg(l);       % support segment
    
    p1 = s(1:3);                    % support points
    p2 = s(4:6);
    
    P1_l = S_l(1:3,:);              % jacobians of sup points
    P2_l = S_l(4:6,:);
    
    e1 = (1-t1)*p1 + t1*p2;         % endpoints
    e2 = (1-t2)*p1 + t2*p2;
    
    E1_p1 = 1-t1;                   % jacobians of endpoints
    E1_p2 = t1;
    E2_p1 = 1-t2;
    E2_p2 = t2;
    
    E1_l = E1_p1*P1_l + E1_p2*P2_l; % chain rule
    E2_l = E2_p1*P1_l + E2_p2*P2_l;

end







