function [x,P,H,H1] = deupdate(x,P,x1,P1,F,h,y,R)

% DEUPDATE Delayed state EKF update (non linear)
%   [X,P] = DEUPDATE(X,P,X1,P1,F,@h,Y,R) performs an update to the Gaussian 
%   estimate {X,P} when the following nonlinear measurement arrives:
%
%       Y(k) = h(x(k),x(k-1)) + v
%
%   where 
%       v is a white Gaussian noise with cov. R
%       {X,P} is the current estimate, of x(k)
%       {X1,P1} is the delayed estimate, of x(k-1)
%       h() is the measurement function. It must be defined so that 
%           [e,H,H1] = h(x,x1) gives the output e and both H and H1,  
%           Jacobians of h() wrt x and x1.
%       F is the Jacobian of the prediction function  x(k+1) = f(x(k)) + w
%
%   [X,P,H,H1] = DEUPDATE(...) returns the Jacobians of h() wrt X and X1.
%
%   See also KPREDICT, KUPDATE, DUPDATE, EPREDICT, DVO

% Expectation and Jacobians
[e,H,H1] = h(x,x1); 

% Innovation
z = y - e; 
Z = H*P*H' + H1*P1*F'*H' + H*F*P1*H1' + H1*P1*H1' + R;

% Kalman gain
K = (P*H' + F*P1*H1')/Z; 

% Updates
x = x + K*z; 
P = P - K*Z*K';
