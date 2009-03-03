function Idp = idpMapInit(Rob,Cam,Brg,Idpt)

% IDPMAPINIT  EKF-SLAM inverse depth ray initialization in Map.
%   IDPMAPINIT(ROB,CAM,BRNG,IDPT) performs landmark initializaiton to the
%   global Map after the bearing observation BRNG of a landmark taken from
%   a robot ROB with a camera CAM. Unobserved inverse depth IDPT must be
%   supplied as an a-priori with a standard deviation allowing the ray to
%   reach infinity at 1-sigma (that is, sigma is equal to the inverse depth
%   value).
%
%   Map is a global structure containing:
%     .X:   state vector
%     .P:   covariances matrix
%     .m:   map size (number of states)
%     .n:   map size (number of landmarks)
%     .free: free 3D locations for landmarks (each IDP ray will occupy 2 3D
%    landmarks)
%     .used: occupied locations
%   ROB is a structure containing:
%     .r:   the robot pose range in the state vector X
%   CAM is a structure containing:
%     .X:   the camera pose in robot frame
%     .cal: the intrinsic calibraiton parameters
%   BRNG is a structure containing:
%     .y:   the measure
%     .R:   the noise covariances matrix
%   IDPT is a structure containing
%     .rho:   the nominal inverse depth
%     .RHO:   its variance, RHO ~= rho^2
%
%   IDP = IDPMAPINIT(...) allows
%   the updated landmark LMK as output. IDP is then a structure containing:
%     .loc: 2-vector with the IDP location in the Map:
%       .loc(1): the position of the IDP initial point x0
%       .loc(3): the position of the 2 angles plus the inverse depth
%
%   The IDP is included in the lowest locations available.
%   Existing data in that locations is destroyed.
%
%   See also IDPINIT, INVIDPROBCAMPHOTO

global Map

if ((nargin == 4) && (nargout <= 1))

    % input data
    m   = Map.m; % map nbr of states
    r   = Rob.r; % robot range
    y   = Brg.y;
    R   = Brg.R;
    i   = Idpt.rho;
    I   = Idpt.RHO;
    % ...
    if Rob.X ~= Map.X(r)
        warning('Robot poses in Rob and Map structures do not match.')
        Rob.X  = Map.X(r); % force use of Map values.
    end

    Idp.loc(1) = getLoc; % get smallest location available in Map
    occupateMap(Idp.loc(1));
    Idp.loc(2) = getLoc; % get next smallest location
    occupateMap(Idp.loc(2));    
    ir = loc2range(Idp.loc);   % Idp range
    mr = [1:ir(1)-1 ir(3)+1:ir(4)-1 ir(6)+1:m]; % not-landmark range

    % relevant sub-maps
    Prr = Map.P(r,r);  % robot co-variance
    Prm = Map.P(r,mr); % robot-map cross-variance

    % Jacobians
    [idp,IDPr,IDPc,IDPw,IDPi] = invIdpRobCamPhoto(Rob,Cam,y,i);

    % initialized landmark sub-maps
    Pii = IDPr*Prr*IDPr' + IDPw*R*IDPw' + IDPi*I*IDPi';
    Pim = IDPr*Prm;

    % Output
    Map.X(ir)    = idp;
    Map.P(ir,mr) = Pim;
    Map.P(mr,ir) = Pim';
    Map.P(ir,ir) = Pii;


else
    error('Bad number of arguments')
end
