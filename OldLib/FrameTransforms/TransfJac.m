% TRANSFJAC Symbolic computation and test of jacobians
%   It is a script - it takes no arguments. It works only
%   for quaternion representations of orientations. 
%   It performs the following actions:
%     1. Computes all jacobians of TOFRAME and FROMFRAME.
%     2. Calls coded functions for the same jacobians
%     3. Checks for equality.
%   Remove end-of-line semicolons in script to show 
%   the desired results.
%
%   See also TOFRAME, FROMFRAME, TOFRAMEJAC, FROMFRAMEJAC.

format compact

syms a b c d real
syms u v w real
syms x y z real

t   = [u v w]';  % translation vector
q   = [a;b;c;d]; % rotation quaternion
p   = [x y z]';  % 3D point
F.X = [t;q];     % Reference frame
F   = updateFrame(F);

% True jacobians from symbolic computation
p_F = toFrame(F,p);

TTt = jacobian(p_F,t);
TTq = jacobian(p_F,q);
TTp = jacobian(p_F,p);

p_W = fromFrame(F,p);

FFt = jacobian(p_W,t);
FFq = jacobian(p_W,q);
FFp = jacobian(p_W,p);

% Jacobians from coded functions
[Tf,Tp] = toFrameJac(F,p);
Tt = Tf(:,1:3);
Tq = Tf(:,4:end);
[Ff,Fp] = fromFrameJac(F,p);
Ft = Ff(:,1:3);
Fq = Ff(:,4:end);

% Equality test. Should result in null matrices.
ETt = simplify(TTt-Tt)
ETq = simplify(TTq-Tq)
ETp = simplify(TTp-Tp)

EFt = simplify(FFt-Ft)
EFq = simplify(FFq-Fq)
EFp = simplify(FFp-Fp)

format loose