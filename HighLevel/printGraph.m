function printGraph(Rob,Sen,Lmk,Trj,Frm,Fac)

global Map

fprintf('--------------------------\n')
sprs = round( ( nnz( Map.H(Map.used,Map.used) ) / sum(Map.used)^2 ) * 100);
fprintf('Map size: %3d; sparse: %d%%\n', sum(Map.used), sprs)
for rob = [Rob.rob]
    printRob(Rob(rob),1);
    for sen = Rob(rob).sensors
        printSen(Sen(sen),2);
    end
    printTrj(Trj(rob),2);
    for i = Trj(rob).head:-1:Trj(rob).head-Trj(rob).length+1
        frm = mod(i-1, Trj(rob).maxLength)+1;
        printFrm(Frm(frm),3);
        for fac = [Frm(frm).factors]
            printFac(Fac(fac),4);
        end
        
    end
    
end
for lmk = find([Lmk.used])
    printLmk(Lmk(lmk),1);
end
end


function tbs = tabs(k, tb)

if nargin == 1
    tb = '  ';
end

tbs = '';
for i = 1:k
    tbs = [tbs tb] ;
end
end


function printRob(Rob,ntabs)
fprintf('%sRob: %2d\n', tabs(ntabs), Rob.rob)
end
function printSen(Sen,ntabs)
fprintf('%sSen: %2d\n', tabs(ntabs), Sen.sen)
end
function printLmk(Lmk,ntabs)
fprintf('%sLmk: %2d (%2d)\n', tabs(ntabs), Lmk.lmk, Lmk.id)
end
function printTrj(Trj,ntabs)
fprintf('%sTrj: head <- %s <-tail\n', tabs(ntabs), num2str(mod((Trj.head:-1:Trj.head-Trj.length+1)-1,Trj.maxLength)+1))
end
function printFrm(Frm,ntabs)
fprintf('%sFrm: %2d (%3d)\n', tabs(ntabs), Frm.frm, Frm.id)
end
function printFac(Fac,ntabs)
fprintf('%sFac: %3d, %s', tabs(ntabs), Fac.fac, Fac.type(1:4))
if (isempty(Fac.lmk)) % abs or motion
    fprintf(', frm: ')
    fprintf('%3d', Fac.frames)
else % measurement
    fprintf(', lmk: %2d', Fac.lmk)
end
fprintf('\n')
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

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

