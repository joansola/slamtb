function Line = deletePluckerLine(Line)

% DELETEPLUCKERLINE  Delete Plucker Line
%   L = DELETEPLUCKERLINE(L)  sets the .used fiels of line structure Line
%   as free (not used). It also liberates the locations in the global map
%   Map indicated in the range L.r .
%
%   See also DELETEFROMMAP, INITPLUCKERLINE.

lr = Line.r;
Line.used = false;
deleteFromMap(lr);
