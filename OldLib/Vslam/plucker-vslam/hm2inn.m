function [u,U_hm] = hm2inn(hm,innSpace,prj)

% HM2INN  Homogeneous to innovation space line conversion.
%   HM2INN(HM,INNSPACE)  converts the homogeneous 2D line HM to the space
%   defined by the string INNSPACE. Accepted values are
%       'uhm'   Unit homogeneous coordinates
%       'rt'    Rho-theta representation

switch innSpace
    case 'uhm'
        % normalized expectation
        [u,U_hm] = hm2uhm(hm);
    case 'rt'
        % rho-theta space
        [u,U_hm] = hm2rt(hm);
    case 'hh'
        [u,U_hm] = hms2hh(hm,prj.rawy);
        
end
