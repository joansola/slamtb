function varargout=splitVector(v)

ni = length(v);

if nargout > ni
    error('not enough components in input vector');
else
    for i = 1:nargout
        varargout{i}=v(i);
    end
end

