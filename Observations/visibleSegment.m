function [sv,vis] = visibleSegment(s,d,imSize,mrg,lmin)

% VISIBLESEGMENT  Visible segment.
%   VISIBLESEGMENT(S,D,IMSIZE) returns the segment portion of segment S
%   that is visible in the image defined by IMSIZE. D is a vector of depths
%   of the two segment's endpoints.
%
%   VISIBLESEGMENT(...,MRG) restricts the image size to be smaller in MRG
%   pixels at its four borders. The default is MRG = 0 pix.
%
%   VISIBLESEGMENT(...,LMIN) sets all segments shorter than LMIN pixels to
%   be invisible. The default is LMIN = 1 pix.
%
%   [SV,VIS] = VISIBLESEGMENT(...) returns the visible segment SV and a
%   flag of visibility. In case of non visibility, the flag is set to false
%   and the output segment is SV = [0;0;0;0].
%
%   The function works for segment matrices S = [S1 S2 ... Sn] and D = [D1
%   D2 ... Dn], giving a segments matrix SV and a visibility vector VIS.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


% input options and defaults
if nargin < 5
    lmin = 1;
    if nargin < 4
        mrg = 0;
    end
end

% init output arrays
n   = size(s,2);
sv  = zeros(4,n);
vis = false(1,n);

% loop all segments
for i = 1:n
    a = s(1:2,i); % endpoints
    b = s(3:4,i);
    ad = d(1,i);  % depths
    bd = d(2,i);

    if ad<0 && bd<0 % both depths negative -> not visible
        sv(:,i) = zeros(4,1);
        vis(i) = false;

    else

        u = normvec(b-a); % uncorrected direction
        if ad<0           % endpoint A is behind the camera
            a = b + 1e6*u;
        elseif bd<0       % endpoint B is behind the camera
            b = a - 1e6*u;
        end

        % trim segment at image borders, with margin
        ss = trimSegment([a;b],imSize,mrg);

        % check visibility and assign output
        if ...  % conditions for visibility (add with AND if needed)
                ~isempty(ss) ...           % no-null vector
                && (segLength(ss) >= lmin) % minimum length
            
            sv(:,i) = ss; % visible
            vis(i) = true;
        end
    end
end

return

%% test - generate 2 line handles
lmin = 10;
mrg = 0;
imSize = [100;100];
cla
axis([0,imSize(1),0,imSize(2)])
lh = line('color','r','linestyle','--')
yh = line('color','c','linewidth',3);

%% test - plot random lines
s = 300+randn(4,1)*400
% d = randn(2,1)

s = [-20;50;120;50]
d = [-1;-1]

[sv,vis] = visibleSegment(s,d,imSize,mrg,lmin)

set(lh,'xdata',s([1,3]),'ydata',s([2,4]))
set(yh,'xdata',sv([1,3]),'ydata',sv([2,4]))



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

