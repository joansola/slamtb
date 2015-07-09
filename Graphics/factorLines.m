function [X,Y,Z] = factorLines(A,xyz)

%GPLOT Plot graph, as in "graph theory".
%   GPLOT(A,xy) plots the graph specified by A and xy. A graph, G, is
%   a set of nodes numbered from 1 to n, and a set of connections, or
%   edges, between them.  
%
%   In order to plot G, two matrices are needed. The adjacency matrix,
%   A, has a(i,j) nonzero if and only if node i is connected to node
%   j.  The coordinates array, xy, is an n-by-2 matrix with the
%   position for node i in the i-th row, xy(i,:) = [x(i) y(i)].
%   
%   GPLOT(A,xy,LineSpec) uses line type and color specified in the
%   string LineSpec. See PLOT for possibilities.
%
%   [X,Y] = GPLOT(A,xy) returns the NaN-punctuated vectors
%   X and Y without actually generating a plot. These vectors
%   can be used to generate the plot at a later time if desired.  As a
%   result, the two argument output case is only valid when xy is of type
%   single or double.
%   
%   See also SPY, TREEPLOT.

%   John Gilbert
%   Copyright 1984-2009 The MathWorks, Inc. 
%   $Revision: 5.12.4.4 $  $Date: 2009/04/21 03:26:12 $

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
% line(X,Y,Z,'LineStyle',lsty,'Color',csty,'Marker',msty);
% set(h,'xdata',X,'ydata',Y,'zdata',Z);

