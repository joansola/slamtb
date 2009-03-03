%function Obj = initObjs(maxObj)

% INITOBJS  Initialize objects structure array
%   OBJ = INITOBJS(NOBJS) initializes points structure OBJ and
%   sets all NOBJS objects to the initial null state by doing:
%
%   See also FILLPNTS, FILLRAYS, INITLMKS


for i = 1:maxObj
    Obj(i)       = emptyObj(2); % Objects structure array
end    

