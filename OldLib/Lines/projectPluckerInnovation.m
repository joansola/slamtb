function [i,Ic,Ik,Ili,Iy] = projectPluckerInnovation(C,k,Li,y)

% PROJECTPLUCKERINNOVATION  Innovation of projected Plucker line
%   PROJECTPLUCKERINNOVATION(C,K,Li,y)  projects the Plucker line Li into a
%   camera with intrinsic parameters K=[u0;v0;au;av] and at pose C=[t;q].
%   It then compares the result with measurement Y to produce the
%   innovation, as follows:
%       * Y is a homogeneous line in the image plane.
%       * The innovation is computed as the sinus of the angle between
%       measured and predicted planes (supporting the measured Y and
%       predicted Li lines).
%
%   [i,Ic,Ik,Ili,Iy] = ... returns Jacobians wrt C, K, Li and Y.

% (c) 2008 Joan Sola @ LAAS-CNRS

if nargout == 1

    L  = toFramePlucker(C,Li);
    n  = L(1:3);
    m  = aInvPinHolePlucker(k,y);
    i  = planes2sin(m,n);

else

    % line to camera frame; get support plane only.
    [L,Lc,Lli] = toFramePlucker(C,Li);
    n   = L  (1:3);
    Nc  = Lc (1:3,:);    
    Nli = Lli(1:3,:);
    
    % measurement support plane
    [m,Mk,My] = aInvPinHolePlucker(k,y);
    
    % sinus of innovation angle - SIA
    [i,Im,In] = sia(m,n);

    % Jacobians
    Ic  = In*Nc;
    Ili = In*Nli;    
    Ik  = Im*Mk;
    Iy  = Im*My;

end

