function sc = zncc(I,J,SI,SII,SJ,SJJ)

% ZNCC  Zero mean, Normalized Correlation Coefficient
%   ZNCC(I,J) computes the zncc score of matrices I and J:
%
%               1     sum( sum ( (I-mean(I)) * (J-mean(J)) ) )
%       ZNCC = --- * ------------------------------------------
%               N               std(I) * std(J)
%
%   where N = prod(size(I))
%   and   size(I) = size(J)
%
%   ZNCC(I,J,SI,SII,SJ,SJJ) accepts useful intermediate results
%   that permit to speed up the calculations. These are:
%
%     SI  = sum(sum(I))
%     SII = sum(sum(I.*I))
%     SJ  = sum(sum(J))
%     SJJ = sum(sum(J.*J))
%
%   See also PATCHCORR, SSD, CENSUS

switch nargin
    case 6
        SIJ = sum(sum(I.*J));
    case 5
        SJJ = sum(sum(I.*I));
        SIJ = sum(sum(I.*J));
    case 4
        SJ  = sum(sum(J));
        SJJ = sum(sum(J.*J));
        SIJ = sum(sum(I.*J));
    case 3
        SII = sum(sum(I.*I));
        SJ  = sum(sum(J));
        SJJ = sum(sum(J.*J));
        SIJ = sum(sum(I.*J));
    case {1,2}
        SI  = sum(sum(I));
        SII = sum(sum(I.*I));
        SJ  = sum(sum(J));
        SJJ = sum(sum(J.*J));
        SIJ = sum(sum(I.*J));
end

N = numel(I);

% This is the equivalent, faster formula than that given
% in the help section:
%
%   sc = (N*SIJ - SI*SJ)/sqrt((N*SII - SI^2)*(N*SJJ - SJ^2)+eps);
%
% we make a test on the variance of I and J to avoid degenerated cases

den = (N*SII - SI^2)*(N*SJJ - SJ^2);

if den < N
%     figure(5);image(J);colormap(gray(255));axis image
    sc = 0;
else
    sc = (N*SIJ - SI*SJ)/sqrt(den);
end


    



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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

