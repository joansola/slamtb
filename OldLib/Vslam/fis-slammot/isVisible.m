function vis = isVisible(Cam,Pnt,mrg)

% ISVISIBLE  visibility check
%   V = ISVISIBLE(CAM,PNT) is true if point P is visible from
%   camera CAM (that is, if it is in front and inside the
%   camera's field of view)
%
%   V = ISVISIBLE(CAM,PNT,MRG) is true if the point PNT is
%   visible and at less tnan MRG pixels from the image margins.
%   Usually we set MRG to be the patch size used for correlation
%   scans. Setting MRG = -1 automatically gets the patch size
%   from the PNT structure

if nargin == 2
   mrg = 0;
elseif mrg == -1
   mrg  = size(Pnt.sig.I,1); % patch size pixels margin
end

cam = Cam.id;
u = Pnt.Prj(cam).u;

isze = Cam.imSize; % Image size in horizontal and vertical notation
inIm = inSquare(u,[0 isze(1) 0 isze(2)],mrg);
vis  = inIm & front;
