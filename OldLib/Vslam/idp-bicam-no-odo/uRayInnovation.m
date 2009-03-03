function Ray = uRayInnovation(Ray,prj,y,R)

% URAYINNOVATION  Ray innovation statistics
%   RAY = URAYINNOVATION(RAY,PRJ,Y,R) computes innovation statistics
%   of the projection PRJ of the ray RAY given the observation
%   {Y,R} and the expectations and RAY.Prj(PRJ) structure:
%     .u  : expectations
%     .U  : expectation covariances
%   The following RAY.Prj(PRJ) structure fields are updated:
%     .z  : innovations
%     .Z  : innovation covariances
%     .iZ : inverses of innovation covariances
%     .MD : Mahalanobis distances
%     .li : likelihood (without the 1/sqrt(2*pi) factor)
%
%   See also UINNOVATION

for p = 1:Ray.n
    [z,Z,iZ] = uInnovation(...
        y,...
        R,...
        Ray.Prj(prj).u(:,p),...
        Ray.Prj(prj).U(:,:,p));

    MD = z'*iZ*z;     % Mahalanobis distance
    Ray.Prj(prj).z(:,p)    = z;
    Ray.Prj(prj).Z(:,:,p)  = Z;
    Ray.Prj(prj).iZ(:,:,p) = iZ;
    Ray.Prj(prj).MD(p) = MD; 
    Ray.Prj(prj).li(p) = exp(-MD/2)/sqrt(det(Z));
end

