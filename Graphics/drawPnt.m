function drawPnt(h,x,c)

% DRAWPNT  Draw 3D point with color.
%   DRAWPNT(H,X) Draw 2D or 3D point with handle H at position X.
%
%   DRAWPNT(H,X,C) uses color C.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if numel(x) == 2

    set(h,'xdata',x(1),'ydata',x(2),'vis','on')

elseif numel(x) == 3

    set(h,'xdata',x(1),'ydata',x(2),'zdata',x(3),'vis','on')

else

    error('??? Size of vector ''x'' not correct.')

end

if nargin == 3
    set(h,'color',c)
end







