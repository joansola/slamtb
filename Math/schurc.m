function [S,iA] = schurc(M, m1, m2, sqrt)

% SCHURC Schur complement of a symmetric matrix.
%   SCHURC(M,R) returns the Schur complement of the block matrix of M
%   defined by the indices in the range R, that is, of M(R,R).
%
%   SCHURC(M,R,T) accepts the range T, the complement of R. It is an error
%   if T is not the complement of R. If one of R or T are an empty array,
%   but not both, then the other one is computed internally by SCHURC.
%
%   Ss = SCHURC(M,R,T,sqrt), with sqrt ~= 0, returns the square root factor
%   of S, for its use in the solution of systems of equations. The square
%   root factor Ss is equivalent to the Cholesky factorization, that is,
%
%       S  = Ss' * Ss
%
%   [S, iA] = SCHURC(...) returns also the inverse of the block matrix
%   used to compute the Schur complement, for its eventual reuse.
%
%   [Ss, iA] = SCHURC(M,R,T,sqrt), with sqrt ~= 0, returns the square root
%   factors of S, for their use in the solution of systems of
%   equations. The optional output iA is not factored
%
%   ----------------------------------------------------------------
%
%   Definitions and rationale:
%
%   If M is a symmetrical matrix partitioned as
%
%       M = [M_11 M_12 ; M_12' M_22]
%
%   then the Schur complement of M_11 is
%
%       S = M_22 - M_12' * M_11^-1 * M_12
%
%   The optionally returned inverse block is just
%
%       iA = M_11^-1
%
%   whose name comes from 'inverse of A', A given by the popular partition
%   of M = [A B; B' C], therefore A = M_11.
%
%   If M is symmetrical and positive, then using the Cholesky decomposition
%
%       M = [R_11' 0 ; R_12' R_22'] * [R_11 R_12 ; 0 R_22]
%
%   leads to
%
%       S  =  R_22' * R_22
%       iA = (R_11' * R_11)^-1 = R_11^-1 * R_11^-T
%
%   which constitutes an efficient and stable way to compute the Schur
%   complement. The square root factors R_22 and R_11^-1 can be obtained by
%   setting the optional flag sqrt.
%
%   See also CHOL.

%   Copyright 2015-     Joan Sola @ IRI-UPC-CSIC.

n = size(M,1);

% Complementary range
if nargin < 3 || isempty(m2)
    m2 = setdiff(1:n, m1);
elseif isempty(m1)
    m1 = setdiff(1:n, m2);
else
    
    % Test ranges integrity
    if ~isempty(setdiff((1:n),[m1;m2]))
        error('??? Ranges do not cover the full matrix!')
    end
%     if ~isempty(setdiff(m1,m2))
%         error('??? Some indices in ranges R and T are repeated!')
%     end
end

% Cholesky of the reordered block-matrix
R = chol(M([m1;m2],[m1;m2]));

% Compact ranges for the sqrt factors
n1 = numel(m1);
n2 = n-n1;
r1 = 1:n1;
r2 = n1 + (1:n2);

% Sqrt factors
S  = R(r2,r2);      % sqrt of Schur complement
iA = R(r1,r1)^-1;   % sqrt of inverse block
iA = iA * iA';      % inverse block

if nargin < 4 || ~sqrt
    
    % Return full version of Schur complement (normal behavior)
    S = S'*S;
    
end
