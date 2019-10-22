% JR Right Jacobian of SO3
%   JR(theta) gives the right Jacobian of SO3.
%
%   The formula is taken from Chirikjian, vol 2, pag 40:
%       Applied and Numerical Harmonic Analysis, Gregory S. Chirikjian
%       -Stochastic Models, Information Theory, and Lie Groups, 
%       Volume 2_ Analytic Methods and Modern Applications-Birkh?user Basel 
%       2012
%
%   (c) 2018 Joan Sola

function J_r = Jr(theta)

t2 = theta'*theta;  % angle squared

W  = hat(theta);    % skew symmetric matrix
    
if t2 > 1e-12       % that is, t > 1e-6
    
    t = sqrt(t2);   % angle
    c = cos (t);
    s = sin (t);
    
    J_r = eye(3) - ((1 - c)/t2) * W + ((t - s)/(t2*t)) * W * W;

else                % small-angle approximation
    
    J_r = eye(3) - 0.5*W;
    
end
