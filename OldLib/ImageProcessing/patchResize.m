function rpatch = patchResize(opatch,r)

% PATCHRESIZE  Patch resize.
%   PATCHRESIZE(PATCH,R)  resizes the image of PATCH.I by a
%   factor R and crops the result to size(PATCH.I). Works only
%   for square patch images. See PIX2PATCH for information about
%   the structure PATCH.
%
%   See also PIX2PATCH, PATCHSCAN

% (c) 2006 Joan Sola @ LAAS-CNRS

I    = single(opatch.I);

% J = single(imresize2(I,r));
J = imresize2(I,r);

rpatch.I    = J;
rpatch.SI   = sum(sum(J));
rpatch.SII  = sum(sum(J.*J));
rpatch.bias = opatch.bias;
