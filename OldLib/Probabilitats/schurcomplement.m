function S = schurcomplement(A,B,C,D,s)

% SCHURCOMPLEMENT Schur complement
%   SCHURCOMPLEMENT(A,B,C,D) returns the Schur complement of D in the matrix
%
%       M = [A  B
%            C  D]    (1)
%
%   which has the size of A and is defined by:
%
%       S_D = A - B*D^-1*C
%
%   If D is not given the matrix M is supposed block-symmetric as follows:
%
%       M = [A  B
%            B' C]    (2)
%
%   SCHURCOMPLEMENT(A,B,C,D,s) allows the selection of the matrix which is
%   complemented. s=1 is the default case above. s=2 gives the Schur
%   complement of matrix A in M, that is:
%
%       S_A = D - C*A^-1*B
%
%   Other values of s will produce an error. Provide D=[] if the input case
%   (2) above is desired.

switch nargin
    case 3
        D = C;
        C = B';
        s = 1;
    case 4
        s = 1;
    case 5
        if isempty(D)
            D = C;
            C = B';
        end
end

[ra,ca] = size(A);
[rb,cb] = size(B);
[rc,cc] = size(C);
[rd,cd] = size(D);

if (ra~=ca) || (rd~=cd) || (cb~=cd) || (rb~=ra) || (rc~=rd) || (cc~=ca)
    error('Matrices sizes don''t match')
end

switch s
    case 1
        S = A - B*D^-1*C;
    case 2
        S = D - C*A^-1*B;
    otherwise
        error('Complement type argument ''s'' should be 1 or 2')
end

