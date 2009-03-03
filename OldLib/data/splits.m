function varargout = splits(A)

if min(size(A)) == 1
    % A is vector. We take row or column.
    ni = length(A);
    if nargout > ni
        error('not enough components in input vector');
    else
        for i = 1:nargout
            varargout{i}=A(i);
        end
    end
else
    % A is matrix. We split rows only.
    ni = size(M,2);
    if nargout > ni
        error('not enough rows in input matrix');
    else
        for i = 1:nargout
            varargout{i}=A(:,i);
        end
    end
end
