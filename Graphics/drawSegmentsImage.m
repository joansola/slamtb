function objHandle = drawSegmentsImage(O,color,lineWidth)

% DRAWSEGMENTSIMAGE  Draw segments 2D object.
%   DRAWSEGMENTSIMAGE(O)  plots all the segments in object O.
%
%   DRAWSEGMENTSIMAGE(O,C,L) uses segments of color C and width L.
%
%   H = DRAWSEGMENTSIMAGE(...) returns a vector H of line handles to each
%   segment in O.
%
%   See also HOUSE, DRAWSEGMENTSOBJECT.

%   (c) 2008 Joan Sola @ LAAS-CNRS

X = O([1 3],:);
Y = O([2 4],:);

if nargin < 3
     lineWidth = 1;
     if nargout < 2
         color = 'b';
     end
end

if nargout == 1

    objHandle = line(X,Y,'color',color,'lineStyle','-','linewidth',lineWidth);

else
    
    line(X,Y,'color',color,'lineStyle','-','linewidth',lineWidth);
    
end