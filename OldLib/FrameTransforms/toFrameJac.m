function [Tf,Tp,F] = toFrameJac(F,p)

% TOFRAMEJAC  Jacobians of TOFRAME 
%   [Tf,Tp,F] = TOFRAMEJAC(F,P) gives the Jacobians of the
%   function TOFRAME() wrt. frame F and 3D point P.
%
% F is a structure containing at least:
%   X = [T;Q] : frame
%   Rt: transposed rotation matrix
%   Pc: Conjugated Pi matrix
%
%   See also TOFRAME, FROMFRAME, FROMFRAMEJAC

if (length(F.X)==7)

    sc = 2*F.Pc*(p-F.X(1:3));   % Conjugated s
    
    Tt = -F.Rt;
    Tq = [sc(2)  sc(1) -sc(4)  sc(3)
          sc(3)  sc(4)  sc(1) -sc(2)
          sc(4) -sc(3)  sc(2)  sc(1)];
    Tp = F.Rt;
    Tf = [Tt Tq];
    
else
    error('Input dimensions don''t agree')
end
