function [Rob,Lmk] = landmarkObservation(Rob,Cam,Lmk,Obs,MDth)

% LANDMARKOBSERVATION  EKF update after lm observation
%   [Rob,Lmk] = LANDMARKOBSERVATION(Rob,Cam,Lmk,Obs,MDth)
%   performs an ekf update to the blobal Map after the 
%   observation Obs of a landmark Lm from a robot Rob 
%   with a camera Cam.
%   Map is a global structure containing:
%     X:   state vector
%     P:   covariances matrix
%   Rob is a structure containing:
%     r:   the robot pose range in the state vector X
%   Cam is a structure containing:
%     C:   the camera pose in robot frame
%     cal: the intrinsic calibration parameters
%   Lmk is a structure containing:
%     loc: location in the state vector X
%     del: Output flag to delete the landmark
%   Obs is a structure containing:
%     y:   the measure
%     R:   the noise covariances matrix
%
%   EKF correction is only done if the mahalanobis distance
%   of the observation is lower than MDth. In the other case,
%   the landmark is marked for deletion.


global Map WDIM ODIM

if (nargin == 5) && (nargout == 2)
    
    % input data
    r   = Rob.r;
    pr  = loc2range(Lmk.loc);  % Lm range
    
    % map data
    p   = Map.X(pr); % Lm position in map
    
    % Expectation
    ye = robCamPhoto(Rob,Cam,p);
    
    % Jacobians
    [Hr,Hc,Hp] = robCamPhotoJac(Rob,Cam,p);
    
    % Innovations and Maha distance
    [z,Z,iZ] = blockInnovation(r,pr,Hr,Hp,Obs,ye);
    MD = z'*iZ*z;
    if MD > MDth
        % Landmark is very unlikely: mark to delete it!
        Lmk.del = 1;
    else
        Lmk.del = 0;
        Inn.z = z;
        Inn.Z = Z;
        Inn.iZ = iZ;
        
        % Map correction
        blockUpdateInn(r,pr,Hr,Hp,Inn,'symmet');
        
        % quaternion normalization
        qr = WDIM+1:WDIM+ODIM; % quat. range
        Map.X(qr) = Map.X(qr)/norm(Map.X(qr));
        
        % Robot pose and matrices update
        Rob.X = Map.X(r);
        updateFrame(Rob);
    end    
else
    error('Bad number of arguments')
end