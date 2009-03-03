function Pnt = ray2point(Ray)

% RAY2POINT  Ray to point transition
%   RAY2POINT(RAY) takes the first point of the RAY and 
%   transfer it to a single point type landmark by
%   updating tables pntLm and rayLm and map Map:
%     The point is added to pntLm
%     The ray is deleted from rayLm
%     The point is then moved to the lowest available 
%       position in the global structure Map.
%
%   See also MOVELANDMARK, GETLOC

global pntTab rayTab

% delete ray from table
rayTab(:,Ray.idx) = [];

% update points table
Pnt.id = Ray.id;
Pnt.loc = Ray.loc(1);
pntTab = [pntTab [Pnt.id;Pnt.loc]];

% get point index in points table
Pnt.idx = size(pntTab,2);

