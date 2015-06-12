function kc = invDistortion(kd,n,cal,draw)

% INVDISTORTION  Radial distortion correction calibration.
%
%   Kc = INVDISTORTION(Kd,n) computes the least squares optimal set
%   of n parameters of the correction radial distortion function
%   for a normalized camera:
%
%     r = c(rd) = rd (1 + c2 rd^2 + ... + c2n rd^2n)
%
%   that best approximates the inverse of the distortion function
%
%     rd = d(r) = r (1 + d2 r^2 + d4 r^4 + ...)
%
%   which can be of any length.
%
%   Kc = INVDISTORTION(Kd,n,cal) accepts the intrinsic parameters
%   of the camera  cal = [u_0, v_0, a_u, a_v].
%
%   The format of the distortion and correction vectors is
%
%     Kd = [d2, d4, d6, ...]
%     Kc = [c2, c4, ..., c2n]
%
%   Kc = INVDISTORTION(...,DRAW) with DRAW~=0 additionally plots the
%   distortion and correction mappings r_d=d(r) and r=c(r_d)
%   and the error (r - r_d).
%
%   See also PINHOLE, INVPINHOLE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if numel(kd) == 0
    kc = [];
else

    if nargin == 2 || isempty(cal)
        cal = [1 1 1 1];
    end

    % fprintf('  Obtaining correction vector from distortion vector...');
    rmax2 = (cal(1)/cal(3))^2 + (cal(2)/cal(4))^2;
    rmax  = sqrt(rmax2); % maximum radius in normalized coordinates

    rdmax = 1.1*rmax;
    % N=101 sampling points of d(r)
    rc = [0:.01*rdmax:rdmax]; % rc is the undistorted radius vector
    rd = c2d(kd,rc); % rd is the distorted radius vector


    % 1. non-linear least-squares method (for other than radial distortion)
    % comment out for testing against psudo-inverse method
    % x0 = zeros(1,n);
    % kc = lsqnonlin(@(x) fun(x,rc,rd),x0);

    % 2. pseudo-inverse method (indicated for radial distortion)
    % we solve the system A*Kc = rc-rd via Kc = pinv(A)*(rc-rd).

    A  = []; % construction of A for Kc of length n
    for i = 1:n
        A  = [A  rd'.^(2*i+1)];
    end

    B  = pinv(A);
    kc = (rc-rd)*B'; % All transposed because we are working with row-vectors

    % fprintf(' OK.\n');

    if nargin == 4 && draw

        % normalized error
        erc = d2c(kc,rd);

        % correction and distortion functions
        figure(9)
        subplot(3,1,[1 2])
        plot(rc,rd,'linewidth',2)
        title('Distortion mapping'),xlabel('r'),ylabel('rd'),grid
        set(gca,'xlim',[0 rdmax])

        hold on
        plot(erc,rd,'r--','linewidth',2)
        hold off

        % error function (in pixels)
        subplot(3,1,3)
        plot(rc,cal(3)*(rc-erc))
        title('Correction error [pix]'),xlabel('r'),ylabel('error'),grid
        set(gca,'xlim',[0 rdmax])

        % error values
        err_max  = cal(3)*max (abs(rc-erc));
        err_mean = cal(3)*mean(rc-erc);
        err_std  = cal(3)*std (rc-erc);
        fprintf(1,'  Errors. Max: %.2f | Mean: %.2f | Std: %.2f pixels.\n',err_max,err_mean,err_std)

    end

end


% Necessary functions

% corr- to dis- conversion
function rd = c2d(kd,rc)
c = ones(1,length(rc));
for i=1:length(kd)
    c = c+kd(i)*rc.^(2*i);
end
rd = rc.*c;

% dis- to corr- conversion
function rc = d2c(kc,rd)
c = ones(1,length(rd));
for i=1:length(kc)
    c = c+kc(i)*rd.^(2*i);
end
rc = rd.*c;

% error function (only for non-linear least squares - normally
% not necessary)
function e = fun(kc,rc,rd)
e = d2c(kc,rd) - rc;



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

