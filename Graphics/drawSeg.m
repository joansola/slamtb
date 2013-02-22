function drawSeg(h,x,c)

% DRAWSEG  Draw 2D or 3D segment with color.
%   DRAWSEG(H,S) Draws 2D or 3D segment S=[p1;p2] with handle H.
%
%   DRAWSEG(H,S,C) uses color C.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if numel(x) == 4

    set(h,'xdata',x([1 3]),'ydata',x([2 4]),'vis','on')

elseif numel(x) == 6

    set(h,'xdata',x([1 4]),'ydata',x([2 5]),'zdata',x([3 6]),'vis','on')

else

    error('??? Size of vector ''x'' not correct.')

end

if nargin == 3
    set(h,'color',c)
end







