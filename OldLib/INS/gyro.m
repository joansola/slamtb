function [wm,Ww,Wbg,Wq,Wwe] = gyro(w,bg,q,wE)

% GYRO Gyrometer readings
%   GYRO(W,B) gives the readings of a gyrometer when it is subject to an
%   angular velocity W. B is the sensor bias.
%
%   [WM,Ww,Wb] = GYRO(...) returns the readings WM and the Jacobians Ww,
%    and Wb with respect to W and B.
%
%   The measurement function is:
%
%       Wm = W + B + ng
%
%   where ng is additive white noise
%
%   GYRO(W,B,Q,WE) accepts local orientation Q and local Earth rotation WE.
%   Full jacobians are returned also for theese entries. The measurement
%   function is
%
%       Wm = W + q2R(Q)'*WE + B
%
%   See also INVGYRO, ACC

% OK jacobians

if nargin == 2

    wm = w + bg;

    if nargout > 1 % Jacobians
        Ww  = eye(3);
        Wbg = eye(3);
    end

elseif nargin == 4

    [RtwE,RTWEq,RTWEwe] = Rtp(q,wE);
    
    wm = w + RtwE + bg;

    if nargout > 1 % Jacobians
        Ww  = eye(3);
        Wbg = eye(3);
        Wwe = RTWEwe;
        Wq  = RTWEq;
    end
end
