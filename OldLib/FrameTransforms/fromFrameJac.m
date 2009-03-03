function [Ff,Fp] = fromFrameJac(F,p)

% FROMFRAMEJAC  Jacobians of FROMFRAME 
%   [Ff,Fp] = FROMFRAMEJAC(F,P) gives the Jacobians of the
%   function FROMFRAME wrt. frame F and 3D point P.
%
% F is a structure containing:
%   X = [T;Q] : frame
%   R : rotation matrix
%   Pi: Pi matrix
%   up : updated flag for matrices R and Pi
%   uPi : update flag for PI
%
%   See also FROMFRAME, TOFRAME, TOFRAMEJAC

if (length(F.X)==7)

    s = 2*F.Pi*p;
    
    Ft = eye(3);
    Fq = [s(2) -s(1)  s(4) -s(3)
          s(3) -s(4) -s(1)  s(2)
          s(4)  s(3) -s(2) -s(1)];
    Fp = F.R;
    
    Ff = [Ft Fq];
    
else
    error('Input dimensions don''t agree')
end
