function aviobj = videoFrame(aviobj,fig,ax)

% VIDEOFRAME  Adds new frame to AVI file.
%   FID = VIDEOFRAME(FID,FIG) adds the graphics contents of FIG as
%   a new frame to AVI object FID.
%
%   FID = VIDEOFRAME(FID,FIG,AX) uses the contents of axes AX in
%   figure FIG instead.
%
%   See also INITVIDEO, ADDFRAME, GETFRAME, AVIFILE

figure(fig)
if nargin < 3
    frmh = fig;
else
    frmh = ax;
end

% drawnow
frm = getframe(frmh);
aviobj = addframe(aviobj,frm);
