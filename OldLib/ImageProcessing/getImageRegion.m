function im = getImageRegion(imId,region,i,mrg)

% GETIMAGEREGION  Get image region
%   IM = GETIMAGEREGION(IMID,REG,I)  gets a sub-image IM from the
%   global image Image{IMID} corresponding to the rectangular
%   region defined in the I-th region in REG. REG is a structure
%   containing, at least:
%     .u0=[u01 u02 ... u0n] where
%       u0i: origin of region i [row;column]
%     .size = [sz1 sz2 ... szn] where
%       szi: size of region i [rows;columns]
%
% GETIMAGEREGION(...,MRG)  majorates the image size by MRG pixels
% on both sides of the vertical and horizontal dimensions.
%
%   See also NHARRIS

% (c) 2005 Joan Sola

global Image

if nargin < 4
    mrg = 0;
end

u0 = region.u0(1,i)-mrg; % origin column
v0 = region.u0(2,i)-mrg; % origin row

du = region.size(1,i)+2*mrg; % size in columns
dv = region.size(2,i)+2*mrg; % size in rows

ur = [u0:u0+du-1]; % columns
vr = [v0:v0+dv-1]; % rows

im = Image{imId}(vr,ur);
