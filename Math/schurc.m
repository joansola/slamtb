function [S,iC] = schurc(M, m1, m2, sqrt)

% SCHURC Schur complement of a symmetric matrix.
%   SCHURC(M,R) returns the Schur complement of the block matrix of M
%   defined by the indices in the range R, that is, of M(R,R).
%
%   SCHURC(M,R,T) accepts the range T, the complement of R.
%
%   [S, iC] = SCHURC(...) returns also the inverse of the block matrix used
%   to compute the Schur complement, for its eventual reuse.
%
%   [Ss, iCs] = SCHURC(M,R,T,sqrt), with sqrt ~= 0, returns the square root
%   factors of S, and eventuall of iC, for their use in the solution of
%   systems of equations. If one of R or T are an empty array, but not
%   both, then the other one is computed internally by SCHURC. The square
%   root factors are equivalent to the Cholesky factorization, that is,
%
%       S  = Ss' * Ss
%       iC = iCs * iCs'  <-- mind the different order of transposes.
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
%       iC = M_11^-1
%
%   If M is positive, then using the Cholesky decomposition
%
%       M = [R_11' 0 ; R_12' R_22'] * [R_11 R_12 ; 0 R_22]
%
%   leads to
%
%       S  =  R_22' * R_22
%       iC = (R_11' * R_11)^-1 = R_11^-1 * R_11^-T
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
    if ~isempty(setdiff((1:n),[m1 m2]))
        error('??? Ranges do not cover the full matrix!')
    end
    if ~isempty(setdiff(m1,m2))
        error('??? Some indices in ranges R and T are repeated!')
    end
end

% Cholesky of the reordered block-matrix
R = chol(M([m1 m2],[m1 m2]));

% Compact ranges for the sqrt factors
n1 = numel(m1);
n2 = n-n1;
r1 = 1:n1;
r2 = n1 + (1:n2);

% Sqrt factors
S  = R(r2,r2);      % sqrt of Schur complement
iC = R(r1,r1)^-1;   % sqrt of inverse block

if nargin < 4 || ~sqrt
    
    % Return full version of Schur complement (normal behavior)
    S = S'*S;
    
    if nargout == 2
        iC = iC * iC';
    end
    
end
