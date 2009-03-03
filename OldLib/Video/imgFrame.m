function imgFrame(fig,file,ax)

% IMGFRAME  Adds new frame to AVI file.
%   VIDEOFRAME(FIG,FILE) creates from the graphics contents of FIG 
%   a image file FILE.
%
%   VIDEOFRAME(FIG,FILE,AX) uses the contents of axes AX in
%   figure FIG instead.
%
%   See also VIDEOFRAME

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

