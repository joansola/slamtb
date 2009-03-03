function pix = robCamPhotoNoise(R,cam,p,noise)

% ROBCAMPHOTONOISE noisy version of ROBCAMPHOTO
%   PIX = ROBCAMPHOTONOISE(R,CAM,P,NOISE) is simply:
%
%      PIX = ROBCAMPHOTO(R,CAM,P) + randn(2,1).*NOISE
%
% See also ROBCAMPHOTO

global BDIM

pix = robCamPhoto(R,cam,p)+randn(BDIM,1).*noise;
