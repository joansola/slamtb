%% CNTRL + ENTER to execute (if you have cell mode activated)

% spherical size
s = rand/2;

% Gaussian
x = randn(2,1); % avoid singularity of fun() at x1 = 0. 
% x(2)=.5;
S = s*randn(2); P=S*S';
% P=[.01 0;0 .1];

% Linearity measures
q = linVec(@f21,x,P); % propagation error mean
Lv = norm(q)
Q = linMat(@f21,x,P); % quadratic Jacobian error
Lm = norm(Q)

% plots
%=======
% create a mesh for the NL function
ii = -3:.4:3;
jj = ii;
N = length(ii);
Z = zeros(N);
for i = 1:N
    for j = 1:N
        Z(j,i) = f21([ii(i);jj(j)]);
    end
end
cla
% Plot the NL function as a mesh
m = mesh(ii,jj,Z,'facealpha',0,'edgecolor','g','edgealpha',.5);
% adjust fig and axes properties
cameratoolbar('setmode','orbit')
axis equal
zlim([min(ii) max(ii)])
set(gcf,'renderer','opengl')
set(gca,'projection','perspective')
view(30,40)
% plot the ellipse projected on the surface
e = line;
f = line;
[ex,ey] = cov2elli(x,P,2,40); % the 2-d ellipse...
for i = 1:length(ex)
    ez(i) = f21([ex(i);ey(i)]); % ...projected to the surface of f21()
end
set(e,'xdata',ex,'ydata',ey,'zdata',ez+.05,'linewidth',2)
set(f,'xdata',ex,'ydata',ey,'zdata',ones(size(ez))*min(ii),'linewidth',1,'color','r')



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

