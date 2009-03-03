function E = essential(t,R)

% ESSENTIAL  Essential matrix
%   ESSENTIAL(T,R) is the essential matrix hat(T)*R.
%
%   where:
%     T,R   are the translation vector and rotation matrix defining the
%           pose of camera 2 with respect to camera 1.
%
%   See also HAT, FUNDAMENTAL, TOFRAME, FROMFRAME.

E = hat(t)*R;

