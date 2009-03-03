function [x,P] = dupdate(x,P,x1,P1,F,H,H1,y,R)

% DUPDATE Delayed state KF update (linear)
%   [X,P] = DUPDATE(X,P,X1,P1,F,H,H1,Y,R) performs an update to the Gaussian 
%   estimate {X,P} when the following linear measurement arrives:
%
%       Y(k) = H*x(k) + H1*x(k-1) + v
%
%   where 
%       v is a white Gaussian noise with cov. R
%       {X,P} is the current estimate, of x(k)
%       {X1,P1} is the delayed estimate, of x(k-1)
%       H, H1 are the measurement matrices
%       F is the prediction matrix in x(k+1) = F*x(k) + w
%
%   See also KPREDICT, KUPDATE, DEUPDATE, EPREDICT

% Innovation
z = y - (H*x + H1*x1);
Z = H*P*H' + R + H1*P1*F'*H' + H*F*P1*H1' + H1*P1*H1';

% Kalman gain
K = (P*H' + F*P1*H1')/Z;

% Updates
x = x + K*z;
P = P - K*Z*K';
