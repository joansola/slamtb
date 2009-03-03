function dispMapObj = dispMapObjs(dispMapObj,Obj,maxObj,ns)

% DISPMAPOBJS  display map objects

global  WDIM

% points
usedObjs = [Obj.used]; % used points

rr = 1:WDIM;

% ellipses
for i = 1:maxObj
   if ~isempty(usedObjs) && usedObjs(i)
      x = Obj(i).xW(rr);
      P = Obj(i).PrW;
      [ellix,elliy,elliz] = cov3elli(x,P,ns,16);
   else
      ellix = [];
      elliy = [];
      elliz = [];
   end
   set(dispMapObj.elli(i),...
      'xdata',ellix,...
      'ydata',elliy,...
      'zdata',elliz)
end

% centers
if any(usedObjs)
   objIdx = find(usedObjs);
   uX = [Obj(objIdx).xW];
   ux = uX(1:WDIM,:);
   uXx = uX(1,:);
   uXy = uX(2,:);
   uXz = uX(3,:);
else
   uXx = [];
   uXy = [];
   uXz = [];
end
set(dispMapObj.center,'xdata',uXx,'ydata',uXy,'zdata',uXz);


