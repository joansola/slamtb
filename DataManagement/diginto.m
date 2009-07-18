function diginto(thestruct, level)

% DIGINTO  Pretty print entire structure tree.
%    DIGINTO(STR) pretty prints the fields' tree of structure STR.
%
%    DIGINTO('all') prints all structures in the workspace.

if strcmp(thestruct,'all')
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




% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

