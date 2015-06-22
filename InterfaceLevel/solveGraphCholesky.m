function [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphCholesky(Rob,Sen,Lmk,Obs,Frm,Fac)

global Map

% Compute Jacobians for projection onto the manifold
for rob = [Rob.rob]
    for frm = [Frm(rob,[Frm(rob,:).used]).frm]
        q = Frm(rob,frm).state.x(4:7);
        Frm(rob,frm).state.M = [eye(3), zeros(3,3) ; zeros(4,3) q2Pi(q)];
    end
end
for lmk = [Lmk([Lmk.used]).lmk]
    switch Lmk(lmk).type
        case 'hmgPnt'
            w = Lmk(lmk).state.x(4); % Homogeneous part
            Lmk(lmk).state.M = [w*eye(3) ; 0 0 0];
        otherwise
            error('??? Unknown landmark type ''%s'' or Jacobian not implemented.',Lmk.type)
    end
end

% Reset Hessian and rhs vector
Map.H = 0*Map.H;
Map.b = 8*Map.b;

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
    
    % Re-condition lmks with only 1 observation 
    % Note: this is to handle single bearing-only's 
    if strcmp(Fac(fac).type, 'measurement') && numel(Fac(fac).frames) == 1
        H_22 = H_22 + eye(size(H_22));
    end
    
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

% Column permutation 
p = colamd(Map.H(Map.used, Map.used))';

% Decomposition
R = chol(Map.H(p,p));
y = -R'\Map.b(p);
dx(p,1) = R\y;
% Update Map
Map.x(Map.used) = dx;

% Update Map
% Map.x = Map.x (+) dx;
for rob = [Rob.rob]
    for frm = [Frm(rob,[Frm(rob,:).used]).frm]
        % TODO: Compose (++) state and error state
        % Frm.state.x = Frm.state.x ++ Map.x(Frm.state.r)
        Frm(rob,frm) = updateKeyFrm(Frm(rob,frm));
    end
end
for lmk = [Lmk([Lmk.used]).lmk]
    switch Lmk(lmk).type
        case 'hmgPnt'
        % TODO: Compose (++) state and error state
        % Lmk.state.x = Lmk.state.x ++ Map.x(Lmk.state.r)
        otherwise
            error('??? Unknown landmark type ''%s'' or Jacobian not implemented.',Lmk.type)
    end
end

