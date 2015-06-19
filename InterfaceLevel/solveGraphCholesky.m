function [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphCholesky(Rob,Sen,Lmk,Obs,Frm,Fac)

global Map

for fac = [Fac([Fac.used]).fac]
    
    rob = Fac(fac).rob;
    sen = Fac(fac).sen;
    lmk = Fac(fac).lmk;
    frames = Fac(fac).frames;
    
    % Compute factor error, info mat, and Jacobians
    [Fac(fac), e, W, J1, J2, r1, r2] = computeError(Rob(rob),Sen(sen),Lmk(lmk),Obs(sen,lmk),Frm(frames),Fac(fac));
    
    % Compute sparse blocks
    H_11 = J1' * W * J1; 
    H_12 = J1' * W * J2; 
    H_22 = J2' * W * J2;
    
    % Compute sparse rhs
    b1 = J1' * W * e;
    b2 = J2' * W * e;
    
    Map.H(r1,r1) = Map.H(r1,r1) + H_11;
    Map.H(r1,r2) = Map.H(r1,r2) + H_12;
    Map.H(r2,r1) = Map.H(r2,r1) + H_12';
    Map.H(r2,r2) = Map.H(r2,r2) + H_22;
    
    Map.b(r1,1) = Map.b(r1,1) + b1;
    Map.b(r2,1) = Map.b(r2,1) + b2;
    
end

% Fix map used space by removing positions of unused frames
xu = Map.used.x;
xu([Frm([Frm.used]).state.r]) = false;
% TODO: WIP
% TIP: Free frames from having fixed ranges, and treat them dynamicall all
% the time.

% Column permutation 
p = colamd(Map.H(Map.used.x, Map.used.x))';

% Decomposition
% R = chol(Map.H(p,p));
% y = -R'\b(Map.p);
% dx(p) = R\y;

% Update
% Map.x = Map.x + dx;
