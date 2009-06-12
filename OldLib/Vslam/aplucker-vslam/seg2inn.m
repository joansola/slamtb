function [h,H_s] = seg2inn(seg,innSpace)

switch innSpace

    case {'uhm','rt'}
        [hm,HM_s]    = seg2hm(seg);
        [h,H_hm] = hm2inn(hm,innSpace);
        H_s          = H_hm*HM_s;

    case 'hh'
        h = [0;0];
        H_s = [eye(2) zeros(2)];

end
