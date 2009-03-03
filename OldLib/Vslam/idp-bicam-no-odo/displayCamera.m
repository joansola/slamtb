function  dispEstCam = displayCamera(dispEstCam,Rob,Cam)

% DISPLAYCAMERA  Dispaly camera graphics
%   CH = DISPLAYCAMERA(CH,Rob,Cam) updates graphics handle CH for a camera
%   Cam mounted on a robot Rob.

global WDIM

camBase = [0;0;0];
camSensor    = Cam.X(1:WDIM);
camPletine   = [camBase(1:2);camSensor(3)];
Cam.graphics = fromFrame(...
    Rob,...
    [camBase camPletine camSensor]);

set(dispEstCam,...
    'xdata'          ,Cam.graphics(1,:),...
    'ydata'          ,Cam.graphics(2,:),...
    'zdata'          ,Cam.graphics(3,:));
