function aviobj = initAviFile(filename,fig,ax,newpos,opt)

% INITAVIFILE  Initialize video handle for AVI file.
%   FID = INITAVIFILE(FILE,FIG) open FILE for write access to
%   accept frames from FIG. File ID is returned as FID.
%
%   FID = INITAVIFILE(...,AX) indicates that only the contents on
%   the axes AX are used to generate frames. If AX = [] then the
%   whole figure is used, as above.
%
%   FID = INITAVIFILE(...,AX,NEWPOS) repositions the figure at
%   NEWPOS coordinates.
%
%   FID = INITAVIFILE(...,AX,NEWPOS,OPTIONS) accepts video
%   parameters to be entered in structure OPTIONS:
%     .fps         : frames per second (default is 15)
%     .compression : compressor used   (default is 'none')
%     .quality     : quality           (default is 100)
%   If any, then all fields in OPTIONS must be specified.
%
%   See also NEWFRAME, AVIFILE, GETFRAME, ADDFRAME

%  (c) 2006 Joan Sola @ LAAS-CNRS

% Scan all input options
if nargin >= 2
    figure(fig)
    frmh = fig;
    options.fps = 15;
    options.compression = 'none';
    options.quality = 100;

    if nargin >= 3
        if ~isempty(ax)
            frmh = ax;
        end

        if nargin >= 4
            if ~isempty(newpos)
                set(fig,'pos',newpos)
            end

            if nargin >= 5
                options = opt;

                if nargin > 5
                    error('Too many input arguments')
                end

            end
        end
    end
else
    error('Not enough input arguments')
end


% Do initialize video
aviobj             = avifile(filename);
aviobj.compression = options.compression;
aviobj.fps         = options.fps;
aviobj.quality     = options.quality;

% add one first frame
frm                = getframe(frmh);
aviobj             = addframe(aviobj,frm);


