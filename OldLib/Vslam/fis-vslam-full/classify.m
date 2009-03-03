function [visNew,visPnt,visRay,lstRay] = classify(visTab,Ng)

% CLASSIFY  Landmark classification
%   [VISNEW,VISPNT] = CLASSIFY(VISLM) selects from
%     the visible landmarks table VISTAB those that are
%     points in the map, specified in global PNTTAB, and return 
%     them in another landmark table VISPNT. The rest 
%     of points are classified new and are returned 
%     in VISNEW.
%   The landmark table formats are as follows:
%     PNTTAB = [p1 p2 ... pM] with pj = [id;loc]
%     VISTAB = [p1 p2 ... pN] with pi = [id;x;y;z]
%     VISNEW = [p1 p2 ... pn] with pi = [id;x;y;z]
%     VISPNT = [p1 p2 ... pm] with pj = [id;x;y;z;loc]
%   where: 
%     id:    landmark identifier
%     x,y,z: 3D point coordinates in the world
%     loc:   location of point lm in the map
%  
%   [VISNEW,VISPNT,VISRAY] = CLASSIFY(VISTAB,Ng)
%     allows for a third group of landmarks, the Rays,
%     specified in global RAYTAB and returned in VISRAY.
%   Additional landmark tables are:
%     RAYTAB  = [p1 p2 ... pL] with pk = [id;n;loc;w]
%     VISRAY = [p1 p2 ... pl] with pk = [id;x;y;z;n;loc,w]
%   where:
%     n:     current number of points in the ray
%     loc = [loc1;...;locn;...;locNg]
%     loci:  location of point i in map
%     w = [w1;...;wn;...;wNg]
%     wi:    weight of point i in ray
%     Ng:    maximum number of points per ray
%
%   [VISNEW,VISPNT,VISRAY,LSTRAY] = CLASSIFY(VISTAB,Ng) returns
%   also a lost rays table LSTRAY with all the rays in RAYTAB 
%   that are not in VISTAB.

global pntTab rayTab

if ((nargin == 1) & (nargout == 2))...
        | ((nargin == 2) & ((nargout == 3) | (nargout == 4))) 
    
    % input sub-tables
    visIds = visTab(1,:);   % visible Identifiers
    visPos = visTab(2:4,:); % visible positions xyz
    if isempty(pntTab) % for points
        pntIds = [];
        pntLoc = [];
    else
        pntIds = pntTab(1,:);   % point identifiers
        pntLoc = pntTab(2,:);   % point location in map
    end
    
    % intermediate sub-tables
    visNewIds = visIds; % we will delete all visible points
    visNewPos = visPos;
    visPntIds = [];     % we will add all visible points
    visPntPos = [];
    visPntLoc = [];

    if nargin == 2     % for rays
        if isempty(rayTab) 
            rayIds = [];
            rayNbr = [];
            rayLoc = [];
            rayWgt = [];
        else
            rayIds = rayTab(1,:);   % ray identifiers
            rayNbr = rayTab(2,:);   % number of points in ray
            rayLoc = rayTab(3:Ng+2,:);   % point locations in map
            rayWgt = rayTab(Ng+3:end,:); % point weights
        end
        visRayIds = [];     % we will add all visible rays
        visRayPos = [];
        visRayNbr = [];
        visRayLoc = [];
        visRayWgt = [];
        lstRayIds = rayIds; % we will delete visible rays
        lstRayNbr = rayNbr;
        lstRayLoc = rayLoc;
    end
    
    % search points
    for i = 1:length(pntIds)
        n = length(visNewIds);
        lmId = pntIds(i);
        index = find(visNewIds == lmId);
        if ~isempty(index)
            nindex = [1:index-1 index+1:n];
            visPntIds = [visPntIds lmId];
            visPntPos = [visPntPos visNewPos(:,index)];
            visPntLoc = [visPntLoc pntLoc(i)];
            visNewIds = visNewIds(nindex);
            visNewPos = visNewPos(:,nindex);
        end
    end

    if nargin == 2 % search rays
        lstIdx = []; % index to lost rays table
        for i = 1:length(rayIds)
            n = length(visNewIds);
            lmId = rayIds(i);
            index = find(visNewIds == lmId);
            if ~isempty(index)
                nindex = [1:index-1 index+1:n];
                visRayIds = [visRayIds lmId];
                visRayPos = [visRayPos visNewPos(:,index)];
                visRayNbr = [visRayNbr rayNbr(i)];
                visRayLoc = [visRayLoc rayLoc(:,i)];
                visRayWgt = [visRayWgt rayWgt(:,i)];
                visNewIds = visNewIds(nindex);
                visNewPos = visNewPos(:,nindex);
                lstIdx = [lstIdx i];
            end
        end
        lstRayIds(lstIdx) = [];
        lstRayNbr(lstIdx) = [];
        lstRayLoc(:,lstIdx) = [];
    end
    
    % build outputs
    visNew = [visNewIds;visNewPos];
    visPnt = [visPntIds;visPntPos;visPntLoc];
    visRay = [visRayIds;visRayPos;visRayNbr;visRayLoc;visRayWgt];
    lstRay = [lstRayIds;lstRayNbr;lstRayLoc];
    
else
    error ('Bad number of arguments')
end
