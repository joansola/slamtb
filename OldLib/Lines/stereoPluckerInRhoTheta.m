function [rtrt,RTRT_l] = stereoPluckerInRhoTheta(StHead,L)

% STEREOPLUCKERINRHOTHETA Plucker stereo projection, rho-theta outputs.
%   STEREOPLUCKERINRHOTHETA(SH,L)  Projects the Plucker line L into the two
%   images of the stereo head SH. The result is a 4-vector with stacked
%   rho-theta representations of the lines in the left and right images.
%
%   [rtrt,RTRT_l] = STEREOPLUCKERINRHOTHETA(...) returns the Jacobians wrt L.
%
%   See also STEREOPLUCKER, HM2RT.

if nargout == 1

    hmhm = stereoPlucker(StHead,L);

    rtrt(1:2,1) = hm2rt(hmhm(1:3));
    rtrt(3:4,1) = hm2rt(hmhm(4:6));

else % jac

    [hmhm,HMHM_l] = stereoPlucker(StHead,L);

    [rtrt(1:2,1),RTL_hml] = hm2rt(hmhm(1:3));
    [rtrt(3:4,1),RTR_hmr] = hm2rt(hmhm(4:6));

    RTRT_hmhm = [RTL_hml zeros(2,3);zeros(2,3) RTR_hmr];

    RTRT_l = RTRT_hmhm*HMHM_l;

end

return

%% jac

syms n1 n2 n3 v1 v2 v3 real
syms u0 v0 au av a real
L = [n1;n2;n3;v1;v2;v3];
StHead.cal = [u0;v0;au;av];
StHead.alpha = a;

[rtrt,RTRT_l] = stereoPluckerInRhoTheta(StHead,L);

simplify(RTRT_l - jacobian(rtrt,L))

%%
L = [0;1;0;1;0;0]; % this is a horizontal 3D line, parallel to the image planes.
StHead.cal = [100;100;100;100];
StHead.alpha = 100;

[rtrt,RTRT_l] = stereoPluckerInRhoTheta(StHead,L) % this is the 2-rhotheta projected lines
P=rand(6);
P=P*P'; % this is a generic covariances matrix, positive and symmetric
HPHt=RTRT_l*P*RTRT_l' % this is the covariances matrix HPHt
inv(HPHt) % it is not invertible
