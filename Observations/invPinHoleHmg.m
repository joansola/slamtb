function [p, Pk, Ppixhm, Pnob] = invPinHoleHmg(k,pixhm,nob)

% INVPINHOLEHMG Inverse pin-hole camera model for HMG.
%   P = INVPINHOLEHMG(K,PIXHM,NOB) gives the retroprojected HMG point P of
%   a hmg pixel pixhm at depth nob (NOB is actually the inverse depth), from a
%   canonical pin-hole camera, that is, with calibration parameters K. [P,
%   PK, PPIXHM, PNOB] = ... returns the Jacobians wrt RF.x, SF.x, SK, SC, U
%   and N.
%
%   See also INVINTRINSIC.

iK = invIntrinsic(k);

if numel(pixhm) == 2
    pix = [pixhm(:);1];
else
    pix = pixhm;
end

p = [iK*pix;nob];

if nargout > 1 % we want Jacobians
    
    [u0,v0,au,av] = split(k);
    [u,v,w] = split(pix);

    Pk = [...
        [        -1/au*w,              0, (-u+u0*w)/au^2,              0]
        [              0,        -1/av*w,              0, (-v+v0*w)/av^2]
        [              0,              0,              0,              0]
        [              0,              0,              0,              0]];
    Ppixhm = [iK;0 0 0];
    Pnob = [0;0;0;1];

    if numel(pixhm) == 2
        Ppixhm = Ppixhm(:,1:2);
    end
end

return

