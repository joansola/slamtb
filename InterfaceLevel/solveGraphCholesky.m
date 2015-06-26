function [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphCholesky(Rob,Sen,Lmk,Obs,Frm,Fac)

global Map


% LM algorithm
lambda = 0.001;
err = 0;
derr = 0;
target_derr = 1e-7;
up = 10;
down = 1/10;
nit = 10;

for it = 1:nit
    
    % Map range
    mr = find(Map.used);
    n = numel(mr); % matrix dimension
    
    % Reset Hessian and rhs vector
    Map.H(mr,mr) = 0*Map.H(mr,mr);
    Map.b(mr) = 0*Map.b(mr);
    
    % Compute Jacobians for projection onto the manifold
    [Rob,Frm,Lmk] = computeStateJacobians(Rob,Frm,Lmk);
    
    % Build Hessian and rhs vector
    Fac = buildProblem(Rob,Sen,Lmk,Obs,Frm,Fac);
        
%     Map.H(mr,mr) = symmetrize(Map.H(mr,mr)); % TODO: To be removed once things work OK.
    
    % Column permutation
    p = colamd(Map.H(mr,mr))';
    
    % Permutated map range
    pr = mr(p);
    
    mult = 1 + lambda;
    ill = true;
    
    while ill && (it <= nit)
        
        % Damp Hessian
        h = spdiags(diag(Map.H(pr,pr)),0,n,n);
        Map.H(pr,pr) = Map.H(pr,pr) * mult * h;
        
        % Decomposition
        [Map.R, ill] = chol(Map.H(pr,pr));
        
        if ~ill
            % Solve for dx
            y = -Map.R'\Map.b(pr);
            dx(p,1) = Map.R\y;
            Map.x(mr) = dx;
            
            newerr = computeResidual(Rob,Sen,Lmk,Obs,Frm,Fac);
            derr = newerr - err;
            ill = (derr > 0);
            
        end
        
        if ill
            mult =  (1 + lambda*up) / (1 + lambda);
        	lambda = lambda * up;
            it=it+1;
        end

    end
    
    lambda = lambda * down;
    
    if ( (~ill) && (-derr<target_derr) ) 
        break;
    end
    
end

% % Some displays
% [mr,p,pr]
% max(ans)
figure(3);
spy(Map.H(mr,mr));

y = -Map.R'\Map.b(pr);
dx(p,1) = Map.R\y;
% Update Map
Map.x(mr) = dx;

% Update Map
% Map.x = Map.x (+) dx;
[Rob,Lmk,Frm] = updateStates(Rob,Lmk,Frm);


disp('-----------------------')



end

function [Rob,Frm,Lmk] = computeStateJacobians(Rob,Frm,Lmk)

% COMPUTESTATEJACOBIANS Compute Jacobians for projection onto the manifold.

for rob = [Rob.rob]
    for frm = [Frm(rob,[Frm(rob,:).used]).frm]
        q = Frm(rob,frm).state.x(4:7);
        Frm(rob,frm).state.M = [eye(3), zeros(3,3) ; zeros(4,3) q2Pi(q)];
    end
end
for lmk = [Lmk([Lmk.used]).lmk]
    switch Lmk(lmk).type
        case 'eucPnt'
            Lmk(lmk).state.M = 1; % trivial Jac
        case 'hmgPnt'
            [~,~,H_dh] = composeHmgPnt(Lmk(lmk).state.x, zeros(3,1));
            Lmk(lmk).state.M = H_dh;
        otherwise
            error('??? Unknown landmark type ''%s'' or Jacobian not implemented.',Lmk.type)
    end
end
end

function [Fac] = buildProblem(Rob,Sen,Lmk,Obs,Frm,Fac)

% BUILDPROBLEM Build least squares problem's matrix H and vector b

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
    
    % Compute rhs
    b1 = J1' * W * e;
    b2 = J2' * W * e;
    
    % Update H and b
    Map.H(r1,r1) = Map.H(r1,r1) + H_11;
    Map.H(r1,r2) = Map.H(r1,r2) + H_12;
    Map.H(r2,r1) = Map.H(r2,r1) + H_12';
    Map.H(r2,r2) = Map.H(r2,r2) + H_22;
    
    Map.b(r1,1) = Map.b(r1,1) + b1;
    Map.b(r2,1) = Map.b(r2,1) + b2;
    
end

end

function [Rob,Lmk,Frm] = updateStates(Rob,Lmk,Frm)

% UPDATESTATES Update Frm and Lmk states based on computed error.

global Map

for rob = [Rob.rob]
    for frm = [Frm(rob,[Frm(rob,:).used]).frm]
        Frm(rob,frm) = updateKeyFrm(Frm(rob,frm));
    end
end
for lmk = [Lmk([Lmk.used]).lmk]
    switch Lmk(lmk).type
        case 'hmgPnt'
            % TODO: Compose (++) state and error state
            % Lmk.state.x = Lmk.state.x ++ Map.x(Lmk.state.r)
        case 'eucPnt'
            % Trivial composition -- no manifold stuff
            Lmk(lmk).state.x = Lmk(lmk).state.x + Map.x(Lmk(lmk).state.r);
        otherwise
            error('??? Unknown landmark type ''%s'' or Jacobian not implemented.',Lmk.type)
    end
end

end

function r = computeResidual(Rob,Sen,Lmk,Obs,Frm,Fac)

[Rob,Lmk,Frm] = updateStates(Rob,Lmk,Frm);

r = 0;

for fac = [Fac([Fac.used]).fac]
    
    rob = Fac(fac).rob;
    sen = Fac(fac).sen;
    lmk = Fac(fac).lmk;
    frames = Fac(fac).frames;
    
    % Compute factor error, info mat, and Jacobians
    [Fac(fac), e, W] = computeError(Rob(rob),Sen(sen),Lmk(lmk),Obs(sen,lmk),Frm(frames),Fac(fac));
    
    r = r + e' * W * e;
    
end

end


% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

