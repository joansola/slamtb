function [rts,RTS_uvds] = uvds2rts(uvds)

% UVDS2RTS  Stereo segment to stereo rho theta conversion.
%   UVDS2RTS(UVDS)  converts the stereo segment given by the two stereo
%   endpoints in UVDS=[u v d u v d]' into a 4-vector containing the pair of
%   lines in rho-theta format, one for each image of the stereo image.
%
%   See also POINTS2RT.


if nargout == 1

    [e1L,e1R] = uvd2ee(uvds(1:3));
    [e2L,e2R] = uvd2ee(uvds(4:6));
    rts = [points2rt(e1L, e2L); points2rt(e1R, e2R)];

else

    [e1L,e1R] = uvd2ee(uvds(1:3));
    [e2L,e2R,EL_uvd,ER_uvd] = uvd2ee(uvds(4:6));
    %     EL_uvd = [1 0 0;0 1 0];
    %     ER_uvd = [1 0 -1;0 1 0];

    [rtL,RTL_e1L,RTL_e2L] = points2rt(e1L, e2L);
    [rtR,RTR_e1R,RTR_e2R] = points2rt(e1R, e2R);

    rts = [rtL ; rtR];

    RTS_uvd1 = [RTL_e1L*EL_uvd ; RTR_e1R*ER_uvd];
    RTS_uvd2 = [RTL_e2L*EL_uvd ; RTR_e2R*ER_uvd];

    RTS_uvds = [RTS_uvd1 RTS_uvd2];

end

return

%% numerical test
% uvds = [100;300;400;500;300;200];
uvds = [1;2;3;3;2;3];
[rts,RTS_uvds] = uvds2rts(uvds)

Ruvds = eye(6);
Rrts = RTS_uvds*Ruvds*RTS_uvds'
iRrts = Rrts^-1

Rrt1 = Rrts(1:2,1:2);
iRrt1 = Rrt1^-1
Rrt2 = Rrts(3:4,3:4);
iRrt2 = Rrt2^-1

mRrts = blkdiag(Rrt1,Rrt2)
imRrts = mRrts^-1

