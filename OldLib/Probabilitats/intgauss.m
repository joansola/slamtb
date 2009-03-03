function i = intgauss(s,n)

% INTGAUSS  Computes the integral of a Gaussian distribution
%   INTGAUSS(S) gives the integral of the normalized gaussian
%   function from x=-S to x=S. Normalized means zero-mean, 
%   unit-variance.
%
%   INTGAUSS(S,N) considers a normalized N-dimensional Gaussian
%   distribution and the spherical integration region of radius
%   S. Only valid for N=2 and N=3 by now.


if nargin == 1
    n = 1;
end

dr = .01;

i=0;

for r = .5*dr:dr:s
    if n==1
        c = 2;
    elseif n==2
        c = 2*pi*r;
    elseif n==3
        c = 4*pi*r^2;
    end
    f = sqrt(2*pi)^(-n)*exp(-r^2/2);
%     f = gauss(r,0,1);
    i = i+c*f*dr;
end



