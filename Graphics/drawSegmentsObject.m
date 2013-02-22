function objHandle = drawSegmentsObject(O,color,lineWidth)

% DRAWSEGMENTSOBJECT  Draw segments object.
%   DRAWSEGMENTSOBJECT(O)  plots all the segments in object O.
%
%   DRAWSEGMENTSOBJECT(O,C,L) uses segments of color C and width L.
%
%   H = DRAWSEGMENTSOBJECT(...) returns a vector H of line handles to each
%   segment in O.
%
%   See also HOUSE, DRAWSEGMENTSIMAGE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

X = O([1 4],:);
Y = O([2 5],:);
Z = O([3 6],:);

if nargin < 3
     lineWidth = 1;
     if nargout < 2
         color = 'b';
     end
end

if nargout == 1

    objHandle = line(X,Y,Z,'color',color,'lineStyle','-','linewidth',lineWidth);

else
    
    line(X,Y,Z,'color',color,'lineStyle','-','linewidth',lineWidth);
    
end








