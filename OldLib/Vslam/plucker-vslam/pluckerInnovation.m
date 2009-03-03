function Obs = pluckerInnovation(Obs,Cam,Line,innSpace)

% PLUCKERINNOVATION  Plucker line innovation.
%   OBS = PLUCKERINNOVATION(OBS,CAM,LINE,INNSPACE) computes
%   innovation-related statistics for an observation of a line LINE from a
%   camera CAM. 
%
%   The input observation OBS contains the fields 
%       .rawy  The measurement as given by the segment tracker
%       .rawR  Its covariances matrix.
%
%   CAM is also a structure containing at least fields .r and .cal
%   containing the camera pose range in the global map Map and the
%   intrinsic calibration parameters. The camera pose is therefore
%   Map.X(CAM.r).
%
%   LINE is the line structure containing at least the field .r with the
%   range in the global map Map where its Plucker coordinates are stored.
%   The plucker line is therefore Map.X(LINE.r).
%
%   INNSPACE  is a string indicating the innovation space used.
%   Possibilities are:
%       'uhm'   Unit homogeneous coordinates
%       'rt'    Rho-theta line representation
%       'hh'    Orthogonal endpoints-to-line distances
%
%   The output observation structure OBS is a copy of the input one, with
%   the following fields updated:
%       .y  The measurement in the innovation space
%       .R  The measurement's cov. mat.
%       .u  The expectation
%       .U  The expectation's cov. mat.
%       .z  The innovation
%       .Z  The innovation's cov. mat.
%       .iZ The inverse of the innovation's cov. mat.
%       .MD The square of the Mahalanobis distance
%       .Hc The jacobian of the obs. function wrt the camera pose.
%       .Hk The jacobian of the obs. function wrt the camera intrinsic params.
%       .Hl The jacobian of the obs. function wrt the plucker coordinates.
%
%   See also PROJECTPLUCKER, SEG2HM, SEG2RT, SEG2UHM, HM2UHM, HM2RT, HMS2HH.



global Map

rawy = Obs.rawy;
rawR = Obs.rawR;

lr = Line.r;
cr = Cam.r;
r = [cr lr];

line = Map.X(lr);
P_c_l = Map.P(r,r);

[hm,HM_c,HM_k,HM_l] = projectPlucker(Cam.X,Cam.cal,line);
HM_c_l = [HM_c HM_l];
HM = HM_c_l * P_c_l * HM_c_l';

switch lower(innSpace)
    case 'uhm'
        % measurement
        [y,Y_rawy] = seg2uhm(rawy);
        R          = Y_rawy*rawR*Y_rawy';

        % expectation
        [u,U_hm] = hm2uhm(hm);
        H_c   = U_hm*HM_c;
        H_k   = U_hm*HM_k;
        H_l   = U_hm*HM_l;
        H_c_l = [H_c H_l];
        U  = H_c_l * P_c_l * H_c_l';
        
        % make homogeneous vectors match directions
        if dot(y,u) < 0
            y = -y;
        end

        % innovation
        z  = y - u;
        Z  = U + R;

        % Fill specific fields on output structure
        Obs.y  = y;
        Obs.R  = R;
        Obs.u  = u;
        Obs.U  = U;
        Obs.dU = det(U);

    case 'rt'
        % measurement
        [y,Y_rawy] = seg2rt(rawy);
        R          = Y_rawy*rawR*Y_rawy';

        % expectation
        [u,U_hm] = hm2rt(hm);
        H_c   = U_hm*HM_c;
        H_k   = U_hm*HM_k;
        H_l   = U_hm*HM_l;
        H_c_l = [H_c H_l];
        U = H_c_l * P_c_l * H_c_l';

        % take care of rho sign and half turns close to origin
        inn  = y - u;
        innt = round(inn(2)/pi);
        y(2) =  y(2) - innt*pi; % bring to small angle
        if isodd(innt)
            y(1) = -y(1);       % change rho sign
            disp('sign changed')
        end

        % innovation
        z = y - u;
        Z = U + R;

        % Fill specific fields on output structure
        Obs.y  = y;
        Obs.R  = R;
        Obs.u  = u;
        Obs.U  = U;
        Obs.dU = det(U);

    case 'hh'
        % innovation is measured directly
        [z,Z_hm,Z_rawy] = hms2hh(hm,rawy);
        Z_c   = Z_hm*HM_c;
        Z_k   = Z_hm*HM_k;
        Z_l   = Z_hm*HM_l;
        Z_c_l = [Z_c Z_l];

        Z  = Z_c_l * P_c_l * Z_c_l' + Z_rawy * rawR * Z_rawy';

        % Jacobians of measurement for future Kalman calculations:
        H_c = -Z_c;
        H_k = -Z_k;
        H_l = -Z_l;

        % Fill specific fields on output structure
        Obs.y  = rawy;
        Obs.R  = rawR;
        Obs.u  = hm;
        Obs.U  = [HM_c HM_l]*P_c_l*[HM_c HM_l]';
        Obs.dU = det(Obs.U);

end

iZ = inv(Z);
MD = z'*iZ*z;

% Fill output Obs structure
Obs.Hc = H_c;
Obs.Hk = H_k;
Obs.Hl = H_l;
Obs.hm = hm;
Obs.HM = HM;
Obs.z  = z;
Obs.Z  = Z;
Obs.iZ = iZ;
Obs.MD = MD;
