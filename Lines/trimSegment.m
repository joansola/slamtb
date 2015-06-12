function e = trimSegment(s,imSize,mrg)

% TRIMSEGMENT  Trim segment at image borders
%   TRIMSEGMENT(S,IMSIZE) trims the segment S at the image borders
%   specified by IMSIZE. S is a 4-vector containing the two segment's
%   endpoints. IMSIZE is a 2-vector with the image dimensions in pixels,
%   IMSIZE = [HSIZE,VSIZE]. The output segment has the same orientation as
%   the input one.
%
%   TRIMSEGMENT(...,MRG) restricts the image size to be smaller in MRG
%   pixels at its four borders.
%
%   See also PINHOLESEGMENT.

%   (c) 2008-2009 Joan Sola @ LAAS-CNRS

% input segment's endpoints
a = s(1:2);
b = s(3:4);

% image witdh and height
[w,h] = split(imSize);

if nargin < 3
    insq = inSquare([a b],[0 w 0 h]);
else
    insq = inSquare([a b],[0 w 0 h],mrg);
end

if all(insq) % both endpoints are in the image

    e = s; % return the segment unchanged

else % at least one endpoint is out of the image

    H = pp2hmgLin(a,b); % homogeneous line
    L = [1; 0; 0];  % left image border
    R = [1; 0;-w];  % right
    T = [0; 1; 0];  % top
    B = [0; 1;-h];  % bottom

    % intersections of infinite line with infinite borders
    HL = intersectHmgLin(H,L,1);
    HR = intersectHmgLin(H,R,1);
    HT = intersectHmgLin(H,T,1);
    HB = intersectHmgLin(H,B,1);

    % bring to image borders
    i = 1;
    if inInterval(HL(2),[0,h])
        e(i:i+1,1) = HL;
        i = 3;
    end
    if inInterval(HR(2),[0,h])
        e(i:i+1,1) = HR;
        i = 3;
    end
    if inInterval(HT(1),[0,w])
        e(i:i+1,1) = HT;
        i = 3;
    end
    if inInterval(HB(1),[0,w])
        e(i:i+1,1) = HB;
    end

    if insq(1) % endpoint a is in the image

        p = e(1:2);
        q = e(3:4);

        u = b - a;
        v = p - a;
        if any(u./v > 0)
            e(1:2) = a;
            e(3:4) = p;
        else
            e(1:2) = a;
            e(3:4) = q;
        end

    elseif insq(2) % endpoint b is in the image

        p = e(1:2);
        q = e(3:4);

        u = a - b;
        v = p - b;
        if any(u./v > 0)
            e(1:2) = p;
            e(3:4) = b;
        else
            e(1:2) = q;
            e(3:4) = b;
        end

    else % no endpoint is inside the image

        if i == 1 % no intersection with image borders
            % Segment is not visible
            e = [];

        else
            p = e(1:2);
            q = e(3:4);

            if i==3 && any((p-a)./(b-p) > 0)  % segment is visible
                % check orientations

                u = b - a;
                v = q - p;
                if any(u./v < 0)
                    e = e([3 4 1 2]); % match orientations
                end
            else % segment is not visible
                e = [];
            end
        end

    end
end

return

%% test
imsize = [10 10];
s{1}  = [1 2 3 4]';
s{2}  = [-1 2 3 4]';
s{3}  = [1 -2 3 4]';
s{4}  = [1 2 -3 4]';
s{5}  = [1 2 3 -4]';
s{6}  = [1 2 3 11]';
s{7}  = [1 2 11 4]';
s{8}  = [1 11 3 4]';
s{9}  = [11 2 3 4]';
s{10} = [-1 -2 13 14]';
s{11} = [13 14 -1 -2]';

for i=1:numel(s)
    s{i}'
    (trimSegment(s{i},imsize))'
end

%% test
lmin = 10;
mrg = 0;
imSize = [640;480];
cla
lh = line('color','c','linewidth',3);
yh = line('color','r','linestyle','--')

%%
s = randn(4,1)*600

set(lh,'xdata',s([1,3]),'ydata',s([2,4]))

sv = trimSegment(s,imSize)

if isempty(sv)
    set(yh,'xdata',[],'ydata',[])
else
    set(yh,'xdata',sv([1,3]),'ydata',sv([2,4]))
end



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

