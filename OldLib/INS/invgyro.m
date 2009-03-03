function [w,Wm,Wb,Wq,Wwe] = invgyro(wm,bg,q,wE)

% INVGYRO  Get angular rate from gyrometer readings
%   INVGYRO(WM,BG) gets the current angular rates given sensor readings WM
%   and sensor biases BG.
%
%   [W,Wm,Wb] = ... returns the Jacobian wrt measurements and biases.
%
%   This is the inverse of the measurement function GYRO:
%
%       Wm = A + B + ng
%
%   where ng is additive white noise
%
%   INVGYRO(WM,BG,Q,WE) accepts local orientation Q and local Earth
%   rotation WE. Full jacobians are returned also for theese entries. The
%   measurement function is
%
%       Wm = W + q2R(Q)'*WE + B
%
%   See also GYRO, SPREDICT, QPREDICT

% OK jacobians 10/01/2007 @ Joan Sola


if nargin == 2
    
    w = wm - bg;
    
    if nargout > 1 % Jacobians
        Wm  = eye(3);
        Wb  = -eye(3);
        if nargout > 3
            Wq  = zeros(3,4);
            Wwe = zeros(3);
        end
    end
    
elseif nargin == 4
    
    [wB,WBq,WBwe] = Rtp(q,wE);
    
    w = wm - wB - bg;
    
    if nargout > 1 % Jacobians
        Wm  = eye(3);
        Wq  = -WBq;
        Wb  = -eye(3);
        Wwe = -WBwe;
    end
    


else
    error('bad number of input arguments')
end
