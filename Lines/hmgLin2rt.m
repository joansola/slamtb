function [rt,RThm] = hmgLin2rt(hm)

% HMGLIN2RT  Homogeneous to rho-theta line expression in the plane.
%   HMGLIN2RT(HM) converts the homogeneous line HM to its rho-theta
%   representation.
%
%   [rt,RT_hm] = HMGLIN2RT(...) returns the Jacobian wrt HM.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if ~isa(hm,'sym') && hm(3) > 0
    hm2 = -hm;
    s = -1;
else
    hm2 = hm;
    s = 1;
end

[a,b,c] = split(hm2);

r2 = dot([a,b],[a,b]);
r  = sqrt(r2);

ct  =  a/r;
st  =  b/r;
rho = -c/r;

if isa(hm2,'sym')
    theta = atan(st/ct);
else
    theta = atan2(st,ct);
end

rt = [rho;theta];

if nargout > 1

    r3 = r*r2;

    RThm = s * [...
        [ a*c/r3, b*c/r3,  -1/r]
        [  -b/r2,   a/r2,     0]];

end

return

%%

syms a b c real
hm = [a;b;c];

[rt] = hmgLin2rt(hm)

%%
RThm = jacobian(rt,hm)

simplify(RThm - jacobian(rt,hm))

%%
clc
hm = [-1;1;1];
[rt,RThm] = hmgLin2rt(hm)
[rt,RThm] = hmgLin2rt(-hm)

hm = [1;-1;1];
[rt,RThm] = hmgLin2rt(hm)
[rt,RThm] = hmgLin2rt(-hm)


%% incremental jacobian
clc
dx = 1e-10;
l0 = -[1;2;3];
[rt0,RTl0] = hmgLin2rt(l0);
RTl = zeros(2,3);
for i = 1:3
    l = l0;
    l(i) = l(i) + dx;
    rt = hmgLin2rt(l);
    RTl(:,i) = (rt-rt0)/dx;
end
rt0;
RTl
RTl0



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

