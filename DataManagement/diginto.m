function diginto(thestruct, level)

% DIGINTO  Pretty print entire structure trees.
%   DIGINTO prints the fields tree of all structures in the workspace.
%
%   DIGINTO('all') is the same as DIGINTO.
%
%   DIGINTO(STR) pretty prints the fields' tree of structure STR.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin == 0 || strcmp(thestruct,'all')
    disp('Printing all structures in workspace ''base''.')
    w = evalin('base','whos');
    for i = 1:numel(w)
        if strcmp(w(i).class,'struct')
            disp(w(i).name)
            diginto(evalin('base',w(i).name))
        end
    end
    return
end

if nargin < 2
    level = 0;
end
if level == 0
    disp(inputname(1))
end

fn = fieldnames(thestruct);
for n = 1:length(fn)
    tabs = '';
    for m = 0:level
        tabs = [tabs '|   '];
    end
    disp([tabs '.' fn{n}])
    fn2 = thestruct.(fn{n});
    if isstruct(fn2)
        diginto(fn2, level+1);
    end
end










