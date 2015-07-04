function err = checkGraphIntegrity(Lmk,Frm,Fac)

err = 0;

for fac = find([Fac.used])
    for frm = Fac(fac).frames
        if all(Frm(frm).factors ~= fac)
            fprintf('Fac %d has Frm %d but not viceversa\n', fac, frm)
            err = 1;
        end
    end
    for lmk = Fac(fac).lmk
        if all(Lmk(lmk).factors ~= fac)
            fprintf('Fac %d has Lmk %d but not viceversa\n', fac, lmk)
            err = 2;
        end
    end
    
end

for frm = find([Frm(1,:).used])
    for fac = Frm(frm).factors
        if all(Fac(fac).frames ~= frm)
            fprintf('Frm %d has Fac %d but not viceversa\n', frm, fac)
            err = 3;
        end
    end
end

for lmk = find([Lmk.used])
    for fac = Lmk(lmk).factors
        if all(Fac(fac).lmk ~= lmk)
            fprintf('Lmk %d has Fac %d but not viceversa\n', lmk, fac)
            err = 4;
        end
    end
end

for fac = find(~[Fac.used])
    if ~isempty(Fac(fac).frames)
        fprintf('Fac %d is not used but has frames %d\n', fac, Fac(fac).frames)
        err = 5;
    end
    if ~isempty(Fac(fac).lmk)
        fprintf('Fac %d is not used but has lmk %d\n', fac, Fac(fac).lmk)
        err = 6;
    end
end

for frm = find(~[Frm.used])
    if ~isempty(Frm(frm).factors)
        fprintf('Frm %d is not used but has factors %d\n', frm, Frm(frm).factors)
        err = 7;
    end
end

 
for lmk = find(~[Lmk.used])
    if ~isempty(Lmk(lmk).factors)
        fprintf('Lmk %d is not used but has factors %d\n', lmk, Lmk(lmk).factors)
        err = 7;
    end
end

if err
    err
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

