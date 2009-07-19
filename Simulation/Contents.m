% Functions specific for simulating scenarios.
%
% 3D objects (with edges information)
%   obj2pnts          - Get points matrix from 3D object.
%   obj2segs          - Get segments matrix from 3D object.
%
% 3D patches (objects without edges information)
%   camGraphics       - Create a camera graphics 3D object.
%   camSimpleGraphics - Create a simple camera graphics 3D object.
%   swing             - Create a graphics structure with a wing shape.
%   thickVehicle      - Create a vehicle graphics 3D object.
%   wing              - Create a wing graphics 3D object.
%
% 3D points (3-by-N matrices)
%   obj2pnts          - Get points matrix from 3D object.
%   cloister          - Generates features in a 2D cloister shape.
%   thickCloister     - Generates features in a 3D cloister shape.
%
% 3D segments (6-by-N matrices)
%   obj2segs          - Get segments matrix from 3D object.
%   makeSegment       - Make a segment out of two endpoints
%   xSegment          - Horizontal segment in the X direction
%   ySegment          - Horizontal segment in the Y direction
%   zSegment          - Vertical segment
%   XYRectangle       - Rectangle in the XY plane.
%   XZRectangle       - Rectangle in the XZ plane.
%   YZRectangle       - Rectangle in the YZ plane.
%   house             - House made out of segments.
