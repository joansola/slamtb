function varargout = split(A)

% SPLIT  Split vectors into scalars, or matrices into row vectors.
%   [s1,s2,...,sn] = SPLIT(V), with V a vector, returns all its components
%   in scalars s1 ... sn. It is an error if numel(V) < nargout.
%
%   [v1,...,vn] = SPLIT(M), with M a matrix, returns its rows as separate
%   vectors v1 ... vn. It is an error if size(M,2) < nargout.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if min(size(A)) == 1
    % A is vector. We take row or column.
    ni = length(A);
    if nargout > ni
        error('not enough components in input vector');
    else
        for i = 1:nargout
            varargout{i} = A(i);
        end
    end
else
    % A is matrix. We split rows only.
    ni = size(A,2);
    if nargout > ni
        error('not enough rows in input matrix');
    else
        for i = 1:nargout
            varargout{i} = A(i,:);
        end
    end
end









