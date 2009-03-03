function Ray = uRayInnovation(Ray,y,R)

% URAYINNOVATION  Ray innovation statistics
%   RAY = URAYINNOVATION(RAY) computes innovation statistics for
%   the ray RAY given the observation {y,R} and the expectations
%   included in RAY structure:
%     .u  : expectation
%     .U  : expectation covariance
%   The following RAY structure fields are updated:
%     .z  : innovation
%     .Z  : innovation covariance
%     .iZ : inverse of innovation covariance
%     .MD : Mahalanobis distance
%     .li : likelihood (without the 1/sqrt(2*pi) factor)
%
%   See also UINNOVATION

for p = 1:Ray.n
    [z,Z,iZ] = uInnovation(...
        y,...
        R,...
        Ray.u(:,p),...
        Ray.U(:,:,p));
    MD = z'*iZ*z;
    li = exp(-MD/2)/sqrt(det(Z));
    Ray.z(:,p)    = z;
    Ray.Z(:,:,p)  = Z;
    Ray.iZ(:,:,p) = iZ;
    Ray.MD(p) = MD; % Mahalanobis distance
    Ray.li(p) = li;
end

