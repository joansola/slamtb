function imgFrame(fig,file,ax)

% IMGFRAME  Exports figure graphics to image file.
%   IMGFRAME(FIG,FILE) creates from the graphics contents of FIG 
%   a image file FILE.
%
%   IMGFRAME(FIG,FILE,AX) uses the contents of axes AX in
%   figure FIG instead.
%
%   Examples:
%       imgFrame(1,'image.png',gca) exports the current axes in figure 1.
%       imgFrame(gcf,'image.png') exports the current figure.
%       imgFrame(1,sprintf('image-%03d.png',t)) for loops governed by index
%           t, exports the figure 1 at time t. Use it to make movies.
%
%   See also GETFRAME, FRAME2IM, IMWRITE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% figure(fig)
if nargin < 3
    frmh = fig;
else
    frmh = ax;
end

% drawnow
frm = getframe(frmh);
im  = frame2im(frm);
imwrite(im,file);










