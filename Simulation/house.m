function H = house(x,y,z,l,w,h)

% HOUSE  House made out of segments.
%   HOUSE(X,Y,Z,L,W,H) is a 6-by-23 matrix made of 23 segments desingning a
%   house. Each segment consists of its two 3D endpoints, stacked, forming
%   a 6-vector. The frontal lower right corner is located at (X,Y,Z). The
%   house dimmensions are L x W x H (Length, Width and Height). 
%
%   The default position is [X,Y,Z] = [0,0,0]. 
%   The default dimmensions are [L,W,H] = [5,5,4].
%
%   The house's facade has the following appearance:
%
%         _       H
%        / \      |    House proportions in % of dimensions W and H:
%       /   \     |
%      /     \    |      a  20 % of W
%     /       \   |      b  40
%    /         \  r      c  60
%    |  _   _  |  q      d  80
%    | | | | | |  |
%    | | | |_| |  p      p  25 % of H
%    | | |     |  |      q  50
%    |_|_|_____|  0      r  65
%                
%    W-d-c-b-a-0
%
%
%   To plot the house h, use plot3(h([1 4],:),h([2 5],:),h([3 6],:)) or the
%   function DRAWSEGMENTSOBJECT.
%
%   To locate the house h at frame F = [t;q] use
%       h_F = [toFrame(F,h(1:3,:));toFrame(F,h(4:6,:))]
%   or the function TOFRAMESEGMENT.
%
%   To project the house into a pin-hole camera, use PINHOLESEGMENT.
%
%   See also DRAWSEGMENTSOBJECT, TOFRAMESEGMENT, PINHOLESEGMENT.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch nargin
    case 0
        [x,y,z] = deal(0);
        l = 5;
        w = 5;
        h = 4;
    case {1,2}
        error('??? House position not fully specified')
    case 3
        l = 5;
        w = 5;
        h = 4;
    case {4,5}
        error('??? House dimensions not fully specified')
end


a = .2;
b = .4;
c = .6;
d = .8;

p = .25;
q = .5;
r = .65;

H = zeros(6,23);
% 4 walls
H(:, 1)    = zSegment   (x  ,y  ,z,z+r*h); 
H(:, 2)    = zSegment   (x+l,y  ,z,z+r*h);
H(:, 3)    = zSegment   (x+l,y+w,z,z+r*h);
H(:, 4)    = zSegment   (x  ,y+w,z,z+r*h);

% floor
H(:,5:8)   = XYRectangle(x,x+l,y,y+w,z); 

% roof slopes
H(:, 9)    = makeSegment([x;y    ;z+r*h],[x;y+w/2;z+h    ]); 
H(:,10)    = makeSegment([x;y+w/2;z+h    ],[x;y+w  ;z+r*h]);
H(:,11)    = makeSegment([x+l;y    ;z+r*h],[x+l;y+w/2;z+h    ]); 
H(:,12)    = makeSegment([x+l;y+w/2;z+h    ],[x+l;y+w  ;z+r*h]);

% roof
H(:,13)    = xSegment   (x,x+l   ,y+.5*w,z+h);   % top
H(:,14)    = xSegment   (x,x+l   ,y     ,z+r*h); % lower ends
H(:,15)    = xSegment   (x,x+l   ,y+w   ,z+r*h); 

% door
H(:,16:19) = YZRectangle(x,y+c*w,y+d*w,z,z+q*h); 

% window
H(:,20:23) = YZRectangle(x,y+a*w,y+b*w,z+p*h,z+q*h); 



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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

