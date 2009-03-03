function [p,Pc,Pp,Ps] = invCamPhoto(cam,pix,s)

% INVCAMPHOTO Retroproject a photo from a camera
%   P = INVCAMPHOTO(CAM,PIX,S) retroprojects a pixel taken
%   from a camera CAM to obtain a point P in space
%   at range S. CAM is a structure with camera frame CAM.C
%   and calibration parameters CAM.cal.
%   Frame C must be specified in a vector containing:
%     translation vector t
%     orientation quaternion q
%
%   [p,Pc,Pp,Ps] = INVCAMPHOTO(...) gives the Jacobians wrt CAM, PIX and S



if nargout < 2

    % retroprojected point in camera frame
    pc = invPinHole(pix,s,cam);
    p = fromFrame(cam,pc);


else % we want jacobians

    % retroprojected point in camera frame
    [pc,PCw,PCs] = invPinHole(pix,s,cam);


    [p,Pc,Ppc] = fromFrame(cam,pc);

    %     [PCw,PCs] = invPinHoleJac(pix,s,cam);

    % Output Jacobians
    Pp = Ppc*PCw;
    Ps = Ppc*PCs;

end

