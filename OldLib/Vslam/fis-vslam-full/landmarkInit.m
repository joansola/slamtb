function Lmk = landmarkInit(Rob,Cam,Brg,Dpt)

% LANDMARKINIT  EKF-SLAM landmark initialization.
%   LANDMARKINIT(rob,Cam,BRNG,DPTH) 
%   performs landmark initializaiton to the global Map after 
%   the bearing observation BRNG of a landmark taken from a 
%   robot ROB with a camera CAM. Unobserved depth DPTH must be
%   supplied as an a-priori with a standard deviation not
%   bigger than 0.3 times its depth.
%
%   Map is a global structure containing:
%     X:   state vector
%     P:   covariances matrix
%     m:   map size (number of states)
%     n:   map size (number of landmarks)
%    free: free locations for landmarks
%    used: occupied locations
%   ROB is a structure containing:
%     r:   the robot pose range in the state vector X
%   CAM is a structure containing:
%     X:   the camera pose in robot frame
%     cal: the intrinsic calibraiton parameters
%   BRNG is a structure containing:
%     y:   the measure
%     R:   the noise covariances matrix
%   DPTH is a structure containing
%     s:   the nominal depth
%     S:   its variance, S <= (0.3*s)^2
%
%   LMK = LANDMARKINIT(...) allows
%   the updated landmark LMK as output. 
%
%   LMK is a structure containing:
%     loc: landmark location in the Map
%
%   The landmark is included in the lowest location. 
%   Existing data in that location is destroyed.
%
%   See also INVROBCAMPHOTO, INVROBCAMPHOTOJAC

global Map 

if ((nargin == 4) && (nargout <= 1)) 
    
    % input data
    m   = Map.m; % map nbr of states
    r   = Rob.r; % robot range
    y   = Brg.y;
    R   = Brg.R;
    s   = Dpt.s;
    S   = Dpt.S;
    % ...
    Rob.X  = Map.X(r);  % Robot pose in map
    
    Lmk.loc = getLoc; % get smallest location
    pr = loc2range(Lmk.loc);   % landmark range
    mr = [1:pr(1)-1 pr(end)+1:m]; % not-landmark range
    
    % relevant sub-maps
    Prr = Map.P(r,r); % co-variance
    Prm = Map.P(r,mr); % cross-variance
    
    % Jacobians
    [Gr,Gc,Gw,Gs] = invRobCamPhotoJac(Rob,Cam,y,s);
    
    % initialized landmark sub-maps
    p   = invRobCamPhoto(Rob,Cam,y,s);
    Ppp = Gr*Prr*Gr' + Gw*R*Gw' + Gs*S*Gs';
    Ppm = Gr*Prm;

    % Output
    Map.X(pr)    = p;
    Map.P(pr,mr) = Ppm;
    Map.P(mr,pr) = Ppm';
    Map.P(pr,pr) = Ppp;
    
    occupateMap(Lmk.loc);
    
else
    error('Bad number of arguments')
end
