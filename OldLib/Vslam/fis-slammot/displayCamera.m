function  dispEstCam = displayCamera(dispEstCam,Rob,Cam)

global WDIM

camBase = [0;0;0];
for c = 1:length(Cam)
    camSensor    = Cam(c).X(1:WDIM);
    camPletine   = [camBase(1:2);camSensor(3)];
    Cam(c).graphics = fromFrame(...
        Rob,...
        [camBase camPletine camSensor camPletine]);
end
camGraph = [Cam.graphics];

set(dispEstCam,...
    'xdata'          ,camGraph(1,:),...
    'ydata'          ,camGraph(2,:),...
    'zdata'          ,camGraph(3,:));
