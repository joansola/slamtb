function [xm, xa, py, par, complete] = splitPap( pap )
%SPLITPAP splits the a pap point into its components

if size(pap,1) == 5
    xm  = pap(1:3,:);
    xa  = [];
    py  = pap(4:5,:);
    par = [];
    complete = false;
elseif size(pap,1) == 9
    xm  = pap(1:3,:);
    xa  = pap(4:6,:);
    py  = pap(7:8,:);
    par = pap(9,:);
    complete = true;
else
    error('Invalid size ''%s'' for pap point.', size(pap,1));
end

end

