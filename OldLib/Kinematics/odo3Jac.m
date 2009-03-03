function [Xr,Qq,Xdx,Qde] = odo3Jac(Rob,dx,de)

% ODO3JAC Jacobian computation for ODO3 funciton
%   [Xr,Qq,Xdx,Qde] = ODO3JAC(Rob,dx,de) computes
%   all the non-zero Jacobians of ODO3.
%   Orientation in Rob is only possible in quaternion form.
%   Rob is a structure containing
%     X = [T;Q] : frame
%     R : rotation matrix
%     Pc: Conjugated Pi matrix
%     up : updated flag for matrices R and Pc
%     uPc : update flag for conjugated PI
%
%   [Fr,Fu] = ODO3JAC(R,dx,de) gives also
%   full Jacobians wrt state and odometry inputs u = [dx;de].

% x = Rq(1:3);  % robot position
% q = Rq(4:end);% robot orientation
% 
% R = q2R(q); % rotation matrix


Om = w2omega(de);

[Xr,Xdx] = fromFrameJac(Rob,dx); % fromFrame jacobians

Qq  = eye(4) + Om/2;
Qde = Rob.Pi/2;

if nargout == 2 % build full Jacobians
    Fr = [Xr;zeros(4,3) Qq];
    Fu = [Xdx zeros(3,3);zeros(4,3) Qde];
    
    Xr = Fr; % assign to output (names conflict)
    Qq = Fu;
end
