% INITIMAGE  Initialize image manager structures

subImage.numCells = imageGrid;
subImage.lines  = zeros(subImage.numCells); % lines per cell
subImage.init   = zeros(subImage.numCells); % lines to init per cell
subImage.rights = round((0:subImage.numCells)*Cam.imSize(1)/subImage.numCells); % cell right borders
subImage.botts  = round((0:subImage.numCells)*Cam.imSize(2)/subImage.numCells); % cell bottom borders

