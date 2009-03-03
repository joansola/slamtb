function region = numInit(region)

% NUMINIT  Number of landmarks to init per region

init0  = region.minReg - region.numLmk;
init0(init0<0) = 0; % number of lmks to init. per region (a priori)

region.numInit = init0;
