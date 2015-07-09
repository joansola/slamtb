function [X,Y,Z] = factorLines(A,xyz)

[i,j] = find(A);
[~, p] = sort(max(i,j));
i = i(p);
j = j(p);

if ~isempty(xyz)
    X = [ xyz(i,1) xyz(j,1)]';
    Y = [ xyz(i,2) xyz(j,2)]';
    Z = [ xyz(i,3) xyz(j,3)]';
else
    X=[];
    Y=[];
    Z=[];
end

