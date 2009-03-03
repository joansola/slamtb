function varargout=splitMatrix(M)

ni = size(M,2);

if nargout > ni
    error('not enough rows in input matrix');
else
    for i = 1:nargout
        varargout{i}=M(:,i);
    end
end

