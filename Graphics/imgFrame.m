function imgFrame(fig,file,ax)

% IMGFRAME  Writes frame to image file.
%   IMGFRAME(FIG,FILE) creates from the graphics contents of FIG 
%   a image file FILE.
%
%   IMGFRAME(FIG,FILE,AX) uses the contents of axes AX in
%   figure FIG instead.

figure(fig)
if nargin < 3
    frmh = fig;
else
    frmh = ax;
end

% drawnow
frm = getframe(frmh);
im  = frame2im(frm);
imwrite(im,file);

