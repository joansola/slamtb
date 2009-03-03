function region = countObjs(region,Obj)


visObjIdx = find([Obj.used]&[Obj.vis0]);
nVisObjs  = numel(visObjIdx);

if nVisObjs ~= 0
   visObjs    = Obj(visObjIdx);
   visObjsPrj = [visObjs.Prj];
   visObjs1   = visObjsPrj(1:2:end);
   ou         = [visObjs1.u];
else
   ou = [0;0];
end

s = size(region.numLmk,2);

for i=1:s
   % region origin and size
   u0 = region.u0(:,i);
   du = region.size(:,i);

   % check for objects
   ou1ok = (ou(1,:) > u0(1)) & (ou(1,:) < u0(1)+du(1));
   ou2ok = (ou(2,:) > u0(2)) & (ou(2,:) < u0(2)+du(2));

   ouok = ou1ok & ou2ok;
   souok = sum(ouok);

   region.numPnt(i) = souok;

   % Total landmarks
   region.numLmk(i) = souok;
end

% Number of objects to init
region.numInit = (region.numPnt==0)&region.minReg; % 1 obj per empty cell

