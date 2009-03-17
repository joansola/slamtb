function F = updateFrame(F)

% UPDATEFRAME Update frame structure.
%   F = UPDATEFRAME(F)  updates the matrices R, Pi and Pc and the
%   vectors t, q, it and iq in the frame structure F. The only required
%   field in F is F.x, the 7-vector containing translation and orientation
%   quaternion of the frame F:
%
%       F.x = [t;q] = [x y z a b c d]'
%
%   where q = [a b c d]' must already be a unit vector.
%
%   As a result, the following fields are created/updated as follows:
%
%       F.t  = F.x(1:3);
%       F.q  = F.x(4:7);
%       F.R  = q2R(F.q);
%       F.Rt = F.R';
%       F.Pi = q2Pi(F.q);
%       F.Pc = pi2pc(F.Pi);
%       F.it = -F.R'*F.t;
%       F.iq = [1;-1;-1;-1].*F.q;
%
%   See also Q2R, Q2PI, PI2PC

% F.X(4:7) = F.X(4:7)/norm(F.X(4:7)); % normalize quaternion
F.t  = F.x(1:3);
F.q  = F.x(4:7);
F.R  = q2R(F.q);
F.Rt = F.R';
% F.Pi = q2Pi(F.q);
% F.Pc = pi2pc(F.Pi);
% F.it = -F.R'*F.t;
% F.iq = [1;-1;-1;-1].*F.q;

