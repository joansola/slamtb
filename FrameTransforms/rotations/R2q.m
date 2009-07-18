function q = R2q(R)

% R2Q  rotation matrix to quaternion conversion.
%
%   See also QUATERNION, Q2R, Q2E, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



T = trace(R) + 1;

if isa(T,'sym') || ( T > 0.00000001 )  % to avoid large distortions!

    S = 2 * sqrt(T);
    a = 0.25 * S;
    b = ( R(2,3) - R(3,2) ) / S;
    c = ( R(3,1) - R(1,3) ) / S;
    d = ( R(1,2) - R(2,1) ) / S;

else
    if ( R(1,1) > R(2,2) && R(1,1) > R(3,3) ) 
        % Column 1:
        % tested with R2 = diag([1 -1 -1])
        
        S  = 2 * sqrt( 1.0 + R(1,1) - R(2,2) - R(3,3) );
        a = (R(2,3) - R(3,2) ) / S;
        b = 0.25 * S;
        c = (R(1,2) + R(2,1) ) / S;
        d = (R(3,1) + R(1,3) ) / S;
        
    elseif ( R(2,2) > R(3,3) )               
        % Column 2:
        % tested with R3 = [0 1 0;1 0 0;0 0 -1]
        
        S  = 2 * sqrt( 1.0 + R(2,2) - R(1,1) - R(3,3) );
        a = (R(3,1) - R(1,3) ) / S;
        b = (R(1,2) + R(2,1) ) / S;
        c = 0.25 * S;
        d = (R(2,3) + R(3,2) ) / S;
        
    else
        % Column 3:
        % tested with R4 = [-1 0 0;0 0 1;0 1 0]
        
        S  = 2 * sqrt( 1.0 + R(3,3) - R(1,1) - R(2,2) );
        a = (R(1,2) - R(2,1) ) / S;
        b = (R(3,1) + R(1,3) ) / S;
        c = (R(2,3) + R(3,2) ) / S;
        d = 0.25 * S;

    end
end

q = [a -b -c -d]';



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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

